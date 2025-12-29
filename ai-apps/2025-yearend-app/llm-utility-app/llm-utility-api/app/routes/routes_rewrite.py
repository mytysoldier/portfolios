from fastapi import APIRouter

from app.schemas import RewriteRequest, RewriteResponse, ErrorResponse
from app.llm_client import rewrite as llm_rewrite, LLMError, ProviderNotConfiguredError
from app.api_errors import error_response


router = APIRouter()


@router.post(
    "/rewrite",
    response_model=RewriteResponse,
    responses={400: {"model": ErrorResponse}, 503: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
async def rewrite(payload: RewriteRequest):
    """
    tone に応じて text を日本語で書き換えます。
    tone: polite/casual/business/friendly
    """
    try:
        rewritten = llm_rewrite(
            text=payload.text,
            tone=payload.tone.value,
            max_chars=payload.max_chars,
            keep_meaning=payload.keep_meaning,
        )
        return RewriteResponse(rewritten_text=rewritten)
    except ProviderNotConfiguredError as e:
        return error_response(
            status_code=503,
            code="provider_not_configured",
            message="LLM プロバイダが正しく設定されていません。",
            details={"reason": str(e)},
        )
    except LLMError as e:
        return error_response(
            status_code=500,
            code="llm_error",
            message="LLM 呼び出し中にエラーが発生しました。",
            details={"reason": str(e)},
        )
    except Exception as e:
        return error_response(
            status_code=500,
            code="llm_error",
            message="予期しないエラーが発生しました。",
            details={"reason": str(e)},
        )


