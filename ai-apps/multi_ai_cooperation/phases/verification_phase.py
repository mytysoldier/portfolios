"""
自動検証・実行フェーズ - WarpCodeが主担当
"""
from typing import Dict, Any, List
from pathlib import Path
from .base_phase import SyncPhase
from .context import ProjectContext
from warpcode.warpcode import WarpAgent


class VerificationPhase(SyncPhase):
    """
    フェーズ④ 自動検証・実行
    主担当: WarpCode, 補助: Claude
    """
    
    def __init__(self):
        super().__init__("verification")
        self.warp = WarpAgent()
    
    def execute_sync(self, context: ProjectContext) -> Dict[str, Any]:
        """自動検証・実行を実行"""
        
        self._log(context, "自動検証フェーズ開始...")
        
        # 前フェーズの結果を取得
        implementation_result = context.get_phase_result("implementation")
        if not implementation_result or not implementation_result.get("implementation_completed"):
            self._error(context, "実装結果が見つかりません")
            return {"verification_completed": False, "error": "実装未完了"}
        
        project_path = Path(implementation_result["project_path"])
        if not project_path.exists():
            self._error(context, f"プロジェクトフォルダが見つかりません: {project_path}")
            return {"verification_completed": False, "error": "プロジェクトフォルダ不明"}
        
        try:
            # 検証タスクを実行
            verification_results = []
            
            # 1. プロジェクト構造の確認
            structure_check = self._check_project_structure(project_path)
            verification_results.append(structure_check)
            
            # 2. WarpCodeによる実行テスト
            execution_test = self._execute_warp_test(project_path)
            verification_results.append(execution_test)
            
            # 3. 基本的な動作確認
            basic_test = self._perform_basic_tests(project_path)
            verification_results.append(basic_test)
            
            # 全体的な評価
            overall_success = all(test.get("success", False) for test in verification_results)
            
            result = {
                "project_path": str(project_path),
                "verification_results": verification_results,
                "overall_success": overall_success,
                "verification_completed": True
            }
            
            # 結果を保存
            self.save_result(context, result)
            
            if overall_success:
                self._success(context, "すべての検証項目をクリアしました")
            else:
                self._log(context, "一部の検証項目で問題が検出されました")
            
            return result
            
        except Exception as e:
            self._error(context, f"検証フェーズ失敗: {str(e)}")
            return {
                "project_path": str(project_path),
                "verification_results": [],
                "overall_success": False,
                "verification_completed": False,
                "error": str(e)
            }
    
    def _check_project_structure(self, project_path: Path) -> Dict[str, Any]:
        """プロジェクト構造をチェック"""
        
        try:
            files = list(project_path.glob("*"))
            file_names = [f.name for f in files]
            
            # 基本的なチェック項目
            checks = {
                "has_main_file": any(
                    name.startswith(('main', 'index', 'app')) 
                    for name in file_names
                ),
                "has_readme": any(
                    name.lower().startswith('readme') 
                    for name in file_names
                ),
                "file_count": len(files),
                "files": file_names
            }
            
            success = checks["has_main_file"] and checks["file_count"] > 0
            
            return {
                "test_name": "Project Structure Check",
                "success": success,
                "details": checks,
                "message": "プロジェクト構造正常" if success else "プロジェクト構造に問題あり"
            }
            
        except Exception as e:
            return {
                "test_name": "Project Structure Check",
                "success": False,
                "details": {"error": str(e)},
                "message": f"構造チェックエラー: {str(e)}"
            }
    
    def _execute_warp_test(self, project_path: Path) -> Dict[str, Any]:
        """WarpCodeによる実行テスト"""
        
        try:
            test_prompt = f"""
以下のプロジェクトの動作確認を行ってください：

プロジェクトパス: {project_path}

【実行してほしいこと】
1. プロジェクトの内容を確認
2. 実行方法を特定
3. 基本的な動作テストを実行
4. エラーや問題があれば報告

【注意】
- 実際にプログラムを実行してテストしてください
- エラーが出た場合は詳細を報告してください
- 成功した場合も実行結果を報告してください
"""
            
            # プロジェクトディレクトリで実行
            warp_result = self.warp.run_prompt(test_prompt)
            
            if warp_result:
                # 簡単な成功判定（エラーキーワードの有無で判断）
                error_keywords = ["error", "failed", "exception", "not found", "cannot"]
                has_errors = any(keyword.lower() in warp_result.lower() for keyword in error_keywords)
                
                return {
                    "test_name": "WarpCode Execution Test",
                    "success": not has_errors,
                    "details": {"warp_output": warp_result},
                    "message": "実行テスト成功" if not has_errors else "実行テストで問題検出"
                }
            else:
                return {
                    "test_name": "WarpCode Execution Test",
                    "success": False,
                    "details": {"error": "WarpCodeの実行に失敗"},
                    "message": "WarpCode実行失敗"
                }
                
        except Exception as e:
            return {
                "test_name": "WarpCode Execution Test",
                "success": False,
                "details": {"error": str(e)},
                "message": f"実行テストエラー: {str(e)}"
            }
    
    def _perform_basic_tests(self, project_path: Path) -> Dict[str, Any]:
        """基本的な動作確認テスト"""
        
        try:
            tests_performed = []
            
            # ファイル読み込みテスト
            readable_files = []
            for file_path in project_path.glob("*"):
                if file_path.is_file() and file_path.suffix in ['.py', '.js', '.java', '.cpp', '.go', '.rs', '.txt', '.md']:
                    try:
                        content = file_path.read_text(encoding='utf-8')
                        readable_files.append({
                            "file": file_path.name,
                            "size": len(content),
                            "lines": len(content.split('\n'))
                        })
                    except Exception:
                        pass
            
            tests_performed.append({
                "test": "File Readability",
                "result": f"{len(readable_files)} files readable",
                "files": readable_files
            })
            
            # 基本的な構文チェック（Python の場合）
            python_files = list(project_path.glob("*.py"))
            if python_files:
                syntax_ok = True
                try:
                    import ast
                    for py_file in python_files:
                        content = py_file.read_text(encoding='utf-8')
                        ast.parse(content)
                except Exception as e:
                    syntax_ok = False
                    tests_performed.append({
                        "test": "Python Syntax Check",
                        "result": f"Syntax error: {str(e)}"
                    })
                
                if syntax_ok:
                    tests_performed.append({
                        "test": "Python Syntax Check", 
                        "result": "Syntax OK"
                    })
            
            success = len(readable_files) > 0
            
            return {
                "test_name": "Basic Tests",
                "success": success,
                "details": {"tests": tests_performed},
                "message": "基本テスト成功" if success else "基本テストで問題検出"
            }
            
        except Exception as e:
            return {
                "test_name": "Basic Tests",
                "success": False,
                "details": {"error": str(e)},
                "message": f"基本テストエラー: {str(e)}"
            }


