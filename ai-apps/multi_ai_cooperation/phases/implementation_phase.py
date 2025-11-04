"""
実装フェーズ - Copilotが主担当
"""
from typing import Dict, Any
from pathlib import Path
from .base_phase import SyncPhase
from .context import ProjectContext
from copilot.copilot import CopilotAgent
import re
from datetime import datetime


class ImplementationPhase(SyncPhase):
    """
    フェーズ③ 実装
    主担当: Copilot, 補助: Claude
    """
    
    def __init__(self, output_dir: str = "generated_projects"):
        super().__init__("implementation")
        self.copilot = CopilotAgent()
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
    
    def execute_sync(self, context: ProjectContext) -> Dict[str, Any]:
        """実装を実行"""
        
        self._log(context, "実装フェーズ開始...")
        
        # 前フェーズの結果を取得
        design_result = context.get_phase_result("design")
        if not design_result or not design_result.get("design_completed"):
            self._error(context, "設計仕様が見つかりません")
            return {"implementation_completed": False, "error": "設計未完了"}
        
        try:
            # プロジェクトフォルダ作成
            project_path = self._create_project_folder(context.user_request)
            context.project_path = project_path
            
            self._log(context, f"プロジェクトフォルダ作成: {project_path}")
            
            # Copilotに実装を依頼
            implementation_result = self._execute_copilot_implementation(
                design_result["technical_specification"],
                project_path
            )
            
            # 作成されたファイルを記録
            created_files = list(project_path.glob("*"))
            for file_path in created_files:
                if file_path.is_file():
                    context.add_created_file(file_path)
            
            result = {
                "project_path": str(project_path),
                "copilot_response": implementation_result,
                "created_files": [str(f) for f in created_files],
                "implementation_completed": True
            }
            
            # 結果を保存
            self.save_result(context, result)
            
            return result
            
        except Exception as e:
            self._error(context, f"実装フェーズ失敗: {str(e)}")
            return {
                "project_path": "",
                "copilot_response": "",
                "created_files": [],
                "implementation_completed": False,
                "error": str(e)
            }
    
    def _create_project_folder(self, task_description: str) -> Path:
        """プロジェクトフォルダを作成"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        safe_name = re.sub(r'[^\w\s-]', '', task_description[:30]).strip()
        safe_name = re.sub(r'[-\s]+', '_', safe_name)
        
        project_name = f"{timestamp}_{safe_name}"
        project_path = self.output_dir / project_name
        project_path.mkdir(exist_ok=True)
        
        return project_path
    
    def _execute_copilot_implementation(self, technical_spec: str, project_path: Path) -> str:
        """Copilotに実装を実行させる"""
        
        prompt = f"""
以下の技術設計仕様書に基づいて、プログラムを実装してください：

{technical_spec}

【実装時の重要な注意点】
- 実際に動作するコードを書いてください
- 必要なファイルをすべて作成してください
- 適切なファイル名とディレクトリ構造を使用してください
- コメントと説明を充実させてください
- エラーハンドリングを含めてください
- 実行方法をREADMEまたはコメントで説明してください
- 外部依存関係がある場合は requirements.txt や package.json なども作成してください

仕様書の内容を十分に理解して、完全に動作するプログラムを実装してください。
"""
        
        # プロジェクトフォルダで実行
        return self.copilot.run_prompt(
            prompt, 
            allow_all_tools=True,
            working_dir=str(project_path)
        )


if __name__ == "__main__":
    """
    ImplementationPhase 単体実行テスト
    """
    print("🔬 ImplementationPhase 単体実行テスト")
    print("=" * 50)
    
    # テスト用リクエスト
    test_request = input("💭 テスト用リクエストを入力してください (Enterでデフォルト): ").strip()
    if not test_request:
        test_request = "簡単なウェブアプリケーションを作成してください"
    
    # コンテキスト作成
    from .context import ProjectContext
    context = ProjectContext(user_request=test_request)
    
    # 模擬設計結果を設定（言語非依存）
    mock_design = {
        "technical_specification": f"""
# 技術設計仕様書

## 1. プロジェクト概要
**ユーザーリクエスト**: {test_request}

## 2. 技術スタック決定
- **推奨言語**: 要件に最適な言語を自動選択
- **フレームワーク**: 必要に応じて適切なフレームワーク選択
- **データベース**: 要件に応じてSQLite/JSON/メモリ等
- **実行環境**: クロスプラットフォーム対応

## 3. システム構成
- **エントリーポイント**: メイン実行ファイル
- **コアモジュール**: 主要機能を担当
- **設定・データ**: 設定ファイル、データファイル
- **ドキュメント**: README、使用方法

## 4. 実装指針
- 実際に動作するコードの実装
- 適切なエラーハンドリング
- ユーザビリティを考慮した設計
- 拡張性のある実装

## 5. 実装フェーズへの引き継ぎ
- Copilotに具体的な実装を依頼
- 最適な言語・フレームワークの選択
- 必要なファイル構成の決定
- 実行・テスト方法の明確化
""",
        "design_completed": True
    }
    
    context.add_phase_result("design", mock_design)
    
    # フェーズ実行
    phase = ImplementationPhase("test_generated_projects")
    
    print(f"\n🚀 実行開始: {test_request}")
    print("📐 模擬設計結果を使用（言語非依存）")
    print("📁 テスト用出力ディレクトリ: test_generated_projects")
    print("-" * 50)
    
    result = phase.execute_sync(context)
    
    print("-" * 50)
    print("✅ 実行完了!")
    print(f"🎯 実装成功: {result.get('implementation_completed', False)}")
    
    if result.get('project_path'):
        print(f"📁 プロジェクト保存先: {result['project_path']}")
    
    if result.get('created_files'):
        print(f"📄 作成ファイル数: {len(result['created_files'])}")
        for file in result.get('created_files', []):
            print(f"   - {Path(file).name}")
    
    if result.get('copilot_response'):
        print(f"\n🤖 Copilot応答:")
        response = result['copilot_response']
        print(response[:500] + "..." if len(response) > 500 else response)
    
    if result.get('error'):
        print(f"\n❌ エラー: {result['error']}")