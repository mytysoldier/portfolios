from __future__ import annotations

import json
import os
import re
from typing import Any, Dict, List, Optional

from langchain_core.messages import HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI
from langchain_google_genai import ChatGoogleGenerativeAI

from .config import LLMProvider, Settings, get_settings


class ProviderNotConfiguredError(Exception):
    """
    LLM プロバイダの設定（API キーやモデル名など）が不足している場合に投げる例外。
    """


class LLMError(Exception):
    """
    LLM 呼び出しそのものが失敗した場合に投げる例外。
    """


# LangSmith の初期化（環境変数が設定されていれば自動でトレースされる）
def _init_langsmith_if_needed() -> None:
    """
    LANGCHAIN_TRACING_V2=true かつ LANGCHAIN_API_KEY が設定されていれば、
    環境変数を設定して LangSmith トレースを有効化する。
    
    注意: この関数は環境変数を直接読み込むため、.env ファイルの変更が反映されます。
    """
    # 環境変数を直接読み込む（get_settings() のキャッシュを回避）
    tracing_v2 = os.getenv("LANGCHAIN_TRACING_V2", "").lower() == "true"
    api_key = os.getenv("LANGCHAIN_API_KEY")
    project = os.getenv("LANGCHAIN_PROJECT", "default")
    
    if tracing_v2 and api_key:
        os.environ["LANGCHAIN_TRACING_V2"] = "true"
        os.environ["LANGCHAIN_API_KEY"] = api_key
        os.environ["LANGCHAIN_PROJECT"] = project
        # デバッグ用（本番環境では削除してもOK）
        print(f"[LangSmith] トレースを有効化しました。プロジェクト: {project}")


# アプリ起動時に一度だけ実行
_init_langsmith_if_needed()


_openai_chat_model: Optional[ChatOpenAI] = None
_gemini_chat_model: Optional[ChatGoogleGenerativeAI] = None


def _ensure_openai_chat_model() -> ChatOpenAI:
    """
    LangChain の ChatOpenAI を初期化して返す。
    設定が足りない場合は ProviderNotConfiguredError を投げる。
    """
    global _openai_chat_model

    settings = get_settings()
    if (
        settings.llm_provider != LLMProvider.OPENAI
        or not settings.openai_api_key
        or not settings.openai_model
    ):
        raise ProviderNotConfiguredError("OpenAI が正しく設定されていません。")

    if _openai_chat_model is None:
        _openai_chat_model = ChatOpenAI(
            model=settings.openai_model,
            api_key=settings.openai_api_key,
            temperature=0.3,
        )

    return _openai_chat_model


def _ensure_gemini_chat_model() -> ChatGoogleGenerativeAI:
    """
    LangChain の ChatGoogleGenerativeAI を初期化して返す。
    設定が足りない場合は ProviderNotConfiguredError を投げる。
    """
    global _gemini_chat_model

    settings = get_settings()
    if (
        settings.llm_provider != LLMProvider.GEMINI
        or not settings.gemini_api_key
        or not settings.gemini_model
    ):
        raise ProviderNotConfiguredError("Gemini が正しく設定されていません。")

    if _gemini_chat_model is None:
        _gemini_chat_model = ChatGoogleGenerativeAI(
            model=settings.gemini_model,
            google_api_key=settings.gemini_api_key,
            temperature=0.3,
        )

    return _gemini_chat_model


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
    chat_model = _ensure_openai_chat_model()
    system_msg = _build_summarize_system_message(style)

    try:
        messages = [
            SystemMessage(content=system_msg),
            HumanMessage(
                content=f"次のテキストを最大 {max_chars} 文字以内で日本語で要約してください。\n\n{text}"
            ),
        ]
        response = chat_model.invoke(messages)
        return response.content or ""
    except Exception as e:
        raise LLMError(f"OpenAI summarize でエラーが発生しました: {e}") from e


def _summarize_with_gemini(text: str, max_chars: int, style: Optional[str]) -> str:
    chat_model = _ensure_gemini_chat_model()
    system_msg = _build_summarize_system_message(style)

    try:
        messages = [
            SystemMessage(content=system_msg),
            HumanMessage(
                content=f"次のテキストを最大 {max_chars} 文字以内で日本語で要約してください。\n\n{text}"
            ),
        ]
        response = chat_model.invoke(messages)
        return response.content or ""
    except Exception as e:
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
    user_content = _build_rewrite_prompt(text, tone, max_chars, keep_meaning)

    try:
        messages = [
            SystemMessage(content="あなたは日本語の文章スタイル変換アシスタントです。"),
            HumanMessage(content=user_content),
        ]
        # rewrite は temperature を少し上げる
        chat_model_temp = ChatOpenAI(
            model=settings.openai_model,  # type: ignore[arg-type]
            api_key=settings.openai_api_key,
            temperature=0.5,
        )
        response = chat_model_temp.invoke(messages)
        return response.content or ""
    except Exception as e:
        raise LLMError(f"OpenAI rewrite でエラーが発生しました: {e}") from e


