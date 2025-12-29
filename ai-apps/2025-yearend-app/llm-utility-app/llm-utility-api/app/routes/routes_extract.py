from fastapi import APIRouter

from app.schemas import ExtractRequest, ExtractResponse, ErrorResponse
from app.llm_client import extract as llm_extract, LLMError, ProviderNotConfiguredError
from app.api_errors import error_response


router = APIRouter()


@router.post(
    "/extract",
    response_model=ExtractResponse,
    responses={400: {"model": ErrorResponse}, 503: {"model": ErrorResponse}, 500: {"model": ErrorResponse}},
)
async def extract(payload: ExtractRequest):
    """
    テキストから要点を最大 max_items 個まで抽出し、
    [{text, confidence}] のリストとして返します。
    """
    try:
        items = llm_extract(
            text=payload.text,
            max_items=payload.max_items,
        )
        return ExtractResponse(items=items)  # type: ignore[arg-type]
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


