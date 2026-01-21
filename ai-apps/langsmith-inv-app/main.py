import os
from dotenv import load_dotenv
from langsmith import Client
from llm import call_llm


def setup_langsmith() -> tuple[Client, str | None]:
    """環境変数読み込み & LangSmith 初期化"""
    load_dotenv()

    # --- LangSmith ---
    ls_api_key = os.getenv("LANGSMITH_API_KEY")
    ls_project = os.getenv("LANGSMITH_PROJECT_NAME")

    if not ls_api_key:
        raise ValueError("LANGSMITH_API_KEY が .env に設定されていません。")

    if not ls_project:
        print("[WARN] LANGSMITH_PROJECT_NAME が設定されていません。")
        print("       create_run で project_name=None となります。")

    client = Client(
        api_key=ls_api_key,
        api_url=os.getenv("LANGSMITH_ENDPOINT", "https://api.smith.langchain.com")
    )

    return client, ls_project


def simple_run(client: Client, project_name: str | None):
    prompt = "日本で一番高い山は？"

    run = client.create_run(
        name="Simple Gemini Run",
        inputs={"prompt": prompt},
        project_name=project_name,
        run_type="llm",
    )

    if run is None:
        print("❌ Run が None。LangSmith に Run を作れませんでした。")
        return

    try:
        # --- Gemini 呼び出し ---
        answer = call_llm(
            prompt=prompt,
            llm_api="Google Gemini",
            model_name="gemini-2.5-flash",
        )

        # --- LangSmith に出力を送る ---
        client.update_run(
            run_id=run.id,
            outputs={"answer": answer}
        )

        print("Geminiの回答:", answer)

    except Exception as e:
        print("❌ Error:", e)
        client.update_run(run.id, error=str(e))

    finally:
        # --- 最後に必ず終了させる ---
        client.end_run(run.id)

if __name__ == "__main__":
    client, project_name = setup_langsmith()
    simple_run(client, project_name)
