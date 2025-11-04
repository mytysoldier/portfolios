import subprocess
import textwrap

def run_warp_agent(prompt: str) -> str:
    """
    Warp Code (warp agent run --prompt ...) を非対話的に呼び出す。
    例: run_warp_agent("kotlinについて教えて")
    """
    try:
        result = subprocess.run(
            ["warp", "agent", "run", "--prompt", prompt],
            capture_output=True,
            text=True,
            timeout=90
        )

        if result.returncode != 0:
            return textwrap.dedent(f"""
            ❌ WarpCode Error:
            {result.stderr.strip()}
            """)

        return result.stdout.strip() or "⚠️ WarpCode returned no output."

    except FileNotFoundError:
        return "❌ Warp CLI not found. Make sure Warp is installed and `warp` is in your PATH."
    except subprocess.TimeoutExpired:
        return "⚠️ Warp agent timed out (took longer than 90s)."
    except Exception as e:
        return f"❌ Unexpected error: {e}"


if __name__ == "__main__":
    prompt = "kotlinについて教えて"
    print("🧠 Prompt:", prompt)
    print("🚀 WarpCode Output:\n")
    print(run_warp_agent(prompt))
