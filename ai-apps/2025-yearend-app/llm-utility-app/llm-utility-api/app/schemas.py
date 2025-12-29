from enum import Enum
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field


class Tone(str, Enum):
    POLITE = "polite"
    CASUAL = "casual"
    BUSINESS = "business"
    FRIENDLY = "friendly"


class SummarizeRequest(BaseModel):
    text: str = Field(
        ...,
        min_length=1,
        max_length=20_000,
        description="要約対象のテキスト（1〜20,000文字）",
    )
    max_chars: int = Field(
        200,
        ge=50,
        le=2_000,
        description="要約結果の最大文字数（50〜2,000）",
    )
    style: Optional[str] = Field(
        default=None,
        description="要約スタイル（例: 'simple', 'detailed' など）",
    )


class SummarizeResponse(BaseModel):
    summary: str = Field(..., description="要約結果テキスト")


class RewriteRequest(BaseModel):
    text: str = Field(
        ...,
        min_length=1,
        max_length=20_000,
        description="書き換え対象のテキスト（1〜20,000文字）",
    )
    tone: Tone = Field(
        ...,
        description="書き換えスタイル。polite/casual/business/friendly のいずれか。",
    )
    max_chars: Optional[int] = Field(
        default=None,
        ge=50,
        le=2_000,
        description="書き換え後テキストの最大文字数（50〜2,000）。未指定なら制限なし。",
    )
    keep_meaning: Optional[bool] = Field(
        default=True,
        description="True の場合、元の意味をできるだけ保つように書き換えます。",
    )


class RewriteResponse(BaseModel):
    rewritten_text: str = Field(..., description="書き換え後テキスト")


class ExtractRequest(BaseModel):
    text: str = Field(
        ...,
        min_length=1,
        max_length=20_000,
        description="情報抽出対象のテキスト（1〜20,000文字）",
    )
    max_items: int = Field(
        5,
        ge=1,
        le=20,
        description="抽出する要点の最大件数（1〜20）",
    )


class ExtractItem(BaseModel):
    text: str = Field(..., description="抽出された要点のテキスト")
    confidence: float = Field(
        1.0,
        description="信頼度（現時点では 1.0 固定）",
    )


class ExtractResponse(BaseModel):
    items: List[ExtractItem] = Field(
        ...,
        description="抽出された要点のリスト",
    )


class ErrorDetail(BaseModel):
    code: str = Field(..., description="アプリケーション固有のエラーコード")
    message: str = Field(..., description="人間向けのエラーメッセージ")
    details: Dict[str, Any] = Field(
        default_factory=dict,
        description="追加情報（バリデーションエラーの詳細など）",
    )


class ErrorResponse(BaseModel):
    error: ErrorDetail

