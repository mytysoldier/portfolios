"""
プロジェクト実行コンテキスト - 各フェーズ間でデータを共有
"""
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Any, List, Optional
from datetime import datetime, timedelta


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
    
    # 実行時間管理
    workflow_start_time: Optional[datetime] = None
    workflow_end_time: Optional[datetime] = None
    phase_timings: Dict[str, Dict[str, Any]] = field(default_factory=dict)
    
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
    
    def start_workflow_timer(self):
        """ワークフロー全体の実行時間測定を開始"""
        self.workflow_start_time = datetime.now()
    
    def end_workflow_timer(self):
        """ワークフロー全体の実行時間測定を終了"""
        self.workflow_end_time = datetime.now()
    
    def start_phase_timer(self, phase_name: str):
        """フェーズの実行時間測定を開始"""
        if phase_name not in self.phase_timings:
            self.phase_timings[phase_name] = {}
        self.phase_timings[phase_name]["start_time"] = datetime.now()
    
    def end_phase_timer(self, phase_name: str):
        """フェーズの実行時間測定を終了"""
        if phase_name in self.phase_timings and "start_time" in self.phase_timings[phase_name]:
            end_time = datetime.now()
            start_time = self.phase_timings[phase_name]["start_time"]
            duration = end_time - start_time
            self.phase_timings[phase_name]["end_time"] = end_time
            self.phase_timings[phase_name]["duration"] = duration
    
    def get_workflow_duration(self) -> Optional[timedelta]:
        """ワークフロー全体の実行時間を取得"""
        if self.workflow_start_time and self.workflow_end_time:
            return self.workflow_end_time - self.workflow_start_time
        return None
    
    def get_phase_duration(self, phase_name: str) -> Optional[timedelta]:
        """指定フェーズの実行時間を取得"""
        if phase_name in self.phase_timings:
            return self.phase_timings[phase_name].get("duration")
        return None
    
    def format_duration(self, duration: Optional[timedelta]) -> str:
        """実行時間を見やすい形式にフォーマット"""
        if not duration:
            return "不明"
        
        total_seconds = int(duration.total_seconds())
        minutes = total_seconds // 60
        seconds = total_seconds % 60
        
        if minutes > 0:
            return f"{minutes}分{seconds}秒"
        else:
            return f"{seconds}秒"
    
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