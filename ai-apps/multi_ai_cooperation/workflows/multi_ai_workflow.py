"""
Multi-AI協調ワークフロー管理
"""
import asyncio
from typing import List, Dict, Any
from datetime import timedelta

from phases.context import ProjectContext
from phases.base_phase import BasePhase
from phases.requirement_phase import RequirementPhase
from phases.design_phase import DesignPhase
from phases.implementation_phase import ImplementationPhase
from phases.verification_phase import VerificationPhase
from phases.report_phase import ReportPhase


class MultiAIWorkflow:
    """
    Multi-AI協調ワークフローの管理クラス
    
    フェーズ    主担当        補助         内容
    ①要件・調査    Gemini      Claude      情報収集・要件分析
    ②設計・仕様    Claude      Gemini      技術設計・仕様変換
    ③実装         Copilot     Claude      コード実装
    ④検証・実行    WarpCode    Claude      テスト・検証
    ⑤レポート     Claude      Gemini      分析・改善提案
    """
    
    def __init__(self, output_dir: str = "generated_projects", verbose: bool = True):
        self.output_dir = output_dir
        self.verbose = verbose  # 詳細表示モードの制御
        self.phases: List[BasePhase] = []
        self._initialize_phases()
    
    def set_verbose_mode(self, verbose: bool = True):
        """詳細表示モードの設定"""
        self.verbose = verbose
    
    def _initialize_phases(self):
        """フェーズの初期化"""
        self.phases = [
            RequirementPhase(),
            DesignPhase(), 
            ImplementationPhase(self.output_dir),
            VerificationPhase(),
            ReportPhase()
        ]
    
    async def execute_workflow(self, user_request: str) -> ProjectContext:
        """
        ワークフロー全体を実行
        
        Args:
            user_request: ユーザーからのリクエスト
            
        Returns:
            実行結果を含むProjectContext
        """
        print("🚀 Multi-AI協調ワークフローを開始します")
        print(f"📝 リクエスト: {user_request}")
        print("=" * 60)
        
        # コンテキスト初期化
        context = ProjectContext(user_request=user_request)
        context.add_log("ワークフロー開始")
        
        # 全体実行時間の測定開始
        context.start_workflow_timer()
        
        try:
            # 各フェーズを順次実行
            for i, phase in enumerate(self.phases, 1):
                print(f"\n🔄 Phase {i}/5: {phase.name.upper()} - 実行中...")
                self._display_phase_header(phase.name)
                
                try:
                    # フェーズの実行時間測定開始
                    context.start_phase_timer(phase.name)
                    
                    # フェーズ実行
                    result = await phase.execute(context)
                    
                    # フェーズの実行時間測定終了
                    context.end_phase_timer(phase.name)
                    
                    if result:
                        phase_duration = context.get_phase_duration(phase.name)
                        duration_str = context.format_duration(phase_duration) if phase_duration else ""
                        print(f"✅ Phase {i} 完了: {phase.name} ({duration_str})")
                        
                        # 詳細表示モードの場合のみ詳細を表示
                        if self.verbose:
                            self._display_phase_details(phase.name, result)
                        
                        self._display_phase_summary(phase.name, result)
                    else:
                        print(f"❌ Phase {i} 失敗: {phase.name}")
                        context.add_error(f"Phase {phase.name} failed")
                        
                except Exception as e:
                    # エラー時も実行時間測定終了
                    context.end_phase_timer(phase.name)
                    
                    error_msg = f"Phase {phase.name} でエラー: {str(e)}"
                    print(f"❌ {error_msg}")
                    context.add_error(error_msg)
                    
                    # クリティカルフェーズ（要件・実装）でエラーの場合は中断
                    if phase.name in ["requirement", "implementation"]:
                        print("🛑 クリティカルフェーズでエラーが発生したため、ワークフローを中断します")
                        break
                
                # フェーズ間の区切り
                print("─" * 70)
            
            print("\n" + "=" * 60)
            print("🎉 Multi-AI協調ワークフロー完了")
            
            # 全体実行時間の測定終了
            context.end_workflow_timer()
            
            self._display_final_summary(context)
            
            return context
            
        except Exception as e:
            # エラー時も全体実行時間の測定終了
            context.end_workflow_timer()
            
            error_msg = f"ワークフロー実行エラー: {str(e)}"
            print(f"❌ {error_msg}")
            context.add_error(error_msg)
            return context
    
    def execute_workflow_sync(self, user_request: str) -> ProjectContext:
        """
        同期的にワークフローを実行（非同期環境でない場合用）
        """
        return asyncio.run(self.execute_workflow(user_request))
    
    def _display_phase_header(self, phase_name: str):
        """フェーズ開始時のヘッダー表示"""
        headers = {
            "requirement": "📋 Geminiが要件分析・情報収集を実行中...",
            "design": "📐 Claude Codeが技術設計・仕様変換を実行中...", 
            "implementation": "💻 Copilotが実装・コード生成を実行中...",
            "verification": "🧪 WarpCodeが自動検証・実行テストを実行中...",
            "report": "📊 Claude Codeがレポート・改善提案を生成中..."
        }
        
        if phase_name in headers:
            print(f"   {headers[phase_name]}")
            print("   " + "・" * 20)

    def _display_phase_details(self, phase_name: str, result: Dict[str, Any]):
        """各フェーズの詳細結果を表示"""
        
        detail_handlers = {
            "requirement": self._display_requirement_details,
            "design": self._display_design_details,
            "implementation": self._display_implementation_details,
            "verification": self._display_verification_details,
            "report": self._display_report_details
        }
        
        if phase_name in detail_handlers:
            print(f"\n📄 {phase_name.upper()}フェーズ詳細結果:")
            detail_handlers[phase_name](result)
    
    def _display_requirement_details(self, result: Dict[str, Any]):
        """要件フェーズの詳細表示"""
        if result.get("analysis_completed"):
            raw_response = result.get("raw_response", "")
            if raw_response:
                # 要件分析結果の要約表示
                lines = raw_response.split('\n')
                print("   🔍 Gemini分析結果 (抜粋):")
                for line in lines[:10]:  # 最初の10行を表示
                    if line.strip():
                        print(f"   {line[:80]}{'...' if len(line) > 80 else ''}")
                if len(lines) > 10:
                    print(f"   ... (続きあり、総{len(lines)}行)")
        else:
            print("   ❌ 要件分析に失敗しました")

    def _display_design_details(self, result: Dict[str, Any]):
        """設計フェーズの詳細表示"""
        if result.get("design_completed"):
            spec = result.get("technical_specification", "")
            if spec:
                # 技術仕様の要約表示
                lines = spec.split('\n')
                print("   📐 技術設計仕様 (抜粋):")
                
                # 見出し行を優先的に表示
                important_lines = []
                for line in lines:
                    if line.strip().startswith(('#', '##', '###', '-', '*')):
                        important_lines.append(line[:80])
                        if len(important_lines) >= 8:
                            break
                
                for line in important_lines:
                    print(f"   {line}")
                    
                if len(lines) > len(important_lines):
                    print(f"   ... (詳細仕様あり、総{len(lines)}行)")
        else:
            print("   ❌ 技術設計に失敗しました")

    def _display_implementation_details(self, result: Dict[str, Any]):
        """実装フェーズの詳細表示"""
        if result.get("implementation_completed"):
            project_path = result.get("project_path", "")
            created_files = result.get("created_files", [])
            
            print(f"   💻 プロジェクト作成完了:")
            print(f"   📁 保存場所: {project_path}")
            print(f"   📄 作成ファイル ({len(created_files)}個):")
            
            for file_path in created_files[:10]:  # 最大10ファイル表示
                from pathlib import Path
                file_name = Path(file_path).name
                try:
                    file_size = Path(file_path).stat().st_size if Path(file_path).exists() else 0
                    print(f"      - {file_name} ({file_size} bytes)")
                except:
                    print(f"      - {file_name}")
            
            if len(created_files) > 10:
                print(f"      ... (+{len(created_files) - 10}個のファイル)")
            
            # Copilotの応答抜粋
            copilot_response = result.get("copilot_response", "")
            if copilot_response:
                print("   🤖 Copilot応答 (抜粋):")
                response_lines = copilot_response.split('\n')[:5]
                for line in response_lines:
                    if line.strip():
                        print(f"      {line[:70]}{'...' if len(line) > 70 else ''}")
        else:
            print("   ❌ 実装に失敗しました")

    def _display_verification_details(self, result: Dict[str, Any]):
        """検証フェーズの詳細表示"""
        if result.get("verification_completed"):
            overall_success = result.get("overall_success", False)
            verification_results = result.get("verification_results", [])
            
            print(f"   🧪 検証結果: {'✅ 全テスト成功' if overall_success else '⚠️ 一部問題あり'}")
            print("   🔬 実行テスト詳細:")
            
            for i, test in enumerate(verification_results, 1):
                status = "✅" if test.get("success", False) else "❌"
                test_name = test.get("test_name", "Unknown")
                message = test.get("message", "")
                print(f"      {i}. {status} {test_name}: {message}")
                
                # 詳細情報があれば表示
                details = test.get("details", {})
                if details and not test.get("success", True):
                    for key, value in details.items():
                        if isinstance(value, str) and key != "error":
                            print(f"         └ {key}: {str(value)[:50]}")
        else:
            print("   ❌ 検証に失敗しました")

    def _display_report_details(self, result: Dict[str, Any]):
        """レポートフェーズの詳細表示"""
        if result.get("report_completed"):
            print("   📊 生成されたレポート:")
            
            # プロジェクト概要
            project_summary = result.get("project_summary", "")
            if project_summary:
                summary_lines = project_summary.split('\n')[:6]
                print("   📋 プロジェクト概要:")
                for line in summary_lines:
                    if line.strip():
                        print(f"      {line[:75]}")
            
            # 実行分析
            execution_analysis = result.get("execution_analysis", "")
            if execution_analysis:
                analysis_lines = execution_analysis.split('\n')[:4]
                print("   📈 実行分析結果:")
                for line in analysis_lines:
                    if line.strip():
                        print(f"      {line[:75]}")
            
            # Geminiベンチマーク (最初の数行のみ)
            benchmark_analysis = result.get("benchmark_analysis", "")
            if benchmark_analysis:
                benchmark_lines = benchmark_analysis.split('\n')[:3]
                print("   🔮 Geminiベンチマーク分析 (抜粋):")
                for line in benchmark_lines:
                    if line.strip():
                        print(f"      {line[:75]}")
        else:
            print("   ❌ レポート生成に失敗しました")
    
    def _display_phase_summary(self, phase_name: str, result: Dict[str, Any]):
        """フェーズ結果のサマリーを表示"""
        
        summaries = {
            "requirement": self._summarize_requirement_phase,
            "design": self._summarize_design_phase,
            "implementation": self._summarize_implementation_phase,
            "verification": self._summarize_verification_phase,
            "report": self._summarize_report_phase
        }
        
        if phase_name in summaries:
            summaries[phase_name](result)
    
    def _summarize_requirement_phase(self, result: Dict[str, Any]):
        """要件フェーズのサマリー"""
        if result.get("analysis_completed"):
            print("   📋 要件分析完了")
        else:
            print("   ⚠️ 要件分析で問題が発生")
    
    def _summarize_design_phase(self, result: Dict[str, Any]):
        """設計フェーズのサマリー"""
        if result.get("design_completed"):
            print("   📐 技術設計完了")
        else:
            print("   ⚠️ 設計で問題が発生")
    
    def _summarize_implementation_phase(self, result: Dict[str, Any]):
        """実装フェーズのサマリー"""
        if result.get("implementation_completed"):
            project_path = result.get("project_path", "")
            file_count = len(result.get("created_files", []))
            print(f"   💻 実装完了: {file_count} ファイル作成")
            print(f"   📁 保存先: {project_path}")
        else:
            print("   ⚠️ 実装で問題が発生")
    
    def _summarize_verification_phase(self, result: Dict[str, Any]):
        """検証フェーズのサマリー"""
        if result.get("verification_completed"):
            overall_success = result.get("overall_success", False)
            test_count = len(result.get("verification_results", []))
            status = "全テスト成功" if overall_success else "一部テスト失敗"
            print(f"   🧪 検証完了: {test_count} テスト実行 - {status}")
        else:
            print("   ⚠️ 検証で問題が発生")
    
    def _summarize_report_phase(self, result: Dict[str, Any]):
        """レポートフェーズのサマリー"""
        if result.get("report_completed"):
            print("   📊 プロジェクトレポート生成完了")
        else:
            print("   ⚠️ レポート生成で問題が発生")
    
    def _display_final_summary(self, context: ProjectContext):
        """最終サマリーを表示"""
        
        print(f"📈 実行統計:")
        print(f"   - 実行フェーズ数: {len(context.phase_results)}")
        print(f"   - 作成ファイル数: {len(context.created_files)}")
        print(f"   - エラー数: {len(context.errors)}")
        
        # 実行時間統計
        workflow_duration = context.get_workflow_duration()
        if workflow_duration:
            print(f"   - 総実行時間: {context.format_duration(workflow_duration)}")
            
            # フェーズ別実行時間の詳細
            if context.phase_timings:
                print(f"\n⏱️  フェーズ別実行時間:")
                phase_names = ["requirement", "design", "implementation", "verification", "report"]
                phase_display_names = {
                    "requirement": "要件・調査",
                    "design": "設計・仕様", 
                    "implementation": "実装",
                    "verification": "検証・実行",
                    "report": "レポート"
                }
                
                total_phase_time = 0
                for phase_name in phase_names:
                    duration = context.get_phase_duration(phase_name)
                    if duration:
                        display_name = phase_display_names.get(phase_name, phase_name)
                        print(f"   - {display_name}: {context.format_duration(duration)}")
                        total_phase_time += duration.total_seconds()
                
                # 実際の処理時間とオーバーヘッド時間を表示
                if total_phase_time > 0:
                    overhead_seconds = workflow_duration.total_seconds() - total_phase_time
                    if overhead_seconds > 0:
                        overhead_duration = timedelta(seconds=overhead_seconds)
                        print(f"   - システムオーバーヘッド: {context.format_duration(overhead_duration)}")
        
        if context.project_path:
            print(f"\n📁 プロジェクトフォルダ: {context.project_path}")
        
        if context.errors:
            print(f"\n⚠️ エラーサマリー:")
            for error in context.errors[-3:]:  # 最新3件のエラー
                print(f"   - {error}")
        
        # 成功率計算
        successful_phases = 0
        for phase_name, result in context.phase_results.items():
            completion_key = f"{phase_name}_completed"
            if result.get(completion_key, False):
                successful_phases += 1
        
        success_rate = (successful_phases / len(self.phases) * 100) if len(self.phases) > 0 else 0
        print(f"\n🎯 総合成功率: {success_rate:.1f}%")


class WorkflowBuilder:
    """
    カスタムワークフローの構築用ビルダークラス
    """
    
    def __init__(self):
        self.phases: List[BasePhase] = []
        self.output_dir: str = "generated_projects"
    
    def add_phase(self, phase: BasePhase) -> 'WorkflowBuilder':
        """フェーズを追加"""
        self.phases.append(phase)
        return self
    
    def set_output_dir(self, output_dir: str) -> 'WorkflowBuilder':
        """出力ディレクトリを設定"""
        self.output_dir = output_dir
        return self
    
    def build(self) -> 'CustomWorkflow':
        """カスタムワークフローを構築"""
        return CustomWorkflow(self.phases, self.output_dir)


class CustomWorkflow:
    """
    カスタマイズされたワークフロー
    """
    
    def __init__(self, phases: List[BasePhase], output_dir: str):
        self.phases = phases
        self.output_dir = output_dir
    
    async def execute(self, user_request: str) -> ProjectContext:
        """カスタムワークフローを実行"""
        context = ProjectContext(user_request=user_request)
        
        for phase in self.phases:
            try:
                await phase.execute(context)
            except Exception as e:
                context.add_error(f"Phase {phase.name} error: {str(e)}")
        
        return context