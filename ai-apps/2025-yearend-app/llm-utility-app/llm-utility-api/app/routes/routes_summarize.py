from fastapi import APIRouter

from app.schemas import SummarizeRequest, SummarizeResponse, ErrorResponse
from app.llm_client import summarize as llm_summarize, LLMError, ProviderNotConfiguredError
from app.api_errors import error_response


router = APIRouter()


@router.post(
    "/summarize",
    response_model=SummarizeResponse,
    responses={400: {"model": ErrorResponse}, 503: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
async def summarize(payload: SummarizeRequest):
    """
    LLM を用いて、text を max_chars 文字以内の日本語要約として返します。
    """
    try:
        summary = llm_summarize(
            text=payload.text,
            max_chars=payload.max_chars,
            style=payload.style,
        )
        return SummarizeResponse(summary=summary)
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
    except Exception as e:  # フォールバック
        return error_response(
            status_code=500,
            code="llm_error",
            message="予期しないエラーが発生しました。",
            details={"reason": str(e)},
        )


