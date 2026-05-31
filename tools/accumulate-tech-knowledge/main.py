from pathlib import Path

from dotenv import load_dotenv
from fastapi import Depends, FastAPI

load_dotenv(Path(__file__).resolve().parent / ".env")

from news import pick_top_articles
from news.auth import require_api_key

app = FastAPI(
    title="AI News API",
    description="RSSから技術記事を取得し、OpenAIで重要記事を選別するMVP",
    version="0.1.0",
)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/news", dependencies=[Depends(require_api_key)])
def news() -> dict:
    result = pick_top_articles()
    return {
        "selection_method": result.selection_method,
        "fetched_count": result.fetched_count,
        "candidate_count": result.candidate_count,
        "count": result.selected_count,
        "articles": [a.to_dict() for a in result.articles],
    }