if __name__ == "__main__":
    """
    VerificationPhase 単体実行テスト
    """
    print("🔬 VerificationPhase 単体実行テスト")
    print("=" * 50)
    
    from pathlib import Path
    import tempfile
    import os
    
    # テスト用リクエスト
    test_request = input("💭 テスト用リクエストを入力してください (Enterでデフォルト): ").strip()
    if not test_request:
        test_request = "簡単なテストプログラムを検証"
    
    # コンテキスト作成
    from .context import ProjectContext
    context = ProjectContext(user_request=test_request)
    
    # テスト用プロジェクトフォルダを作成
    with tempfile.TemporaryDirectory(prefix="test_verification_") as temp_dir:
        test_project_path = Path(temp_dir)
        
        # テスト用ファイルを作成
        (test_project_path / "main.py").write_text("""
# テスト用Pythonファイル
def hello_world():
    return "Hello, World!"

if __name__ == "__main__":
    print(hello_world())
""", encoding='utf-8')
        
        (test_project_path / "README.md").write_text("""
# テストプロジェクト
このはテスト用のプロジェクトです。

## 実行方法
```bash
python main.py
```
""", encoding='utf-8')
        
        (test_project_path / "config.json").write_text('{"name": "test", "version": "1.0"}', encoding='utf-8')
        
        # 模擬実装結果を設定
        mock_implementation = {
            "project_path": str(test_project_path),
            "created_files": [
                str(test_project_path / "main.py"),
                str(test_project_path / "README.md"),
                str(test_project_path / "config.json")
            ],
            "copilot_response": "テスト用プロジェクトを作成しました。",
            "implementation_completed": True
        }
        
        context.add_phase_result("implementation", mock_implementation)
        
        # フェーズ実行
        phase = VerificationPhase()
        
        print(f"\n🚀 実行開始: {test_request}")
        print(f"📁 テスト用プロジェクト: {test_project_path}")
        print("📄 テストファイル:")
        for file_path in test_project_path.glob("*"):
            print(f"   - {file_path.name}")
        print("-" * 50)
        
        result = phase.execute_sync(context)
        
        print("-" * 50)
        print("✅ 実行完了!")
        print(f"🎯 検証成功: {result.get('verification_completed', False)}")
        print(f"🎯 全体成功: {result.get('overall_success', False)}")
        
        if result.get('verification_results'):
            print(f"\n🧪 検証結果:")
            for i, test_result in enumerate(result['verification_results'], 1):
                status = "✅" if test_result.get('success') else "❌"
                print(f"   {status} Test {i}: {test_result.get('test_name', 'Unknown')} - {test_result.get('message', '')}")
        
        if result.get('error'):
            print(f"\n❌ エラー: {result['error']}")