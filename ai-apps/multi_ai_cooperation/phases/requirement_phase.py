"""
要件・調査フェーズ - Geminiが主担当
"""
from typing import Dict, Any
from .base_phase import SyncPhase
from .context import ProjectContext
from gemini.gemini import GeminiAgent


class RequirementPhase(SyncPhase):
    """
    フェーズ① 要件・調査
    主担当: Gemini, 補助: Claude
    """
    
    def __init__(self):
        super().__init__("requirement")
        self.gemini = GeminiAgent()
    
    def execute_sync(self, context: ProjectContext) -> Dict[str, Any]:
        """要件分析と情報収集を実行"""
        
        self._log(context, "要件分析開始...")
        
        prompt = f"""
以下のユーザーリクエストを詳細に分析してください：

【ユーザーリクエスト】
{context.user_request}

【分析項目】
1. **機能要件**
   - 必須機能の一覧
   - オプション機能の一覧
   - 制約条件

2. **非機能要件**
   - 性能要件
   - セキュリティ要件
   - 運用要件

3. **技術調査**
   - 推奨技術スタック
   - 利用すべきライブラリ・フレームワーク
   - 開発・実行環境

4. **実装複雑度**
   - 見積もり工数（小/中/大）
   - 技術的な課題点
   - リスク要因

5. **成果物定義**
   - 作成すべきファイル一覧
   - ディレクトリ構造
   - ドキュメント要件

詳細で具体的な分析結果を提供してください。
"""
        
        try:
            result = self.gemini.run_prompt(prompt)
            
            if not result:
                raise Exception("Geminiからの応答が取得できませんでした")
            
            analysis_result = {
                "raw_response": result,
                "user_request": context.user_request,
                "analysis_completed": True
            }
            
            # 結果を保存
            self.save_result(context, analysis_result)
            
            return analysis_result
            
        except Exception as e:
            self._error(context, f"要件分析失敗: {str(e)}")
            return {
                "raw_response": "",
                "user_request": context.user_request,
                "analysis_completed": False,
                "error": str(e)
            }


if __name__ == "__main__":
    """
    RequirementPhase 単体実行テスト
    """
    print("🔬 RequirementPhase 単体実行テスト")
    print("=" * 50)
    
    # テスト用リクエスト
    test_request = input("💭 テスト用リクエストを入力してください (Enterでデフォルト): ").strip()
    if not test_request:
        test_request = "Pythonで簡単なToDoリストアプリを作成してください"
    
    # コンテキスト作成
    from .context import ProjectContext
    context = ProjectContext(user_request=test_request)
    
    # フェーズ実行
    phase = RequirementPhase()
    
    print(f"\n🚀 実行開始: {test_request}")
    print("-" * 50)
    
    result = phase.execute_sync(context)
    
    print("-" * 50)
    print("✅ 実行完了!")
    print(f"🎯 分析成功: {result.get('analysis_completed', False)}")
    
    if result.get('raw_response'):
        print("\n📋 Gemini分析結果:")
        print(result['raw_response'][:500] + "..." if len(result['raw_response']) > 500 else result['raw_response'])
    
    if result.get('error'):
        print(f"\n❌ エラー: {result['error']}")