from __future__ import annotations

import json
from typing import Any, Dict, List, Optional

from openai import OpenAI, OpenAIError
import google.generativeai as genai

from .config import LLMProvider, Settings, get_settings


class ProviderNotConfiguredError(Exception):
    """
    LLM プロバイダの設定（API キーやモデル名など）が不足している場合に投げる例外。
    """


class LLMError(Exception):
    """
    LLM 呼び出しそのものが失敗した場合に投げる例外。
    """


_openai_client: Optional[OpenAI] = None
_gemini_model: Optional[genai.GenerativeModel] = None


def _ensure_openai() -> OpenAI:
    """
    OpenAI クライアントを初期化して返す。
    設定が足りない場合は ProviderNotConfiguredError を投げる。
    """
    global _openai_client

    settings = get_settings()
    if (
        settings.llm_provider != LLMProvider.OPENAI
        or not settings.openai_api_key
        or not settings.openai_model
    ):
        raise ProviderNotConfiguredError("OpenAI が正しく設定されていません。")

    if _openai_client is None:
        _openai_client = OpenAI(api_key=settings.openai_api_key)

    return _openai_client


def _ensure_gemini() -> genai.GenerativeModel:
    """
    Gemini モデルを初期化して返す。
    設定が足りない場合は ProviderNotConfiguredError を投げる。
    """
    global _gemini_model

    settings = get_settings()
    if (
        settings.llm_provider != LLMProvider.GEMINI
        or not settings.gemini_api_key
        or not settings.gemini_model
    ):
        raise ProviderNotConfiguredError("Gemini が正しく設定されていません。")

    if _gemini_model is None:
        genai.configure(api_key=settings.gemini_api_key)
        _gemini_model = genai.GenerativeModel(settings.gemini_model)

    return _gemini_model


def _validate_single_provider_configured(settings: Settings) -> None:
    """
    OpenAI / Gemini の設定が「どちらか一方だけ」になっているかを検証する。
    - 両方とも有効 → エラー
    - 両方とも無効 → エラー
    """
    openai_configured = bool(settings.openai_api_key and settings.openai_model)
    gemini_configured = bool(settings.gemini_api_key and settings.gemini_model)

    if openai_configured and gemini_configured:
        raise ProviderNotConfiguredError(
            "OpenAI と Gemini の設定が両方有効になっています。どちらか一方のみ設定してください。"
        )
    if not openai_configured and not gemini_configured:
        raise ProviderNotConfiguredError(
            "OpenAI か Gemini のどちらか一方の設定を行ってください。"
        )


def _build_summarize_system_message(style: Optional[str]) -> str:
    base = (
        "あなたは日本語のプロの要約アシスタントです。"
        "重要な情報をできるだけ落とさずに、指定された最大文字数以内で自然な日本語に要約してください。"
    )
    if style:
        base += f" 要約のスタイルのヒント: {style}。"
    return base


def _summarize_with_openai(text: str, max_chars: int, style: Optional[str]) -> str:
    settings = get_settings()
    client = _ensure_openai()
    system_msg = _build_summarize_system_message(style)

    try:
        resp = client.chat.completions.create(
            model=settings.openai_model,  # type: ignore[arg-type]
            messages=[
                {"role": "system", "content": system_msg},
                {
                    "role": "user",
                    "content": (
                        f"次のテキストを最大 {max_chars} 文字以内で日本語で要約してください。\n\n{text}"
                    ),
                },
            ],
            temperature=0.3,
        )
        return resp.choices[0].message.content or ""
    except OpenAIError as e:
        raise LLMError(f"OpenAI summarize でエラーが発生しました: {e}") from e


def _summarize_with_gemini(text: str, max_chars: int, style: Optional[str]) -> str:
    system_msg = _build_summarize_system_message(style)
    prompt = (
        system_msg
        + "\n\n"
        + f"次のテキストを最大 {max_chars} 文字以内で日本語で要約してください。\n\n{text}"
    )

    model = _ensure_gemini()
    try:
        resp = model.generate_content(prompt)
        return resp.text or ""
    except Exception as e:  # pragma: no cover - SDK 由来の例外を包括
        raise LLMError(f"Gemini summarize でエラーが発生しました: {e}") from e


