import os
import subprocess
from dotenv import load_dotenv
from langsmith import Client

def run_cli(command: list[str]) -> str:
    """
    CLIコマンドを実行し、標準出力を返す
    """
    result = subprocess.run(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    if result.returncode != 0:
        raise RuntimeError(result.stderr)
    
    return result.stdout.strip()

def simple_run_cli(llm_name: str, command: list[str]):
    """
    任意のLLM CLI実行を、LangSmithに記録する
    """
    load_dotenv()

    client = Client(api_key=os.getenv("LANGSMITH_API_KEY"))
    project =  os.getenv("LANGSMITH_PROJECT_NAME")

    # LangSmith Run 作成
    run = client.create_run(
        name="Simple CLI LLM Run",
        inputs={"command": " ".join(command)},
        project_name=project,
        run_type="llm",
    )

    if run is None:
        print("❌ LangSmith に Run を作成できませんでした。")
        print("👉 API Key が Personal Workspace のものか確認してください。")
        print("👉 Project 名が正しいか確認してください。(default)")
        return

    try:
        output = run_cli(command)

        client.update_run(run.id, outputs={"answer": output})

        print(f"{llm_name}の回答：")
        print(output)

    except Exception as e:
        print(f"❌ {llm_name}の実行中にエラーが発生しました: {e}")
        client.update_run(run.id, error=str(e))

    finally:
        client.update_run(run.id, end_time="now")
    

if __name__ == "__main__":
    prompt = "日本で一番高い山は？"

    # Claude CLI の例
    simple_run_cli(
        llm_name="Claude",
        command=["claude", "prompt", prompt]
    )

    # Mistral CLI の例（m-cli）
    # simple_run_cli(
    #     llm_name="Mistral",
    #     command=["m", "chat", prompt]
    # )

    # Copilot CLI の例
    # simple_run_cli(
    #     llm_name="Copilot",
    #     command=["github-copilot-cli", "chat", prompt]
    # )