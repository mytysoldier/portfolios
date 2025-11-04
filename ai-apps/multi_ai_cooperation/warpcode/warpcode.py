import subprocess
import textwrap
from typing import Optional

class WarpAgent:
    """
    Warp Code CLI を使ったAIエージェント
    """
    
    def __init__(self, timeout: int = 90):
        self.timeout = timeout
    
    def run_prompt(self, prompt: str) -> Optional[str]:
        """
        Warp Code CLI にプロンプトを渡して結果を取得する
        
        Args:
            prompt (str): Warp に渡すテキストプロンプト
        Returns:
            str | None: Warpの返答テキスト
        """
        try:
            result = subprocess.run(
                ["warp", "agent", "run", "--prompt", prompt],
                capture_output=True,
                text=True,
                timeout=self.timeout
            )

            if result.returncode != 0:
                error_msg = textwrap.dedent(f"""
                ❌ WarpCode Error:
                {result.stderr.strip()}
                """)
                print(error_msg)
                return None

            return result.stdout.strip() or "⚠️ WarpCode returned no output."

        except FileNotFoundError:
            print("❌ Warp CLI not found. Make sure Warp is installed and `warp` is in your PATH.")
            return None
        except subprocess.TimeoutExpired:
            print(f"⚠️ Warp agent timed out (took longer than {self.timeout}s).")
            return None
        except Exception as e:
            print(f"❌ Unexpected error: {e}")
            return None

if __name__ == "__main__":
    agent = WarpAgent()
    
    print("🤖 WarpCode AIエージェントを開始します！")
    print("   'quit'または'exit'で終了します\n")
    
    while True:
        try:
            # ユーザー入力を受け付け
            user_input = input("💭 WarpCodeに送信するプロンプトを入力してください: ").strip()
            
            # 終了条件チェック
            if user_input.lower() in ['quit', 'exit', 'q', '終了']:
                print("👋 WarpCodeエージェントを終了します。")
                break
            
            # 空入力のチェック
            if not user_input:
                print("⚠️  プロンプトを入力してください。")
                continue
            
            # WarpCodeを実行
            print(f"\n🧠 WarpCode実行中: {user_input}")
            print("-" * 60)
            result = agent.run_prompt(user_input)
            
            if result:
                print(result)
            else:
                print("❌ WarpCodeの実行に失敗しました。")
            
            print("-" * 60)
            print("✅ 完了！\n")
            
        except KeyboardInterrupt:
            print("\n\n👋 WarpCodeエージェントを終了します。")
            break
        except Exception as e:
            print(f"❌ エラーが発生しました: {e}")
            print("続けますか？ (Enter で続行)\n")