def summarize(text: str, max_chars: int, style: Optional[str] = None) -> str:
    """
    テキストを max_chars 文字以内で日本語要約する。
    style は現時点ではプロンプトのヒントとしてのみ利用。
    """
    settings = get_settings()
    _validate_single_provider_configured(settings)

    if settings.llm_provider == LLMProvider.OPENAI:
        summary = _summarize_with_openai(text=text, max_chars=max_chars, style=style)
    elif settings.llm_provider == LLMProvider.GEMINI:
        summary = _summarize_with_gemini(text=text, max_chars=max_chars, style=style)
    else:
        raise ProviderNotConfiguredError("LLM_PROVIDER が openai か gemini に設定されていません。")

    # 念のためサーバ側でも max_chars で切り詰める
    return summary.strip()[:max_chars]


def _build_rewrite_prompt(
    text: str,
    tone: str,
    max_chars: Optional[int],
    keep_meaning: Optional[bool],
) -> str:
    tone_desc = {
        "polite": "丁寧で礼儀正しい文体（です・ます調）",
        "casual": "フランクで砕けたカジュアルな文体",
        "business": "ビジネス文書向けのフォーマルな文体",
        "friendly": "親しみやすく柔らかい文体",
    }.get(tone, tone)

    meaning_instruction = (
        "元の意味やニュアンスをできるだけ保ったまま書き換えてください。"
        if keep_meaning
        else "必要であれば表現やニュアンスを調整して構いません。"
    )

    length_instruction = (
        f"最大 {max_chars} 文字以内に収めてください。" if max_chars is not None else ""
    )

    return (
        f"次のテキストを「{tone_desc}」になるように日本語で書き換えてください。\n"
        f"{meaning_instruction} {length_instruction}\n\n{text}"
    )


def _rewrite_with_openai(
    text: str,
    tone: str,
    max_chars: Optional[int],
    keep_meaning: Optional[bool],
) -> str:
    settings = get_settings()
    client = _ensure_openai()
    user_content = _build_rewrite_prompt(text, tone, max_chars, keep_meaning)

    try:
        resp = client.chat.completions.create(
            model=settings.openai_model,  # type: ignore[arg-type]
            messages=[
                {
                    "role": "system",
                    "content": "あなたは日本語の文章スタイル変換アシスタントです。",
                },
                {"role": "user", "content": user_content},
            ],
            temperature=0.5,
        )
        return resp.choices[0].message.content or ""
    except OpenAIError as e:
        raise LLMError(f"OpenAI rewrite でエラーが発生しました: {e}") from e


def _rewrite_with_gemini(
    text: str,
    tone: str,
    max_chars: Optional[int],
    keep_meaning: Optional[bool],
) -> str:
    user_content = _build_rewrite_prompt(text, tone, max_chars, keep_meaning)
    model = _ensure_gemini()

    try:
        resp = model.generate_content(
            "あなたは日本語の文章スタイル変換アシスタントです。\n\n" + user_content
        )
        return resp.text or ""
    except Exception as e:  # pragma: no cover
        raise LLMError(f"Gemini rewrite でエラーが発生しました: {e}") from e


def rewrite(
    text: str,
    tone: str,
    max_chars: Optional[int] = None,
    keep_meaning: Optional[bool] = True,
) -> str:
    """
    tone に応じてテキストを書き換える。
    - tone: polite / casual / business / friendly
    - keep_meaning: True の場合は意味を変えない範囲で調整
    """
    settings = get_settings()
    _validate_single_provider_configured(settings)

    if settings.llm_provider == LLMProvider.OPENAI:
        rewritten = _rewrite_with_openai(text, tone, max_chars, keep_meaning)
    elif settings.llm_provider == LLMProvider.GEMINI:
        rewritten = _rewrite_with_gemini(text, tone, max_chars, keep_meaning)
    else:
        raise ProviderNotConfiguredError("LLM_PROVIDER が openai か gemini に設定されていません。")

    rewritten = rewritten.strip()
    if max_chars is not None:
        rewritten = rewritten[:max_chars]
    return rewritten


