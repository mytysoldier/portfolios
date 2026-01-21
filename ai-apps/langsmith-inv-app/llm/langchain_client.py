import os
from typing import Any

from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain_google_genai import ChatGoogleGenerativeAI


def _extract_message_text(message: Any) -> str:
    content = getattr(message, "content", message)
    if isinstance(content, list):
        texts: list[str] = []
        for part in content:
            if isinstance(part, str):
                texts.append(part)
            elif isinstance(part, dict) and "text" in part:
                texts.append(str(part["text"]))
            elif hasattr(part, "text"):
                texts.append(str(part.text))
        return "".join(texts) if texts else str(content)
    return str(content)


def _get_llm(llm_api: str, model_name: str):
    if llm_api == "OpenAI":
        return ChatOpenAI(model=model_name)
    if llm_api == "Anthropic":
        return ChatAnthropic(model=model_name)
    if llm_api == "Google Gemini":
        api_key = os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
        if not api_key:
            raise ValueError("GEMINI_API_KEY もしくは GOOGLE_API_KEY が .env に設定されていません。")
        return ChatGoogleGenerativeAI(model=model_name, google_api_key=api_key)
    raise ValueError(f"未対応の LLM API: {llm_api}")


def call_llm(prompt: str, llm_api: str, model_name: str) -> str:
    llm = _get_llm(llm_api, model_name)
    response = llm.invoke(prompt)
    return _extract_message_text(response)
