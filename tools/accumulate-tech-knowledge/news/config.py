import os

DEFAULT_RSS_MAX_PER_FEED = 15
DEFAULT_NEWS_CANDIDATE_MAX = 30


def _env_positive_int(name: str, default: int) -> int:
    raw = os.getenv(name, "").strip()
    if not raw:
        return default
    try:
        value = int(raw)
    except ValueError as exc:
        raise ValueError(f"{name} は正の整数で指定してください: {raw!r}") from exc
    if value < 1:
        raise ValueError(f"{name} は 1 以上にしてください: {value}")
    return value


def get_feed_urls() -> list[str]:
    raw = os.getenv("RSS_FEED_URLS", "").strip()
    if not raw:
        raise ValueError(
            "RSS_FEED_URLS が未設定です。"
            "ローカルでは .env、FastAPI Cloud では環境変数に"
            "カンマ区切りの RSS/Atom URL を設定してください。"
        )
    urls = [u.strip() for u in raw.split(",") if u.strip()]
    if not urls:
        raise ValueError(
            "RSS_FEED_URLS に有効な URL がありません。"
            "カンマ区切りで1件以上指定してください。"
        )
    return urls


def get_rss_max_per_feed() -> int:
    """各 RSS/Atom フィードから取得する最大件数。"""
    return _env_positive_int("RSS_MAX_PER_FEED", DEFAULT_RSS_MAX_PER_FEED)


def get_news_candidate_max() -> int:
    """OpenAI に渡す候補記事の最大件数。"""
    return _env_positive_int("NEWS_CANDIDATE_MAX", DEFAULT_NEWS_CANDIDATE_MAX)


def get_api_key() -> str:
    raw = os.getenv("OPENAI_API_KEY", "").strip()
    if not raw:
        raise ValueError("API_KEY is not configured")
    return raw
