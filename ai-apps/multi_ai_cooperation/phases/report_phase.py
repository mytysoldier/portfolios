"""
レポート・改善提案フェーズ - Claude Codeが主担当
"""
from typing import Dict, Any
from pathlib import Path
from .base_phase import SyncPhase
from .context import ProjectContext
from gemini.gemini import GeminiAgent
from datetime import datetime


class ReportPhase(SyncPhase):
    """
    フェーズ⑤ レポート・改善提案
    主担当: Claude Code, 補助: Gemini
    """
    
    def __init__(self):
        super().__init__("report")
        self.gemini = GeminiAgent()
    
    def execute_sync(self, context: ProjectContext) -> Dict[str, Any]:
        """レポート・改善提案を実行"""
        
        self._log(context, "レポート生成フェーズ開始...")
        
        try:
            # 全フェーズの結果を収集
            project_summary = self._generate_project_summary(context)
            
            # Claude Code による実行ログ解析
            execution_analysis = self._analyze_execution_logs(context)
            
            # Gemini による外部ベンチマーク比較
            benchmark_analysis = self._get_gemini_benchmark_analysis(
                context.user_request,
                project_summary
            )
            
            # 最終レポートを生成
            final_report = self._generate_final_report(
                context,
                project_summary,
                execution_analysis,
                benchmark_analysis
            )
            
            # プロジェクトフォルダにレポートを保存
            if context.project_path:
                self._save_report_to_project(context, context.project_path, final_report)
            
            result = {
                "project_summary": project_summary,
                "execution_analysis": execution_analysis,
                "benchmark_analysis": benchmark_analysis,
                "final_report": final_report,
                "report_completed": True
            }
            
            # 結果を保存
            self.save_result(context, result)
            
            return result
            
        except Exception as e:
            self._error(context, f"レポート生成フェーズ失敗: {str(e)}")
            return {
                "project_summary": "",
                "execution_analysis": "",
                "benchmark_analysis": "",
                "final_report": "",
                "report_completed": False,
                "error": str(e)
            }
    
    def _generate_project_summary(self, context: ProjectContext) -> str:
        """プロジェクト概要を生成"""
        
        summary_parts = []
        
        # 基本情報
        summary_parts.append(f"## プロジェクト基本情報")
        summary_parts.append(f"- **リクエスト**: {context.user_request}")
        summary_parts.append(f"- **作成日時**: {context.created_at.strftime('%Y-%m-%d %H:%M:%S')}")
        summary_parts.append(f"- **プロジェクトパス**: {context.project_path}")
        summary_parts.append("")
        
        # フェーズ実行結果
        summary_parts.append(f"## フェーズ実行結果")
        for phase_name, result in context.phase_results.items():
            status = "✅ 成功" if result.get(f"{phase_name}_completed", False) else "❌ 失敗"
            summary_parts.append(f"- **{phase_name.title()}**: {status}")
        summary_parts.append("")
        
        # ファイル作成結果
        summary_parts.append(f"## 作成ファイル ({len(context.created_files)}件)")
        for file_path in context.created_files:
            file_size = file_path.stat().st_size if file_path.exists() else 0
            summary_parts.append(f"- `{file_path.name}` ({file_size} bytes)")
        summary_parts.append("")
        
        # エラー・ログ
        if context.errors:
            summary_parts.append(f"## エラー ({len(context.errors)}件)")
            for error in context.errors[-5:]:  # 最新5件のエラー
                summary_parts.append(f"- {error}")
            summary_parts.append("")
        
        return "\n".join(summary_parts)
    
    def _analyze_execution_logs(self, context: ProjectContext) -> str:
        """Claude Code による実行ログ解析"""
        
        analysis_parts = []
        
        # 全体的な成功率
        total_phases = len(context.phase_results)
        successful_phases = 0
        
        for phase_name, result in context.phase_results.items():
            # 各フェーズの完了フラグをチェック
            completion_key = f"{phase_name}_completed"
            if result.get(completion_key, False):
                successful_phases += 1
        
        success_rate = (successful_phases / total_phases * 100) if total_phases > 0 else 0
        
        analysis_parts.append(f"## 実行分析")
        analysis_parts.append(f"- **全体成功率**: {success_rate:.1f}% ({successful_phases}/{total_phases})")
        
        # 検証結果の詳細分析
        verification_result = context.get_phase_result("verification")
        if verification_result:
            overall_success = verification_result.get("overall_success", False)
            verification_results = verification_result.get("verification_results", [])
            
            analysis_parts.append(f"- **検証結果**: {'成功' if overall_success else '要改善'}")
            
            for test in verification_results:
                status = "✅" if test.get("success", False) else "❌"
                analysis_parts.append(f"  - {status} {test.get('test_name', 'Unknown')}: {test.get('message', '')}")
        
        # パフォーマンス分析
        analysis_parts.append(f"- **実行時間**: {(datetime.now() - context.created_at).total_seconds():.1f}秒")
        analysis_parts.append(f"- **ログエントリ数**: {len(context.logs)}")
        
        return "\n".join(analysis_parts)
    
    def _get_gemini_benchmark_analysis(self, user_request: str, project_summary: str) -> str:
        """Gemini による外部ベンチマーク比較"""
        
        try:
            prompt = f"""
以下のプロジェクトについて、外部ベンチマークとの比較分析を行ってください：

【ユーザーリクエスト】
{user_request}

【プロジェクト概要】
{project_summary}

【分析してほしい項目】
1. **類似プロジェクトとの比較**
   - 同種のプロジェクトの一般的な実装方法
   - 業界標準やベストプラクティスとの比較
   - 他の実装アプローチとの違い

2. **技術的品質評価**
   - 選択された技術スタックの適切性
   - アーキテクチャの妥当性
   - 拡張性・保守性の観点

3. **改善提案**
   - 機能面での改善案
   - 性能向上のための提案
   - セキュリティ・品質面での改善点

4. **学習・参考資料**
   - 関連する技術ドキュメント
   - 参考になるオープンソースプロジェクト
   - 学習リソースの紹介

具体的で実践的な分析結果を提供してください。
"""
            
            result = self.gemini.run_prompt(prompt)
            return result if result else "Geminiベンチマーク分析を取得できませんでした。"
            
        except Exception as e:
            return f"Geminiベンチマーク分析エラー: {str(e)}"
    
    def _generate_final_report(self, context: ProjectContext, 
                             project_summary: str, 
                             execution_analysis: str, 
                             benchmark_analysis: str) -> str:
        """最終レポートを生成"""
        
        report_parts = []
        
        # ヘッダー
        report_parts.append("# 🤖 Multi-AI Cooperation プロジェクトレポート")
        report_parts.append(f"*生成日時: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}*")
        report_parts.append("")
        
        # プロジェクト概要
        report_parts.append(project_summary)
        
        # 実行分析
        report_parts.append(execution_analysis)
        
        # ベンチマーク分析
        report_parts.append("## 外部ベンチマーク分析")
        report_parts.append(benchmark_analysis)
        report_parts.append("")
        
        # 協調AI実行ログ
        report_parts.append("## 🧠 AI協調実行ログ")
        report_parts.append("各AIエージェントの協調実行プロセス:")
        
        for phase_name, result in context.phase_results.items():
            emoji = "✅" if any(result.get(f"{key}_completed", False) for key in result.keys() if "_completed" in key) else "❌"
            report_parts.append(f"- {emoji} **{phase_name.upper()}フェーズ**")
        
        report_parts.append("")
        
        # フッター
        report_parts.append("---")
        report_parts.append("*このレポートは Gemini → Claude Code → Copilot → WarpCode の協調実行により生成されました。*")
        
        return "\n".join(report_parts)
    
    def _save_report_to_project(self, context: ProjectContext, project_path: Path, report: str):
        """プロジェクトフォルダにレポートを保存"""
        
        try:
            report_file = project_path / "PROJECT_REPORT.md"
            report_file.write_text(report, encoding='utf-8')
            self._log(context, f"プロジェクトレポート保存: {report_file}")
        except Exception as e:
            self._error(context, f"レポート保存失敗: {str(e)}")


