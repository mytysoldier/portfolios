from datetime import datetime, timezone
from email.utils import parsedate_to_datetime

import feedparser

from news.config import get_feed_urls, get_rss_max_per_feed
from news.models import Article


def _parse_published(entry: feedparser.FeedParserDict) -> str | None:
    if entry.get("published"):
        return str(entry["published"])
    parsed = entry.get("published_parsed")
    if parsed:
        dt = datetime(*parsed[:6], tzinfo=timezone.utc)
        return dt.isoformat()
    updated = entry.get("updated_parsed")
    if updated:
        dt = datetime(*updated[:6], tzinfo=timezone.utc)
        return dt.isoformat()
    return None


def _entry_sort_key(entry: feedparser.FeedParserDict) -> datetime:
    for field in ("published_parsed", "updated_parsed"):
        parsed = entry.get(field)
        if parsed:
            return datetime(*parsed[:6], tzinfo=timezone.utc)
    published = entry.get("published")
    if published:
        try:
            return parsedate_to_datetime(published)
        except (TypeError, ValueError, OverflowError):
            pass
    return datetime.min.replace(tzinfo=timezone.utc)


def fetch_articles(max_per_feed: int | None = None) -> list[Article]:
    limit = max_per_feed if max_per_feed is not None else get_rss_max_per_feed()
    articles: list[Article] = []
    for feed_url in get_feed_urls():
        parsed = feedparser.parse(feed_url)
        source = (
            parsed.feed.get("title")
            or parsed.feed.get("link")
            or feed_url
        )
        entries = sorted(parsed.entries, key=_entry_sort_key, reverse=True)
        for entry in entries[:limit]:
            title = entry.get("title")
            url = entry.get("link")
            if not title or not url:
                continue
            articles.append(
                Article(
                    title=str(title).strip(),
                    url=str(url).strip(),
                    published=_parse_published(entry),
                    source=str(source).strip(),
                )
            )
    articles.sort(key=lambda a: a.published or "", reverse=True)
    return articles
