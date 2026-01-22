import os
from typing import Any

from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough


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


def call_llm(
    prompt: str,
    llm_api: str,
    model_name: str,
    metadata: dict[str, Any] | None = None,
    tags: list[str] | None = None,
) -> str:
    llm = _get_llm(llm_api, model_name)
    draft_prompt = ChatPromptTemplate.from_messages(
        [
            (
                "system",
                "あなたはユーザーの質問に対して、正確で分かりやすい回答を作るアシスタントです。",
            ),
            ("human", "{input}"),
        ]
    )
    refine_prompt = ChatPromptTemplate.from_messages(
        [
            (
                "system",
                "次の回答を整形してください。内容は維持しつつ、"
                "要点と詳細の2セクションに分けて出力してください。",
            ),
            ("human", "質問: {input}\n一次回答: {draft}"),
        ]
    )

    draft_chain = (draft_prompt | llm | StrOutputParser()).with_config(
        run_name="draft_answer"
    )
    refine_chain = (refine_prompt | llm | StrOutputParser()).with_config(
        run_name="final_answer"
    )
    chain = {"input": RunnablePassthrough(), "draft": draft_chain} | refine_chain

    config: dict[str, Any] = {}
    if metadata:
        config["metadata"] = metadata
    if tags:
        config["tags"] = tags

    response = chain.invoke({"input": prompt}, config=config if config else None)
    return _extract_message_text(response)
