import streamlit as st
from llm import call_llm


def main() -> None:
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
                )
            except Exception as e:
                st.error(str(e))

    st.subheader("出力")
    st.text_area("結果", value=st.session_state.output, height=220)
    st.caption(f"選択モデル: {model}")


if __name__ == "__main__":
    main()
