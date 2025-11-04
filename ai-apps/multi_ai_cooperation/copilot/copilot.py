import subprocess
from typing import Optional

class CopilotAgent:
    """
    Copilot CLI (`copilot -p "..." --allow-all-tools`) を通じて
    プロンプトを実行するAIエージェント
    """

    def __init__(self, base_command: str = "copilot"):
        self.base_command = base_command

    def run_prompt(self, prompt: str, allow_all_tools: bool = True) -> Optional[str]:
        """
        Copilot CLI にプロンプトを渡して結果を取得する

        Args:
            prompt (str): Copilot に渡すテキストプロンプト
            allow_all_tools (bool): --allow-all-tools フラグを付与するかどうか
        Returns:
            str | None: Copilotの返答テキスト
        """
        cmd = [self.base_command, "-p", prompt]
        if allow_all_tools:
            cmd.append("--allow-all-tools")

        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=True
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError as e:
            print("❌ Copilot 実行エラー:")
            print(e.stderr)
            return None

if __name__ == "__main__":
    agent = CopilotAgent()
    
    print("🤖 Copilot AIエージェントを開始します！")
    print("   'quit'または'exit'で終了します\n")
    
    while True:
        try:
            # ユーザー入力を受け付け
            user_input = input("💭 Copilotに送信するプロンプトを入力してください: ").strip()
            
            # 終了条件チェック
            if user_input.lower() in ['quit', 'exit', 'q', '終了']:
                print("👋 Copilotエージェントを終了します。")
                break
            
            # 空入力のチェック
            if not user_input:
                print("⚠️  プロンプトを入力してください。")
                continue
            
            # Copilotを実行
            print(f"\n🧠 Copilot実行中: {user_input}")
            print("-" * 60)
            result = agent.run_prompt(user_input)
            
            if result:
                print(result)
            else:
                print("❌ Copilotの実行に失敗しました。")
            
            print("-" * 60)
            print("✅ 完了！\n")
            
        except KeyboardInterrupt:
            print("\n\n👋 Copilotエージェントを終了します。")
            break
        except Exception as e:
            print(f"❌ エラーが発生しました: {e}")
            print("続けますか？ (Enter で続行)\n")