if __name__ == "__main__":
    """
    ReportPhase 単体実行テスト
    """
    print("🔬 ReportPhase 単体実行テスト")
    print("=" * 50)
    
    from pathlib import Path
    import tempfile
    
    # テスト用リクエスト
    test_request = input("💭 テスト用リクエストを入力してください (Enterでデフォルト): ").strip()
    if not test_request:
        test_request = "汎用プロジェクトのレポート生成テスト"
    
    # コンテキスト作成
    from .context import ProjectContext
    context = ProjectContext(user_request=test_request)
    
    # 模擬前フェーズ結果を設定
    with tempfile.TemporaryDirectory(prefix="test_report_") as temp_dir:
        test_project_path = Path(temp_dir)
        context.project_path = test_project_path
        
        # 言語非依存のテスト用ファイル作成
        (test_project_path / "main.js").write_text("""
// JavaScript example
console.log('Hello, World!');
""", encoding='utf-8')
        
        (test_project_path / "app.py").write_text("""
# Python example
print('Hello, World!')
""", encoding='utf-8')
        
        (test_project_path / "index.html").write_text("""
<!DOCTYPE html>
<html>
<head><title>Test</title></head>
<body><h1>Hello, World!</h1></body>
</html>
""", encoding='utf-8')
        
        (test_project_path / "README.md").write_text("""
# Multi-Language Test Project

This is a test project supporting multiple languages.

## Files
- main.js: JavaScript implementation
- app.py: Python implementation  
- index.html: Web interface
""", encoding='utf-8')
        
        # ファイルをコンテキストに追加
        for file_path in test_project_path.glob("*"):
            context.add_created_file(file_path)
        
        # 模擬フェーズ結果を設定
        context.add_phase_result("requirement", {
            "analysis_completed": True,
            "raw_response": "汎用プロジェクトの要件分析完了。複数言語対応。"
        })
        
        context.add_phase_result("design", {
            "design_completed": True,
            "technical_specification": "言語非依存の技術設計完了。クロスプラットフォーム対応。"
        })
        
        context.add_phase_result("implementation", {
            "implementation_completed": True,
            "project_path": str(test_project_path),
            "created_files": [str(f) for f in context.created_files]
        })
        
        context.add_phase_result("verification", {
            "verification_completed": True,
            "overall_success": True,
            "verification_results": [
                {"test_name": "Project Structure Check", "success": True, "message": "構造確認OK"},
                {"test_name": "Multi-Language Test", "success": True, "message": "多言語対応OK"},
                {"test_name": "Basic File Tests", "success": True, "message": "ファイル基本テストOK"}
            ]
        })
        
        # 汎用的なログとエラーの追加
        context.add_log("要件分析フェーズ完了")
        context.add_log("設計フェーズ完了")
        context.add_log("実装フェーズ完了")
        context.add_log("検証フェーズ完了")
        
        # フェーズ実行
        phase = ReportPhase()
        
        print(f"\n🚀 実行開始: {test_request}")
        print("📊 模擬多言語フェーズ結果を使用")
        print(f"📁 テスト用プロジェクト: {test_project_path}")
        print("🌐 対応言語: JavaScript, Python, HTML")
        print("-" * 50)
        
        result = phase.execute_sync(context)
        
        print("-" * 50)
        print("✅ 実行完了!")
        print(f"🎯 レポート成功: {result.get('report_completed', False)}")
        
        if result.get('project_summary'):
            print(f"\n📋 プロジェクト概要:")
            summary = result['project_summary']
            print(summary[:300] + "..." if len(summary) > 300 else summary)
        
        if result.get('final_report'):
            print(f"\n📊 最終レポート:")
            report = result['final_report']
            print(report[:400] + "..." if len(report) > 400 else report)
        
        # 保存されたレポートファイルを確認
        report_file = test_project_path / "PROJECT_REPORT.md"
        if report_file.exists():
            print(f"\n📄 レポートファイル作成確認: {report_file}")
            print(f"📄 ファイルサイズ: {report_file.stat().st_size} bytes")
        
        if result.get('error'):
            print(f"\n❌ エラー: {result['error']}")