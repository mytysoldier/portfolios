from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from starlette.middleware.base import BaseHTTPMiddleware

from .api_errors import error_response
from .rate_limit import check_rate_limit, get_client_ip, get_rate_limit_info
from .routes.routes_summarize import router as summarize_router
from .routes.routes_rewrite import router as rewrite_router
from .routes.routes_extract import router as extract_router


app = FastAPI(
    title="LLM Utility API",
    version="0.2.0",
    description="シンプルな LLM Utility API。要約・書き換え・要点抽出を LLM で実行します。",
)


class RateLimitMiddleware(BaseHTTPMiddleware):
    """
    IP/秒レート制限ミドルウェア。
    """

    async def dispatch(self, request: Request, call_next):
        # /health はレート制限の対象外
        if request.url.path == "/health":
            return await call_next(request)

        ip = get_client_ip(request)
        if not check_rate_limit(ip):
            limit = get_rate_limit_info()
            return error_response(
                status_code=429,
                code="rate_limited",
                message="レート制限を超過しました。",
                details={"limit_per_second": limit},
            )

        return await call_next(request)


app.add_middleware(RateLimitMiddleware)


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(
    request: Request, exc: RequestValidationError
) -> JSONResponse:
    """
    Pydantic バリデーションエラーを 400 invalid_request に正規化。
    """
    return error_response(
        status_code=400,
        code="invalid_request",
        message="入力値が不正です。",
        details={"errors": exc.errors()},
    )


@app.get("/health")
async def health() -> dict:
    """
    死活監視用エンドポイント。
    """
    return {"status": "ok"}


# ルーター登録
app.include_router(summarize_router)
app.include_router(rewrite_router)
app.include_router(extract_router)

