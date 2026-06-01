"""Slack DM レポート（SLACK_BOT_TOKEN + SLACK_DM_USER_ID、gmail-auto-clean-ts と同 API フロー）。"""

from __future__ import annotations

import logging
import os
from typing import Any

import httpx

from news.models import Article, NewsPickResult

logger = logging.getLogger(__name__)

_SLACK_API = "https://slack.com/api"
_MAX_CHUNK = 3800


def _escape_mrkdwn(text: str) -> str:
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def _slack_api(
    client: httpx.Client, token: str, method: str, body: dict[str, Any]
) -> dict[str, Any]:
    res = client.post(
        f"{_SLACK_API}/{method}",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json; charset=utf-8",
        },
        json=body,
    )
    res.raise_for_status()
    return res.json()


def _resolve_slack_dm_user_id() -> str | None:
    return (os.getenv("SLACK_DM_USER_ID") or "").strip() or None


def _open_dm_channel(client: httpx.Client, token: str, user_id: str) -> str:
    data = _slack_api(
        client, token, "conversations.open", {"users": user_id}
    )
    if not data.get("ok") or not data.get("channel", {}).get("id"):
        raise RuntimeError(
            f"conversations.open: {data.get('error', 'unknown')}"
        )
    return data["channel"]["id"]


def _post_message(
    client: httpx.Client, token: str, channel: str, text: str
) -> None:
    data = _slack_api(
        client,
        token,
        "chat.postMessage",
        {"channel": channel, "text": text, "mrkdwn": True},
    )
    if not data.get("ok"):
        raise RuntimeError(
            f"chat.postMessage: {data.get('error', 'unknown')}"
        )


def _chunk_string(s: str, max_len: int) -> list[str]:
    if len(s) <= max_len:
        return [s]
    return [s[i : i + max_len] for i in range(0, len(s), max_len)]


def _method_label(method: str) -> str:
    return "OpenAI" if method == "openai" else "フォールバック（RSS そのまま）"


def _format_article_line(index: int, article: Article) -> str:
    h = _escape_mrkdwn
    title = h(article.title or "(タイトルなし)")
    source = h(article.source or "(ソース不明)")
    published = h(article.published or "日時不明")
    url = h(article.url or "")
    return f"{index}. *{title}*\n   {source} | {published}\n   {url}"


def build_slack_news_report(result: NewsPickResult) -> list[str]:
    h = _escape_mrkdwn
    mode = h(_method_label(result.selection_method))
    header = (
        f"*技術ニュース選別レポート*（判定: {mode}）\n"
        f"取得 *{result.fetched_count}* 件 / "
        f"候補 *{result.candidate_count}* 件 / "
        f"選別 *{result.selected_count}* 件\n"
    )

    articles = result.articles
    if not articles:
        body = "*おすすめ記事* — 0 件\n_（なし）_\n"
    else:
        lines = "\n".join(
            _format_article_line(i + 1, a) for i, a in enumerate(articles)
        )
        body = f"*おすすめ記事* — {len(articles)} 件\n{lines}\n"

    return _chunk_string(f"{header}\n{body}", _MAX_CHUNK)


def send_slack_news_report(result: NewsPickResult) -> bool:
    """
    gmail-auto-clean-ts と同じ DM 先へレポートを送る。
    トークン未設定時はスキップし False。送信成功で True。
    """
    token = (os.getenv("SLACK_BOT_TOKEN") or "").strip()
    if not token:
        logger.info("Slack 通知スキップ: SLACK_BOT_TOKEN 未設定")
        return False

    try:
        with httpx.Client(timeout=30.0) as client:
            user_id = _resolve_slack_dm_user_id()
            if not user_id:
                logger.info("Slack 通知スキップ: SLACK_DM_USER_ID 未設定")
                return False

            channel = _open_dm_channel(client, token, user_id)
            chunks = build_slack_news_report(result)
            for i, chunk in enumerate(chunks):
                prefix = (
                    f"（{i + 1}/{len(chunks)}）\n" if len(chunks) > 1 else ""
                )
                _post_message(client, token, channel, prefix + chunk)

        logger.info("Slack DM でレポートを送信しました")
        return True
    except Exception:
        logger.exception("Slack 送信エラー")
        return False
