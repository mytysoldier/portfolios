import json
import os

from openai import OpenAI

from news.config import get_news_candidate_max
from news.models import Article


def select_with_openai(articles: list[Article], api_key: str) -> list[Article]:
    candidate_max = get_news_candidate_max()
    candidates = articles[:candidate_max]
    if not candidates:
        return []

    numbered = [
        {
            "index": i,
            "title": a.title,
            "url": a.url,
            "published": a.published,
            "source": a.source,
        }
        for i, a in enumerate(candidates)
    ]

    client = OpenAI(api_key=api_key)
    response = client.chat.completions.create(
        model=os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
        temperature=0.2,
        response_format={"type": "json_object"},
        messages=[
            {
                "role": "system",
                "content": (
                    "あなたはソフトウェアエンジニア向けの技術ニュースキュレーターです。"
                    f"与えられた記事一覧（最大{candidate_max}件）から、実務で読む価値がある記事を"
                    "件数上限なくすべて選んでください。"
                    "該当がなければ空配列を返してください。"
                    "index は候補リストの index フィールドをそのまま使ってください。"
                    'JSONのみ返す: {"indices": [0, 2, 5, 12]}'
                ),
            },
            {
                "role": "user",
                "content": json.dumps(numbered, ensure_ascii=False),
            },
        ],
    )

    content = response.choices[0].message.content or "{}"
    data = json.loads(content)
    indices = data.get("indices", [])
    if not isinstance(indices, list):
        indices = []

    selected: list[Article] = []
    seen: set[int] = set()
    for raw in indices:
        if not isinstance(raw, int) or raw in seen:
            continue
        if 0 <= raw < len(candidates):
            seen.add(raw)
            selected.append(candidates[raw])

    return selected
