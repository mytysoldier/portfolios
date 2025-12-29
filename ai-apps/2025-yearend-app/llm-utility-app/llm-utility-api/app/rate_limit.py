"""
IP/秒レート制限機能。

in-memory で IP ごとのリクエスト数をカウントし、
RATE_LIMIT_PER_SECOND を超えたら 429 を返す。
"""

import time
from collections import defaultdict
from typing import Dict, Tuple

from .config import get_settings


# IP -> (timestamp, count) のマッピング
# timestamp は秒単位の整数（time.time() の floor）
_rate_limit_store: Dict[str, Tuple[int, int]] = defaultdict(lambda: (0, 0))


def get_client_ip(request) -> str:
    """
    リクエストからクライアントIPを取得する。
    - X-Forwarded-For があれば先頭IPを使う（スペース除去）
    - なければ request.client.host
    """
    forwarded_for = request.headers.get("X-Forwarded-For")
    if forwarded_for:
        # 先頭IPを取得（カンマ区切りの場合がある）
        first_ip = forwarded_for.split(",")[0].strip()
        return first_ip
    if request.client:
        return request.client.host
    return "unknown"


def check_rate_limit(ip: str) -> bool:
    """
    IP のレート制限をチェックする。
    1秒のウィンドウごとにカウントし、RATE_LIMIT_PER_SECOND を超えたら False を返す。

    Returns:
        True: リクエスト許可
        False: レート制限超過
    """
    settings = get_settings()
    limit = settings.rate_limit_per_second

    current_second = int(time.time())

    last_second, count = _rate_limit_store[ip]

    if last_second == current_second:
        # 同じ秒内のリクエスト
        if count >= limit:
            return False
        _rate_limit_store[ip] = (current_second, count + 1)
        return True
    else:
        # 新しい秒のリクエスト
        _rate_limit_store[ip] = (current_second, 1)
        return True


def get_rate_limit_info() -> int:
    """
    現在のレート制限値を返す（エラーレスポンス用）。
    """
    settings = get_settings()
    return settings.rate_limit_per_second

