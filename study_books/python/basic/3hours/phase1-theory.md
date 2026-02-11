# Phase 1: Pythonの理論と基本概念

## 学習目標

- Pythonの言語設計と特徴を理解する
- 変数、リテラル、演算子の詳細を理解する
- コーディング規約（PEP 8）を知る

> **出典**: 本Phaseは [Python公式チュートリアル](https://docs.python.org/3/tutorial/)、[Python Language Reference](https://docs.python.org/3/reference/)、[PEP 8](https://peps.python.org/pep-0008/) に基づいています。

> **環境**: 実践する際は venv を有効化してから `python` を実行してください（[3時間版README](./README.md) の「venv（仮想環境）での学習」参照）。

## Pythonの言語設計

### インタプリタ vs コンパイラ

Pythonは**インタプリタ言語**です。ソースコードが逐次解釈・実行されます[^1]。

- コンパイラ言語（C、C++など）: ソース → 機械語 → 実行
- インタプリタ言語（Python）: ソース → バイトコード → 仮想マシンで実行

### 字句・構文・意味論

プログラムの処理には3つの段階があります：

1. **字句解析（Lexical analysis）**: トークンに分割（キーワード、識別子、リテラルなど）
2. **構文解析（Syntax analysis）**: トークンを文法的に解釈
3. **意味論（Semantics）**: 実行時の意味を解釈

[^1]: [PCEP Exam Syllabus - Fundamentals](https://pythoninstitute.org/pcep-exam-syllabus)

## リテラルとデータ型

### 数値リテラル

| 種類 | 例 | 型 |
|------|-----|-----|
| 整数 | `42`, `0`, `-17` | `int` |
| 浮動小数点数 | `3.14`, `2e-3`, `1.5e10` | `float` |
| 複素数 | `3+5j`, `1j` | `complex` |

```python
>>> 0o10   # 8進数
8
>>> 0x10   # 16進数
16
>>> 0b10   # 2進数
2
```

### 文字列リテラル

```python
# シングル/ダブルクォート
'hello'
"world"

# トリプルクォート（複数行）
'''複数行
の文字列'''

# エスケープシーケンス
'\n'   # 改行
'\t'   # タブ
'\\'   # バックスラッシュ

# raw文字列（エスケープ無効）
r'C:\some\name'
```

> **出典**: [Python Tutorial §3.1.2. Text](https://docs.python.org/3/tutorial/introduction.html#text)

### ブール型（bool）

`True` と `False`。先頭は大文字です。

```python
>>> True
True
>>> 1 == 1
True
>>> bool(0)
False
>>> bool("")
False
```

## 演算子

### 算術演算子

| 演算子 | 説明 | 例 |
|--------|------|-----|
| `+` | 加算 | `3 + 2` → `5` |
| `-` | 減算 | `5 - 2` → `3` |
| `*` | 乗算 | `3 * 2` → `6` |
| `/` | 浮動小数点除算 | `5 / 2` → `2.5` |
| `//` | 切り捨て除算 | `5 // 2` → `2` |
| `%` | 剰余 | `5 % 2` → `1` |
| `**` | 累乗 | `2 ** 3` → `8` |

### 比較演算子

| 演算子 | 説明 |
|--------|------|
| `==` | 等しい |
| `!=` | 等しくない |
| `<` | 未満 |
| `>` | より大きい |
| `<=` | 以下 |
| `>=` | 以上 |
| `is` | 同一オブジェクト |
| `is not` | 異なるオブジェクト |
| `in` | 含む（メンバーシップ） |
| `not in` | 含まない |

### 論理演算子

| 演算子 | 説明 |
|--------|------|
| `and` | 論理積 |
| `or` | 論理和 |
| `not` | 否定 |

```python
>>> True and False
False
>>> True or False
True
>>> not True
False
```

### 演算子の優先順位

`**` > 単項 `+` `-` > `*` `/` `//` `%` > `+` `-` > 比較 > `not` > `and` > `or`

```python
>>> -3 ** 2   # -(3**2) と解釈される
-9
>>> (-3) ** 2
9
```

> **出典**: [Python Tutorial - Operator precedence](https://docs.python.org/3/reference/expressions.html#operator-precedence)

## 変数と名前付け

### 識別子の規則

- 文字、数字、アンダースコア `_` が使える
- 数字で始められない
- キーワード（予約語）は使えない

```python
# 有効な名前
my_var = 1
_name = "private"
MAX_SIZE = 100
```

### PEP 8 コーディング規約

> **出典**: [PEP 8 -- Style Guide for Python Code](https://peps.python.org/pep-0008/)

| 種類 | スタイル | 例 |
|------|----------|-----|
| 変数・関数 | snake_case | `my_variable`, `calculate_total` |
| 定数 | UPPER_CASE | `MAX_VALUE`, `API_KEY` |
| クラス | PascalCase | `MyClass`, `UserAccount` |
| モジュール | 短い小文字 | `mymodule` |

- インデントは4スペース（タブ非推奨）
- 1行は79文字以内（推奨）

## まとめ

- Pythonはインタプリタ言語で、字句・構文・意味論の3段階で処理される
- リテラル: int、float、str、bool
- 演算子: 算術、比較、論理の優先順位を理解する
- PEP 8 に従った名前付けとスタイル

## 次のステップ

[Phase 2](./phase2-control-flow.md) では、制御フロー（if、for、while）を詳しく学びます。
