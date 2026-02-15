# Phase 6: 実践的なプログラム構築

## 学習目標

- モジュールとパッケージの使い方を理解する
- ファイルの読み書きができるようになる
- 学んだ知識を統合した実践プログラムを構築できるようになる

> **出典**: [Python Tutorial §6. Modules](https://docs.python.org/3/tutorial/modules.html)、[§7. Input and Output](https://docs.python.org/3/tutorial/inputoutput.html)、[§12. Virtual Environments and Packages](https://docs.python.org/3/tutorial/venv.html)

## 理論: モジュール

### モジュールのインポート

```python
# モジュール全体をインポート
import math
print(math.sqrt(16))

# 特定の名前をインポート
from math import sqrt, pi
print(sqrt(16))

# エイリアス付き
import math as m
from module import long_name as short
```

### __name__ と __main__

スクリプトとして実行された場合、`__name__` は `'__main__'` になります。
モジュールとしてインポートされた場合はモジュール名になります。

```python
# mymodule.py
def main():
    print("メイン処理")

if __name__ == "__main__":
    main()  # python mymodule.py で実行したときだけ実行
```

> **出典**: [Python Tutorial §6.1.1. Executing modules as scripts](https://docs.python.org/3/tutorial/modules.html#executing-modules-as-scripts)

### パッケージ

パッケージは `__init__.py` を含むディレクトリです。

```
mypackage/
├── __init__.py
├── module1.py
└── module2.py
```

```python
from mypackage import module1
from mypackage.module2 import some_function
```

### 標準ライブラリの例

```python
import random
print(random.randint(1, 10))

import json
data = {"name": "Alice", "age": 25}
json_str = json.dumps(data)
parsed = json.loads(json_str)

import os
print(os.getcwd())
print(os.listdir('.'))

from datetime import datetime
print(datetime.now())
```

> **出典**: [Python Tutorial §6.2. Standard Modules](https://docs.python.org/3/tutorial/modules.html#standard-modules)、[PCAP Exam Syllabus - Modules & Packages 12%](https://pythoninstitute.org/pcap-exam-syllabus)

## 理論: ファイルI/O

### ファイルの読み書き

```python
# 書き込み
with open('output.txt', 'w', encoding='utf-8') as f:
    f.write("Hello, Python!\n")
    f.write("2行目\n")

# 読み込み
with open('output.txt', 'r', encoding='utf-8') as f:
    content = f.read()
    print(content)

# 行ごとに読み込み
with open('output.txt', 'r', encoding='utf-8') as f:
    for line in f:
        print(line.strip())
```

### モード

| モード | 説明 |
|--------|------|
| `'r'` | 読み込み（デフォルト） |
| `'w'` | 書き込み（上書き） |
| `'a'` | 追記 |
| `'x'` | 新規作成（存在するとエラー） |
| `'b'` | バイナリモード（`'rb'`, `'wb'`） |

> **出典**: [Python Tutorial §7.2. Reading and Writing Files](https://docs.python.org/3/tutorial/inputoutput.html#reading-and-writing-files)

### with 文

`with` を使うと、ブロック終了時にファイルが自動的にクローズされます。推奨される書き方です。

```python
with open('file.txt') as f:
    data = f.read()
# ここで f は自動的にクローズされる
```

### JSONの読み書き

```python
import json

# 書き込み
data = {"users": [{"name": "Alice", "age": 25}]}
with open('data.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

# 読み込み
with open('data.json', 'r', encoding='utf-8') as f:
    loaded = json.load(f)
```

> **出典**: [Python Tutorial §7.2.2. Saving structured data with json](https://docs.python.org/3/tutorial/inputoutput.html#saving-structured-data-with-json)

## 実践: タスク管理アプリ

学んだ知識を統合して、シンプルなタスク管理アプリを作成します。

### プロジェクト構成

```
task_manager/
├── task_manager.py    # メインスクリプト
├── tasks.json        # データ保存（実行時生成）
└── README.md
```

### Step 1: タスククラス

```python
# task_manager.py
import json
from pathlib import Path

class Task:
    def __init__(self, title, done=False):
        self.title = title
        self.done = done

    def __str__(self):
        status = "✓" if self.done else " "
        return f"[{status}] {self.title}"

    def to_dict(self):
        return {"title": self.title, "done": self.done}

    @classmethod
    def from_dict(cls, d):
        return cls(d["title"], d.get("done", False))
```

### Step 2: タスクマネージャークラス

```python
class TaskManager:
    def __init__(self, filename="tasks.json"):
        self.filename = Path(filename)
        self.tasks = self._load()

    def _load(self):
        if self.filename.exists():
            with open(self.filename, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return [Task.from_dict(t) for t in data]
        return []

    def _save(self):
        with open(self.filename, 'w', encoding='utf-8') as f:
            json.dump(
                [t.to_dict() for t in self.tasks],
                f, indent=2, ensure_ascii=False
            )

    def add(self, title):
        self.tasks.append(Task(title))
        self._save()

    def done(self, index):
        if 0 <= index < len(self.tasks):
            self.tasks[index].done = True
            self._save()

    def list_tasks(self):
        for i, task in enumerate(self.tasks):
            print(f"{i}: {task}")
```

### Step 3: メインループ

```python
def main():
    manager = TaskManager()
    while True:
        cmd = input("コマンド (add/list/done/quit): ").strip().lower()
        if cmd == "add":
            title = input("タスク名: ")
            manager.add(title)
        elif cmd == "list":
            manager.list_tasks()
        elif cmd == "done":
            try:
                idx = int(input("完了にする番号: "))
                manager.done(idx)
            except (ValueError, IndexError):
                print("無効な番号です")
        elif cmd == "quit":
            break

if __name__ == "__main__":
    main()
```

## 練習問題

1. タスクの削除機能を追加する
2. タスクの編集（タイトル変更）機能を追加する
3. 日付によるタスクの並び替えを実装する

<details>
<summary>解答例</summary>

**1. タスク削除**: `TaskManager` に以下を追加

```python
def delete(self, index):
    if 0 <= index < len(self.tasks):
        self.tasks.pop(index)
        self._save()
```

メインループに `case "delete"` を追加し、`idx = int(input("削除する番号: "))` で `manager.delete(idx)` を呼ぶ。

**2. タスク編集**: `TaskManager` に以下を追加

```python
def update(self, index, new_title):
    if 0 <= index < len(self.tasks):
        self.tasks[index].title = new_title
        self._save()
```

`Task` の `to_dict` で `title` を保存していることを確認。メインループで `update` コマンドを追加。

**3. 日付による並び替え**: `Task` に `created_at` を追加し、`datetime` で保存。読み込み時に `datetime.fromisoformat()` で復元し、`sorted(key=lambda t: t.created_at)` で並び替える。

```python
# Task クラスの修正
from datetime import datetime

class Task:
    def __init__(self, title, done=False, created_at=None):
        self.title = title
        self.done = done
        self.created_at = created_at or datetime.now()

    def __str__(self):
        status = "✓" if self.done else " "
        return f"[{status}] {self.title}"

    def to_dict(self):
        return {
            "title": self.title,
            "done": self.done,
            "created_at": self.created_at.isoformat(),
        }

    @classmethod
    def from_dict(cls, d):
        created_at = d.get("created_at")
        if created_at:
            created_at = datetime.fromisoformat(created_at)
        return cls(d["title"], d.get("done", False), created_at)
```

```python
# TaskManager._load の修正（読み込み時に日付でソート）
def _load(self):
    if self.filename.exists():
        with open(self.filename, 'r', encoding='utf-8') as f:
            data = json.load(f)
            tasks = [Task.from_dict(t) for t in data]
            tasks.sort(key=lambda t: t.created_at)
            return tasks
    return []
```

既存のタスク（`created_at` がない）には `from_dict` で `created_at=None` を渡すと `datetime.now()` が使われる。新規タスクは `add` で `Task(title)` を作る際に自動で `created_at` が設定される。
</details>

## まとめ

- **モジュール**: `import`、`from ... import`、`__name__`
- **パッケージ**: `__init__.py`、階層的インポート
- **ファイルI/O**: `open()`、`with`、`read()`/`write()`
- **JSON**: `json.dump()`、`json.load()`

## 学習完了

3時間版を完了しました！Pythonの基礎を包括的に学びました。PCEPおよびPCAP認定試験の準備が整っています。

さらに学ぶには：
- [Python公式チュートリアル](https://docs.python.org/3/tutorial/)
- [Python Standard Library](https://docs.python.org/3/library/)
- [Real Python](https://realpython.com/)
