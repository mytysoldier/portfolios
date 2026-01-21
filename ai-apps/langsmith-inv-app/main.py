import os
from dotenv import load_dotenv
from langsmith import Client
import google.generativeai as genai


def setup():
    """環境変数読み込み & LangSmith/Gemini 初期化"""
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

    # --- Gemini ---
    gemini_key = os.getenv("GEMINI_API_KEY")
    if not gemini_key:
        raise ValueError("GEMINI_API_KEY が .env に設定されていません。")

    genai.configure(api_key=gemini_key)
    model = genai.GenerativeModel("gemini-1.5-flash")

    return client, model


def extract_gemini_text(response):
    """
    Gemini v1.5 / v2.5 / flash / pro すべてに対応したテキスト抽出。
    """
    # 互換API: response.text があれば最優先
    if hasattr(response, "text") and response.text:
        return response.text

    # 新API: candidates > content > parts 構造
    try:
        parts = response.candidates[0].content.parts
        texts = [p.text for p in parts if hasattr(p, "text")]
        if texts:
            return "".join(texts)
    except Exception:
        pass

    # fallback
    return str(response)


def simple_run(client: Client, model):
    prompt = "日本で一番高い山は？"

    run = client.create_run(
        name="Simple Gemini Run",
        inputs={"prompt": prompt},
        project_name=os.getenv("LANGSMITH_PROJECT_NAME"),
        run_type="llm",
    )

    if run is None:
        print("❌ Run が None。LangSmith に Run を作れませんでした。")
        return

    try:
        # --- Gemini 呼び出し ---
        response = model.generate_content(prompt)

        # --- 全バージョンに対応して抽出 ---
        answer = extract_gemini_text(response)

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
    client, model = setup()
    simple_run(client, model)
