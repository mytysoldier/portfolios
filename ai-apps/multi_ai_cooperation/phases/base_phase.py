"""
ベースフェーズクラス - 各フェーズの共通インターフェース
"""
from abc import ABC, abstractmethod
from typing import Any
from .context import ProjectContext


class BasePhase(ABC):
    """
    各フェーズの基底クラス
    """
    
    def __init__(self, name: str):
        self.name = name
    
    @abstractmethod
    async def execute(self, context: ProjectContext) -> Any:
        """
        フェーズを実行する
        
        Args:
            context: プロジェクトコンテキスト
            
        Returns:
            フェーズの実行結果
        """
        pass
    
    def _log(self, context: ProjectContext, message: str):
        """ログを記録"""
        full_message = f"[{self.name}] {message}"
        context.add_log(full_message)
        print(f"🔄 {full_message}")
    
    def _error(self, context: ProjectContext, error: str):
        """エラーを記録"""
        full_error = f"[{self.name}] {error}"
        context.add_error(full_error)
        print(f"❌ {full_error}")
    
    def _success(self, context: ProjectContext, message: str):
        """成功メッセージを記録"""
        full_message = f"[{self.name}] {message}"
        context.add_log(full_message)
        print(f"✅ {full_message}")
    
    def save_result(self, context: ProjectContext, result: Any):
        """フェーズ結果を保存"""
        context.add_phase_result(self.name, result)
        self._success(context, f"フェーズ完了: {type(result).__name__}")


class SyncPhase(BasePhase):
    """
    同期実行用のベースフェーズクラス
    """
    
    @abstractmethod
    def execute_sync(self, context: ProjectContext) -> Any:
        """
        同期実行メソッド
        """
        pass
    
    async def execute(self, context: ProjectContext) -> Any:
        """同期メソッドをラップ"""
        return self.execute_sync(context)