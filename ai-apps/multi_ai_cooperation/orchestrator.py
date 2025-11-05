# orchestrator.py (リファクタリング版)
"""
Multi-AI協調オーケストレーター - 軽量版
新しいフェーズベースアーキテクチャを使用
"""

from workflows.multi_ai_workflow import MultiAIWorkflow


class Orchestrator:
    """
    軽量化されたオーケストレーター
    実際の協調処理はMultiAIWorkflowに委譲
    """
    
    def __init__(self, output_dir: str = "generated_projects"):
        self.workflow = MultiAIWorkflow(output_dir)
        self.verbose_mode = False
    
    def set_verbose_mode(self, verbose: bool = True):
        """詳細表示モードの設定"""
        self.verbose_mode = verbose
        self.workflow.set_verbose_mode(verbose)
    
    def run_task(self, task: str):
        """
        タスクを実行（新アーキテクチャ使用）
        
        フローパターン:
        Gemini(要件分析) → Claude(設計) → Copilot(実装) → WarpCode(検証) → Claude(レポート)
        """
        try:
            # ワークフローを同期実行
            context = self.workflow.execute_workflow_sync(task)
            
            # 実行結果の表示
            if context.errors:
                print(f"\n⚠️ 実行中にエラーが発生しました:")
                for error in context.errors:
                    print(f"   {error}")
            
            return context
            
        except Exception as e:
            print(f"❌ オーケストレーター実行エラー: {str(e)}")
            return None


def get_user_preferences():
    """ユーザーの設定を取得"""
    print("\n⚙️  システム設定")
    print("=" * 30)
    
    # 詳細表示モードの選択
    detail_choice = input("📄 詳細表示モード (各フェーズの内容を詳しく表示) [y/N]: ").strip().lower()
    verbose_mode = detail_choice in ['y', 'yes', 'はい']
    
    return {
        "verbose_mode": verbose_mode
    }


if __name__ == "__main__":
    print("🚀 Multi-AI Cooperationシステムを開始します！")
    print("   'quit'または'exit'で終了します")
    print("   新しいフェーズベースアーキテクチャを使用")
    
    # 初期設定
    preferences = get_user_preferences()
    orchestrator = Orchestrator()
    orchestrator.set_verbose_mode(preferences["verbose_mode"])
    
    # 詳細表示モードの説明
    if preferences["verbose_mode"]:
        print("\n🔍 詳細表示モードが有効です:")
        print("   - 各フェーズの実行内容を詳細に表示")
        print("   - AI の応答内容を抜粋表示")
        print("   - ファイル作成・検証結果の詳細")
        print("   ※ より多くの情報が表示されます\n")
    else:
        print("\n📋 標準表示モードです:")
        print("   - 各フェーズの概要のみ表示")
        print("   - 実行結果のサマリー表示")
        print("   ※ 詳細を見たい場合は再起動して詳細モードを選択してください\n")
    
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
            
            # モード設定変更コマンド
            if user_input.lower() in ['config', 'setting', '設定']:
                new_preferences = get_user_preferences()
                orchestrator.set_verbose_mode(new_preferences["verbose_mode"])
                print("✅ 設定を更新しました\n")
                continue
            
            # タスクを実行
            print(f"\n🎯 タスク開始: {user_input}")
            print("🤖 AI協調フロー: Gemini → Claude → Copilot → WarpCode → Claude")
            if preferences["verbose_mode"]:
                print("🔍 詳細表示モードで実行中...")
            print("=" * 70)
            
            context = orchestrator.run_task(user_input)
            
            if context:
                print("=" * 70)
                print("🎉 タスク完了！")
                
                # 実行時間を表示
                workflow_duration = context.get_workflow_duration()
                if workflow_duration:
                    print(f"⏱️  総実行時間: {context.format_duration(workflow_duration)}")
                
                # フェーズ別実行時間を表示
                if context.phase_timings:
                    print("\n📊 フェーズ別実行時間:")
                    phase_names = ["requirement", "design", "implementation", "verification", "report"]
                    for phase_name in phase_names:
                        duration = context.get_phase_duration(phase_name)
                        if duration:
                            phase_display_names = {
                                "requirement": "要件・調査",
                                "design": "設計・仕様",
                                "implementation": "実装",
                                "verification": "検証・実行",
                                "report": "レポート"
                            }
                            display_name = phase_display_names.get(phase_name, phase_name)
                            print(f"   - {display_name}: {context.format_duration(duration)}")
                
                # プロジェクト概要を表示
                if context.project_path:
                    print(f"\n📁 プロジェクト保存先: {context.project_path}")
                
                if context.created_files:
                    print(f"📄 作成ファイル数: {len(context.created_files)}")
                
                # 詳細表示モードでの追加情報
                if preferences["verbose_mode"] and context.created_files:
                    print("\n📋 作成されたファイル一覧:")
                    for file_path in context.created_files[:10]:  # 最大10個表示
                        try:
                            file_size = file_path.stat().st_size if file_path.exists() else 0
                            print(f"   - {file_path.name} ({file_size} bytes)")
                        except:
                            print(f"   - {file_path.name}")
                    
                    if len(context.created_files) > 10:
                        print(f"   ... (+{len(context.created_files) - 10}個のファイル)")
            else:
                print("❌ タスクの実行に失敗しました。")
            
            print("\n" + "=" * 70)
            
            # 設定変更の提案
            if not preferences["verbose_mode"]:
                print("💡 より詳細な実行内容を見たい場合は 'config' と入力してください")
            
            print()  # 空行
            
        except KeyboardInterrupt:
            print("\n\n👋 システムを終了します。お疲れさまでした！")
            break
        except Exception as e:
            print(f"❌ エラーが発生しました: {e}")
            print("続けますか？ (Enter で続行)\n")