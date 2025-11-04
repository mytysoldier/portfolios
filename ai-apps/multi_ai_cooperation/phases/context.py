"""
プロジェクト実行コンテキスト - 各フェーズ間でデータを共有
"""
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Any, List, Optional
from datetime import datetime


@dataclass
class ProjectContext:
    """
    各フェーズ間で共有されるプロジェクト情報
    """
    # 基本情報
    user_request: str = ""
    project_path: Optional[Path] = None
    created_at: datetime = field(default_factory=datetime.now)
    
    # フェーズ結果
    phase_results: Dict[str, Any] = field(default_factory=dict)
    
    # ファイル情報
    created_files: List[Path] = field(default_factory=list)
    
    # ログ・メッセージ
    logs: List[str] = field(default_factory=list)
    errors: List[str] = field(default_factory=list)
    
    def add_phase_result(self, phase_name: str, result: Any):
        """フェーズ結果を追加"""
        self.phase_results[phase_name] = result
    
    def get_phase_result(self, phase_name: str) -> Any:
        """フェーズ結果を取得"""
        return self.phase_results.get(phase_name)
    
    def add_log(self, message: str):
        """ログを追加"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.logs.append(f"[{timestamp}] {message}")
    
    def add_error(self, error: str):
        """エラーを追加"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.errors.append(f"[{timestamp}] {error}")
    
    def add_created_file(self, file_path: Path):
        """作成されたファイルを記録"""
        if file_path not in self.created_files:
            self.created_files.append(file_path)
    
    def get_summary(self) -> str:
        """プロジェクト概要を取得"""
        return f"""
プロジェクト概要:
- リクエスト: {self.user_request[:50]}...
- 作成日時: {self.created_at.strftime('%Y-%m-%d %H:%M:%S')}
- プロジェクトパス: {self.project_path}
- 完了フェーズ数: {len(self.phase_results)}
- 作成ファイル数: {len(self.created_files)}
- エラー数: {len(self.errors)}
""".strip()