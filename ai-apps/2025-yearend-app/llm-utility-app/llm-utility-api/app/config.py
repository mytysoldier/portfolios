import os
from functools import lru_cache
from enum import Enum
from typing import Optional

from dotenv import load_dotenv
from pydantic import BaseModel


# アプリ起動時に .env を読み込む
load_dotenv()


class LLMProvider(str, Enum):
    OPENAI = "openai"
    GEMINI = "gemini"


class Settings(BaseModel):
    """
    環境変数から読み込んだ設定値をまとめるクラス。
    """

    llm_provider: Optional[LLMProvider] = None

    openai_api_key: Optional[str] = None
    openai_model: Optional[str] = None

    gemini_api_key: Optional[str] = None
    gemini_model: Optional[str] = None


@lru_cache
def get_settings() -> Settings:
    """
    環境変数から設定を読み込み、キャッシュします。
    """
    provider_raw = os.getenv("LLM_PROVIDER")
    provider: Optional[LLMProvider]
    if provider_raw in (LLMProvider.OPENAI.value, LLMProvider.GEMINI.value):
        provider = LLMProvider(provider_raw)  # type: ignore[arg-type]
    else:
        provider = None

    return Settings(
        llm_provider=provider,
        openai_api_key=os.getenv("OPENAI_API_KEY"),
        openai_model=os.getenv("OPENAI_MODEL"),
        gemini_api_key=os.getenv("GEMINI_API_KEY"),
        gemini_model=os.getenv("GEMINI_MODEL"),
    )


