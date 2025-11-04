import os
from dotenv import load_dotenv
import google.generativeai as genai
from typing import Optional

class GeminiAgent:
    """
    Google Gemini API を使ったAIエージェント
    """
    
    def __init__(self, model_name: str = "gemini-2.0-flash-exp"):
        load_dotenv()
        api_key = os.getenv("GOOGLE_API_KEY")
        if not api_key:
            raise ValueError("❌ GOOGLE_API_KEY が見つかりません。.env を確認してください。")
        
        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel(model_name)
    
    def run_prompt(self, prompt: str) -> Optional[str]:
        """
        Gemini API にプロンプトを渡して結果を取得する
        
        Args:
            prompt (str): Gemini に渡すテキストプロンプト
        Returns:
            str | None: Geminiの返答テキスト
        """
        try:
            response = self.model.generate_content(prompt)
            return response.text.strip()
        except Exception as e:
            print(f"❌ Gemini 実行エラー: {e}")
            return None

if __name__ == "__main__":
    agent = GeminiAgent()
    
    print("🤖 Gemini AIエージェントを開始します！")
    print("   'quit'または'exit'で終了します\n")
    
    while True:
        try:
            # ユーザー入力を受け付け
            user_input = input("💭 Geminiに送信するプロンプトを入力してください: ").strip()
            
            # 終了条件チェック
            if user_input.lower() in ['quit', 'exit', 'q', '終了']:
                print("👋 Geminiエージェントを終了します。")
                break
            
            # 空入力のチェック
            if not user_input:
                print("⚠️  プロンプトを入力してください。")
                continue
            
            # Geminiを実行
            print(f"\n🧠 Gemini実行中: {user_input}")
            print("-" * 60)
            result = agent.run_prompt(user_input)
            
            if result:
                print(result)
            else:
                print("❌ Geminiの実行に失敗しました。")
            
            print("-" * 60)
            print("✅ 完了！\n")
            
        except KeyboardInterrupt:
            print("\n\n👋 Geminiエージェントを終了します。")
            break
        except Exception as e:
            print(f"❌ エラーが発生しました: {e}")
            print("続けますか？ (Enter で続行)\n")