def _build_extract_instruction(max_items: int) -> str:
    return (
        "次のテキストから重要なポイントを日本語で要約し、"
        f"最大 {max_items} 個まで JSON 配列（文字列の配列）で返してください。"
        'フォーマットは例えば ["ポイント1", "ポイント2"] のみとし、説明文は書かないでください。'
    )


def _extract_with_openai(text: str, max_items: int) -> str:
    settings = get_settings()
    client = _ensure_openai()
    instruction = _build_extract_instruction(max_items)

    try:
        resp = client.chat.completions.create(
            model=settings.openai_model,  # type: ignore[arg-type]
            messages=[
                {
                    "role": "system",
                    "content": "あなたは入力テキストの要点を抽出し、JSON 形式で返すアシスタントです。",
                },
                {
                    "role": "user",
                    "content": instruction + "\n\nテキスト:\n" + text,
                },
            ],
            temperature=0.3,
        )
        return resp.choices[0].message.content or ""
    except OpenAIError as e:
        raise LLMError(f"OpenAI extract でエラーが発生しました: {e}") from e


def _extract_with_gemini(text: str, max_items: int) -> str:
    instruction = _build_extract_instruction(max_items)
    model = _ensure_gemini()

    try:
        resp = model.generate_content(
            "あなたは入力テキストの要点を抽出し、JSON 形式で返すアシスタントです。\n\n"
            + instruction
            + "\n\nテキスト:\n"
            + text
        )
        return resp.text or ""
    except Exception as e:  # pragma: no cover
        raise LLMError(f"Gemini extract でエラーが発生しました: {e}") from e


def _clean_json_block(raw: str) -> str:
    """
    LLM から返ってきた文字列から、JSON 部分だけを取り出すための簡易クリーナー。
    ```json ... ``` 形式にもある程度対応する。
    """
    cleaned = raw.strip()
    if cleaned.startswith("```"):
        # ```json ... ``` や ``` ... ``` を削る
        cleaned = cleaned.strip("`")
        # 言語ラベルを除いた後ろ側だけを使う
        if "\n" in cleaned:
            cleaned = cleaned.split("\n", 1)[1]
        if "```" in cleaned:
            cleaned = cleaned.rsplit("```", 1)[0]
        cleaned = cleaned.strip()
    return cleaned


def _parse_extract_items(cleaned: str, max_items: int) -> List[Dict[str, Any]]:
    try:
        items_raw = json.loads(cleaned)
    except json.JSONDecodeError as e:
        raise LLMError(f"抽出結果の JSON パースに失敗しました: {e}. raw={cleaned!r}") from e

    if not isinstance(items_raw, list):
        raise LLMError("抽出結果が JSON 配列ではありません。")

    results: List[Dict[str, Any]] = []
    for item in items_raw[:max_items]:
        if not isinstance(item, str):
            continue
        results.append({"text": item.strip(), "confidence": 1.0})
    return results


def extract(text: str, max_items: int) -> List[Dict[str, Any]]:
    """
    テキストから要点を最大 max_items 個まで抽出し、
    [{\"text\": str, \"confidence\": float}] の形式で返す。
    confidence は 1.0 固定でよい前提。
    """
    settings = get_settings()
    _validate_single_provider_configured(settings)

    if settings.llm_provider == LLMProvider.OPENAI:
        raw = _extract_with_openai(text, max_items)
    elif settings.llm_provider == LLMProvider.GEMINI:
        raw = _extract_with_gemini(text, max_items)
    else:
        raise ProviderNotConfiguredError("LLM_PROVIDER が openai か gemini に設定されていません。")

    cleaned = _clean_json_block(raw)
    return _parse_extract_items(cleaned, max_items)



