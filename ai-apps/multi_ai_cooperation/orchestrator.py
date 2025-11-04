# orchestrator.py
"""
複数のAIエージェント（Copilot, Gemini, OpenAI, WarpCodeなど）を協調的に動かすオーケストレーター。
各エージェントは共通インターフェイス run_prompt(prompt: str) を持つことを前提とする。
"""

from copilot.copilot import CopilotAgent
from gemini.gemini import GeminiAgent
from openai.openai import OpenAIAgent
from warpcode.warpcode import WarpAgent

class Orchestrator:
    def __init__(self):
        self.copilot = CopilotAgent()
        self.gemini = GeminiAgent()
        self.openai = OpenAIAgent()
        self.warp = WarpAgent()

    def run_task(self, task: str):
        """
        1. Copilotに下書きを作らせる
        2. Geminiにレビューさせる
        3. OpenAIに要約させる
        4. WarpCodeにコード補完を依頼する
        """
        print("🧩 Step 1: Copilotに下書きを依頼中...")
        draft = self.copilot.run_prompt(task)
        print("\n=== Copilot Output ===\n", draft)

        # print("\n🧩 Step 2: Geminiにレビュー依頼中...")
        # review = self.gemini.run_prompt(f"以下の内容をレビューしてください:\n{draft}")
        # print("\n=== Gemini Review ===\n", review)

        # print("\n🧩 Step 3: OpenAIに要約依頼中...")
        # summary = self.openai.run_prompt(f"以下を3行で要約:\n{review}")
        # print("\n=== OpenAI Summary ===\n", summary)

        # print("\n🧩 Step 4: WarpCodeに最終コード生成依頼中...")
        # warp_output = self.warp.run_prompt(f"この要約をもとにコードを最適化:\n{summary}")
        # print("\n=== WarpCode Output ===\n", warp_output)

if __name__ == "__main__":
    orchestrator = Orchestrator()
    
    print("🚀 Multi-AI Cooperationシステムを開始します！")
    print("   'quit'または'exit'で終了します\n")
    
    while True:
        try:
            # ユーザー入力を受け付け
            user_input = input("💬 実行したいタスクを入力してください: ").strip()
            
            # 終了条件チェック
            if user_input.lower() in ['quit', 'exit', 'q', '終了']:
                print("👋 システムを終了します。お疲れさまでした！")
                break
            
            # 空入力のチェック
            if not user_input:
                print("⚠️  タスクを入力してください。")
                continue
            
            # タスクを実行
            print(f"\n📋 タスク: {user_input}")
            print("-" * 50)
            orchestrator.run_task(user_input)
            print("-" * 50)
            print("✅ タスク完了！\n")
            
        except KeyboardInterrupt:
            print("\n\n👋 システムを終了します。お疲れさまでした！")
            break
        except Exception as e:
            print(f"❌ エラーが発生しました: {e}")
            print("続けますか？ (Enter で続行)\n")
