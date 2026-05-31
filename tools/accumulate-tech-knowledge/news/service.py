import os

from news.models import NewsPickResult
from news.rss import fetch_articles
from news.config import get_news_candidate_max
from news.selector import select_with_openai


def pick_top_articles() -> NewsPickResult:
    fetched = fetch_articles()
    fetched_count = len(fetched)
    api_key = os.getenv("OPENAI_API_KEY", "").strip()

    if not api_key:
        return NewsPickResult(
            articles=fetched,
            selection_method="fallback",
            fetched_count=fetched_count,
            candidate_count=fetched_count,
        )

    candidate_count = min(fetched_count, get_news_candidate_max())
    try:
        selected = select_with_openai(fetched, api_key)
        return NewsPickResult(
            articles=selected,
            selection_method="openai",
            fetched_count=fetched_count,
            candidate_count=candidate_count,
        )
    except Exception:
        return NewsPickResult(
            articles=fetched,
            selection_method="fallback",
            fetched_count=fetched_count,
            candidate_count=fetched_count,
        )
