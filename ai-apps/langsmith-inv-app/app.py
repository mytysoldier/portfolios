import os
import streamlit as st
from dotenv import load_dotenv
from llm import call_llm


def setup_langsmith_tracing() -> None:
    load_dotenv()

    api_key = os.getenv("LANGSMITH_API_KEY") or os.getenv("LANGCHAIN_API_KEY")
    project = os.getenv("LANGSMITH_PROJECT_NAME") or os.getenv("LANGCHAIN_PROJECT")
    endpoint = os.getenv("LANGSMITH_ENDPOINT") or os.getenv("LANGCHAIN_ENDPOINT")
    tracing_flag = os.getenv("LANGSMITH_TRACING") or os.getenv("LANGCHAIN_TRACING_V2")

    def _parse_bool(value: str | None) -> bool | None:
        if value is None:
            return None
        normalized = value.strip().lower()
        if normalized in {"1", "true", "yes", "on"}:
            return True
        if normalized in {"0", "false", "no", "off"}:
            return False
        return None

    tracing_enabled = _parse_bool(tracing_flag)

    if api_key:
        os.environ.setdefault("LANGCHAIN_API_KEY", api_key)

    if tracing_enabled is True or (tracing_enabled is None and api_key):
        os.environ["LANGCHAIN_TRACING_V2"] = "true"
    elif tracing_enabled is False:
        os.environ["LANGCHAIN_TRACING_V2"] = "false"

    if project:
        os.environ.setdefault("LANGCHAIN_PROJECT", project)

    if endpoint:
        os.environ.setdefault("LANGCHAIN_ENDPOINT", endpoint)


def main() -> None:
    setup_langsmith_tracing()
    st.set_page_config(page_title="LangSmith + LLM App", page_icon="🧪")
    st.title("LangSmith + LLM App")
    st.caption("プロンプトとモデルを選択して実行します。")

    if "output" not in st.session_state:
        st.session_state.output = ""

    prompt = st.text_area(
        "プロンプト",
        placeholder="例: 日本で一番高い山は？",
        height=160,
    )

    llm_api = st.selectbox(
        "LLM API",
        [
            "OpenAI",
            "Anthropic",
            "Google Gemini",
        ],
    )

    model_options = {
        "OpenAI": [
            "gpt-5.2",
            "gpt-5.2-pro",
            "gpt-5.2-codex",
            "gpt-5",
            "gpt-5-mini",
            "gpt-5-nano",
            "gpt-5.1",
        ],
        "Anthropic": [
            "claude-sonnet-4-5",
            "claude-opus-4-5-20251101",
        ],
        "Google Gemini": [
            "gemini-3-pro-preview",
            "gemini-3-flash-preview",
            "gemini-2.5-flash",
            "gemini-2.5-flash-lite",
        ],
    }

    model = st.selectbox("モデル", model_options[llm_api])

    run_clicked = st.button("実行", type="primary")

    if run_clicked:
        if not prompt.strip():
            st.warning("プロンプトを入力してください。")
        else:
            try:
                st.session_state.output = call_llm(
                    prompt=prompt,
                    llm_api=llm_api,
                    model_name=model,
                    metadata={"ui": "streamlit", "llm_api": llm_api, "model": model},
                    tags=["streamlit"],
                )
            except Exception as e:
                st.error(str(e))

    st.subheader("出力")
    st.text_area("結果", value=st.session_state.output, height=220)
    st.caption(f"選択モデル: {model}")


if __name__ == "__main__":
    main()
