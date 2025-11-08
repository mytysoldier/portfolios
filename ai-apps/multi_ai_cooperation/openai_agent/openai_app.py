import os
from dotenv import load_dotenv
from openai import OpenAI
from typing import Optional

class OpenAIAgent:
    """
    OpenAI API を使ったAIエージェント
    """
    
    def __init__(self, model_name: str = "gpt-4o-mini"):
        load_dotenv()
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("❌ OPENAI_API_KEY が見つかりません。.env を確認してください。")
        
        self.client = OpenAI(api_key=api_key)
        self.model_name = model_name
    
    def run_prompt(self, prompt: str) -> Optional[str]:
        """
        OpenAI API にプロンプトを渡して結果を取得する
        
        Args:
            prompt (str): OpenAI に渡すテキストプロンプト
        Returns:
            str | None: OpenAIの返答テキスト
        """
        try:
            response = self.client.chat.completions.create(
                model=self.model_name,
                messages=[{"role": "user", "content": prompt}],
                temperature=0.2,
            )
            return response.choices[0].message.content.strip()
        except Exception as e:
            print(f"❌ OpenAI 実行エラー: {e}")
            return None

if __name__ == "__main__":
    agent = OpenAIAgent()
    
    print("🤖 OpenAI AIエージェントを開始します！")
    print("   'quit'または'exit'で終了します\n")
    
    while True:
        try:
            # ユーザー入力を受け付け
            user_input = input("💭 OpenAIに送信するプロンプトを入力してください: ").strip()
            
            # 終了条件チェック
            if user_input.lower() in ['quit', 'exit', 'q', '終了']:
                print("👋 OpenAIエージェントを終了します。")
                break
            
            # 空入力のチェック
            if not user_input:
                print("⚠️  プロンプトを入力してください。")
                continue
            
            # OpenAIを実行
            print(f"\n🧠 OpenAI実行中: {user_input}")
            print("-" * 60)
            result = agent.run_prompt(user_input)
            
            if result:
                print(result)
            else:
                print("❌ OpenAIの実行に失敗しました。")
            
            print("-" * 60)
            print("✅ 完了！\n")
            
        except KeyboardInterrupt:
            print("\n\n👋 OpenAIエージェントを終了します。")
            break
        except Exception as e:
            print(f"❌ エラーが発生しました: {e}")
            print("続けますか？ (Enter で続行)\n")