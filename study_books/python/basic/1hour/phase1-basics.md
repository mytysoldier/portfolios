# Phase 1: Pythonの基本

## 学習目標

- Pythonの基本構文を理解する
- 変数、データ型、演算子を使えるようになる
- 入力（input）と出力（print）を扱えるようになる

> **出典**: 本Phaseの内容は主に [Python公式チュートリアル §3. An Informal Introduction to Python](https://docs.python.org/3/tutorial/introduction.html) に基づいています。

> **環境**: コード例を試す場合は、事前に venv を有効化してください（[1時間版README](./README.md) の「venv（仮想環境）の準備」参照）。

## Pythonとは

Pythonは、習得が容易で強力なプログラミング言語です。効率的な高レベルデータ構造と、シンプルかつ効果的なオブジェクト指向プログラミングのアプローチを備えています[^1]。

### Pythonの特徴

- **インデントによるブロック表現**: 他の言語の `{}` の代わりに、インデントでブロックを表現
- **動的型付け**: 変数の型を明示的に宣言しない
- **インタプリタ言語**: プログラムを逐次実行

[^1]: [Python公式チュートリアル](https://docs.python.org/3/tutorial/)

## 数値と演算子

### 数値型

Pythonには主に2つの数値型があります：

| 型 | 説明 | 例 |
|---|---|---|
| `int` | 整数 | `42`, `-17` |
| `float` | 浮動小数点数 | `3.14`, `-0.5` |

```python
# 基本的な算術演算
>>> 2 + 2
4
>>> 50 - 5 * 6
20
>>> (50 - 5 * 6) / 4
5.0

# 除算 (/) は常にfloatを返す
>>> 8 / 5
1.6

# 整数除算 (//) と剰余 (%)
>>> 17 // 3   # 切り捨て除算
5
>>> 17 % 3    # 剰余
2

# 累乗 (**)
>>> 5 ** 2
25
```

> **出典**: [Python Tutorial §3.1.1. Numbers](https://docs.python.org/3/tutorial/introduction.html#numbers)

### 変数への代入

`=` を使って変数に値を代入します。

```python
>>> width = 20
>>> height = 5 * 9
>>> width * height
900
```

## 文字列（str）

文字列はシングルクォート `'...'` またはダブルクォート `"..."` で囲みます[^2]。

```python
>>> 'spam eggs'
'spam eggs'
>>> "Python"
'Python'

# インデックス（0始まり）
>>> word = 'Python'
>>> word[0]
'P'
>>> word[-1]   # 負のインデックスは末尾から
'n'

# スライス [開始:終了]（終了は含まれない）
>>> word[0:2]
'Py'
>>> word[:2]   # 先頭省略 = 0
'Py'
>>> word[4:]   # 末尾省略 = 最後まで
'on'
```

> **重要**: 文字列は**イミュータブル（不変）**です。`word[0] = 'J'` はエラーになります。

[^2]: [Python Tutorial §3.1.2. Text](https://docs.python.org/3/tutorial/introduction.html#text)

### 文字列の操作

```python
>>> 3 * 'un' + 'ium'
'unununium'
>>> 'Py' 'thon'   # リテラル同士は自動結合
'Python'
>>> prefix = 'Py'
>>> prefix + 'thon'   # 変数には + が必要
'Python'
>>> len('Python')
6
```

## リスト（list）

リストは角括弧 `[]` で囲み、カンマで区切ります。**ミュータブル（可変）**です[^3]。

```python
>>> squares = [1, 4, 9, 16, 25]
>>> squares[0]
1
>>> squares[-1]
25
>>> squares[-3:]
[9, 16, 25]

# リストの変更
>>> cubes = [1, 8, 27, 64, 125]
>>> cubes[3] = 64
>>> cubes.append(216)
>>> cubes
[1, 8, 27, 64, 125, 216]

# ネストしたリスト
>>> a = ['a', 'b', 'c']
>>> n = [1, 2, 3]
>>> x = [a, n]
>>> x[0][1]
'b'
```

[^3]: [Python Tutorial §3.1.3. Lists](https://docs.python.org/3/tutorial/introduction.html#lists)

## 入出力

### print()

`print()` は引数を標準出力に出力します。

```python
>>> print('Hello, World!')
Hello, World!
>>> print('The value of i is', 65536)
The value of i is 65536

# sep と end で区切り・末尾を指定
>>> print(1, 2, 3, sep=', ', end='!\n')
1, 2, 3!
```

> **出典**: [Python Library - print()](https://docs.python.org/3/library/functions.html#print)

### input()

`input()` はユーザー入力を文字列として読み取ります。

```python
>>> name = input('Your name: ')
Your name: Alice
>>> print('Hello,', name)
Hello, Alice

# 数値として扱う場合は型変換
>>> age = int(input('Your age: '))
Your age: 25
>>> age + 1
26
```

## 型変換

`int()` と `float()` で型変換できます。

```python
>>> int('42')
42
>>> float('3.14')
3.14
>>> str(42)
'42'
```

## コメントとPEP 8

```python
# これはコメントです（# から行末まで）
spam = 1  # インラインコメントも可能
```

> **出典**: [PEP 8 -- Style Guide for Python Code](https://peps.python.org/pep-0008/) では、変数名は `snake_case`、定数は `UPPER_CASE` などが推奨されています。

## まとめ

- **数値**: `int` と `float`、演算子 `+`, `-`, `*`, `/`, `//`, `%`, `**`
- **文字列**: イミュータブル、インデックス・スライス可能
- **リスト**: ミュータブル、`append()` で追加
- **入出力**: `print()`, `input()`
- **型変換**: `int()`, `float()`, `str()`

## 次のステップ

[Phase 2](./phase2-practice.md) では、制御フローと実践的なプログラムを作成します。
