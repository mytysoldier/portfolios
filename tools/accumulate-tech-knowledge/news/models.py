from dataclasses import dataclass
from typing import Literal

SelectionMethod = Literal["openai", "fallback"]


@dataclass(frozen=True)
class NewsPickResult:
    articles: list["Article"]
    selection_method: SelectionMethod
    fetched_count: int
    candidate_count: int

    @property
    def selected_count(self) -> int:
        return len(self.articles)


@dataclass(frozen=True)
class Article:
    title: str
    url: str
    published: str | None
    source: str

    def to_dict(self) -> dict:
        return {
            "title": self.title,
            "url": self.url,
            "published": self.published,
            "source": self.source,
        }
