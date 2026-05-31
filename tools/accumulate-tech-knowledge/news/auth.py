import secrets

from fastapi import Header, HTTPException

from news.config import get_api_key

_UNAUTHORIZED_DETAIL = "認証に失敗しました。"


async def require_api_key(
    x_api_key: str | None = Header(default=None, alias="X-API-Key", include_in_schema=False),
) -> None:
    try:
        expected = get_api_key()
    except ValueError:
        raise HTTPException(status_code=401, detail=_UNAUTHORIZED_DETAIL)
    if not x_api_key or not secrets.compare_digest(x_api_key, expected):
        raise HTTPException(status_code=401, detail=_UNAUTHORIZED_DETAIL)