def _rewrite_with_gemini(
    text: str,
    tone: str,
    max_chars: Optional[int],
    keep_meaning: Optional[bool],
) -> str:
    settings = get_settings()
    chat_model = _ensure_gemini_chat_model()
    user_content = _build_rewrite_prompt(text, tone, max_chars, keep_meaning)

    try:
        messages = [
            SystemMessage(content="あなたは日本語の文章スタイル変換アシスタントです。"),
            HumanMessage(content=user_content),
        ]
        # rewrite は temperature を少し上げる
        chat_model_temp = ChatGoogleGenerativeAI(
            model=settings.gemini_model,  # type: ignore[arg-type]
            google_api_key=settings.gemini_api_key,
            temperature=0.5,
        )
        response = chat_model_temp.invoke(messages)
        return response.content or ""
    except Exception as e:
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
    """
    extract 用のプロンプトを構築。
    JSON schema の例も含めて明確に指示する。
    """
    return (
        "次のテキストから重要なポイントを日本語で要約し、"
        f"最大 {max_items} 個まで JSON 配列（文字列の配列）で返してください。\n"
        "返答は JSON のみとし、説明文やコードブロック記号は一切含めないでください。\n"
        "フォーマット例: [\"ポイント1\", \"ポイント2\", \"ポイント3\"]\n"
        "JSON 以外の文字列は返さないでください。"
    )


def _extract_with_openai(text: str, max_items: int) -> str:
    settings = get_settings()
    instruction = _build_extract_instruction(max_items)

    try:
        messages = [
            SystemMessage(
                content="あなたは入力テキストの要点を抽出し、JSON 形式で返すアシスタントです。JSON のみを返し、説明文は一切含めないでください。"
            ),
            HumanMessage(content=instruction + "\n\nテキスト:\n" + text),
        ]
        # extract は temperature を低めに
        chat_model_temp = ChatOpenAI(
            model=settings.openai_model,  # type: ignore[arg-type]
            api_key=settings.openai_api_key,
            temperature=0.3,
        )
        response = chat_model_temp.invoke(messages)
        return response.content or ""
    except Exception as e:
        raise LLMError(f"OpenAI extract でエラーが発生しました: {e}") from e


def _extract_with_gemini(text: str, max_items: int) -> str:
    settings = get_settings()
    chat_model = _ensure_gemini_chat_model()
    instruction = _build_extract_instruction(max_items)

    try:
        messages = [
            SystemMessage(
                content="あなたは入力テキストの要点を抽出し、JSON 形式で返すアシスタントです。JSON のみを返し、説明文は一切含めないでください。"
            ),
            HumanMessage(content=instruction + "\n\nテキスト:\n" + text),
        ]
        # extract は temperature を低めに
        chat_model_temp = ChatGoogleGenerativeAI(
            model=settings.gemini_model,  # type: ignore[arg-type]
            google_api_key=settings.gemini_api_key,
            temperature=0.3,
        )
        response = chat_model_temp.invoke(messages)
        return response.content or ""
    except Exception as e:
        raise LLMError(f"Gemini extract でエラーが発生しました: {e}") from e


def _clean_json_block(raw: str) -> str:
    """
    LLM から返ってきた文字列から、JSON 部分だけを取り出すためのクリーナー。
    ```json ... ``` 形式にも対応する。
    """
    cleaned = raw.strip()

    # コードブロック記号を除去
    if cleaned.startswith("```"):
        # ```json や ``` を削除
        cleaned = re.sub(r"^```(?:json)?\s*", "", cleaned, flags=re.IGNORECASE)
        cleaned = re.sub(r"\s*```$", "", cleaned)
        cleaned = cleaned.strip()

    return cleaned


def _parse_extract_items_fallback(text: str, max_items: int) -> List[Dict[str, Any]]:
    """
    JSON パースに失敗した場合のフォールバック処理。
    テキストを行分割して max_items に丸めた items を生成する。
    """
    # 改行や句点で分割
    lines = re.split(r"[\n。\.\?\!！？]", text)
    items = [line.strip() for line in lines if line.strip()]
    # max_items に制限
    items = items[:max_items]
    return [{"text": item, "confidence": 1.0} for item in items]


def _parse_extract_items(cleaned: str, max_items: int, original_text: str) -> List[Dict[str, Any]]:
    """
    JSON 文字列をパースして [{text, confidence}] のリストに変換する。
    パースに失敗した場合はフォールバック処理を実行。
    """
    # まず JSON として直接パースを試す
    try:
        items_raw = json.loads(cleaned)
    except json.JSONDecodeError:
        # コードブロックを除去して再試行
        cleaned_again = _clean_json_block(cleaned)
        try:
            items_raw = json.loads(cleaned_again)
        except json.JSONDecodeError:
            # それでもダメならフォールバック
            return _parse_extract_items_fallback(original_text, max_items)

    if not isinstance(items_raw, list):
        # 配列でない場合もフォールバック
        return _parse_extract_items_fallback(original_text, max_items)

    results: List[Dict[str, Any]] = []
    for item in items_raw[:max_items]:
        if not isinstance(item, str):
            continue
        results.append({"text": item.strip(), "confidence": 1.0})

    # 結果が空の場合はフォールバック
    if not results:
        return _parse_extract_items_fallback(original_text, max_items)

    return results


def extract(text: str, max_items: int) -> List[Dict[str, Any]]:
    """
    テキストから要点を最大 max_items 個まで抽出し、
    [{\"text\": str, \"confidence\": float}] の形式で返す。
    confidence は 1.0 固定。

    JSON パースに失敗した場合は、フォールバック処理として
    テキストを行分割して items を生成する。
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
    return _parse_extract_items(cleaned, max_items, original_text=text)
