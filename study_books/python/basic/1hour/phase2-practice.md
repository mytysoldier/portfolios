# Phase 2: 実践 - 制御フローとプログラム

## 学習目標

- `if` / `elif` / `else` による分岐を理解する
- `for` ループと `while` ループを書けるようになる
- 簡単なプログラムを実装できるようになる

> **出典**: 本Phaseの内容は [Python公式チュートリアル §4. More Control Flow Tools](https://docs.python.org/3/tutorial/controlflow.html) に基づいています。

## 理論: 制御フロー

### if文

条件に応じて処理を分岐します。**インデント**がブロックを定義します[^1]。

```python
x = 10
if x < 0:
    print('負の数')
elif x == 0:
    print('ゼロ')
else:
    print('正の数')
# 出力: 正の数
```

### forループ

シーケンス（リスト、文字列、range）を反復処理します。

```python
# リストの反復
fruits = ['apple', 'banana', 'cherry']
for fruit in fruits:
    print(fruit)

# range(): 数値のシーケンスを生成
for i in range(5):      # 0, 1, 2, 3, 4
    print(i, end=' ')
# 出力: 0 1 2 3 4

for i in range(2, 6):   # 2, 3, 4, 5
    print(i)

for i in range(0, 10, 2):  # 0, 2, 4, 6, 8（ステップ2）
    print(i)
```

> **出典**: [Python Tutorial §4.2. for Statements](https://docs.python.org/3/tutorial/controlflow.html#for-statements), [§4.3. The range() Function](https://docs.python.org/3/tutorial/controlflow.html#the-range-function)

### whileループ

条件が真の間、繰り返し実行します。

```python
a, b = 0, 1
while a < 10:
    print(a, end=', ')
    a, b = b, a + b
# 出力: 0, 1, 1, 2, 3, 5, 8,
```

### break と continue

- `break`: ループを抜ける
- `continue`: 次の反復へスキップ

```python
for n in range(10):
    if n == 3:
        continue   # 3をスキップ
    if n == 7:
        break      # 7でループ終了
    print(n, end=' ')
# 出力: 0 1 2 4 5 6
```

[^1]: [PCEP Exam Syllabus - Control Flow 29%](https://pythoninstitute.org/pcep-exam-syllabus)

## 実践: ステップバイステップ

### Step 1: venv環境の準備と確認

まず venv で仮想環境を用意します（既に作成済みの場合は有効化のみ）。

```bash
# python/basic ディレクトリで実行
cd study_books/python/basic

# 初回のみ: 仮想環境を作成
python -m venv venv

# 仮想環境を有効化（macOS/Linux）
source venv/bin/activate
# Windows: venv\Scripts\activate

# プロンプトに (venv) と表示されればOK
python --version
```

### Step 2: 簡単なプログラムを作成

`hello.py` を作成します：

```python
# hello.py - 初めてのPythonプログラム
print("Hello, Python!")

name = input("あなたの名前を入力してください: ")
print(f"こんにちは、{name}さん！")
```

**ポイント**: `f"..."` はf-string（フォーマット済み文字列リテラル）で、`{}` 内の式が評価されて埋め込まれます。

> **出典**: [Python Tutorial §7.1.1. Formatted String Literals](https://docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals)

実行（venv が有効な状態で）：

```bash
python hello.py
```

### Step 3: 数当てゲーム

`guess_game.py` を作成します：

```python
# guess_game.py - 数当てゲーム
import random

secret = random.randint(1, 100)
attempts = 0

print("1から100の間の数を当ててください")

while True:
    try:
        guess = int(input("予想を入力: "))
    except ValueError:
        print("整数を入力してください")
        continue

    attempts += 1

    if guess < secret:
        print("もっと大きいです")
    elif guess > secret:
        print("もっと小さいです")
    else:
        print(f"正解！ {attempts}回で当てました")
        break
```

**ポイント**:
- `import random`: 乱数モジュールをインポート
- `try` / `except`: 例外処理（不正入力対応）

### Step 4: リストの処理

`list_demo.py` を作成します：

```python
# list_demo.py - リストの操作
numbers = [3, 1, 4, 1, 5, 9, 2, 6]

# 合計を計算
total = 0
for n in numbers:
    total += n
print(f"合計: {total}")

# 最大値
maximum = numbers[0]
for n in numbers[1:]:
    if n > maximum:
        maximum = n
print(f"最大値: {maximum}")

# または組み込み関数を使う
print(f"合計: {sum(numbers)}")
print(f"最大値: {max(numbers)}")
```

## 練習問題

以下のプログラムを実装してみましょう。

### 1. FizzBuzz

1から20までを出力するが、3の倍数は「Fizz」、5の倍数は「Buzz」、両方の倍数は「FizzBuzz」と表示する。

<details>
<summary>ヒント</summary>

- `for i in range(1, 21)` で1〜20を反復
- `i % 3 == 0` で3の倍数か判定
- `elif` を組み合わせる
</details>

<details>
<summary>解答例</summary>

```python
for i in range(1, 21):
    if i % 15 == 0:
        print("FizzBuzz")
    elif i % 3 == 0:
        print("Fizz")
    elif i % 5 == 0:
        print("Buzz")
    else:
        print(i)
```
</details>

### 2. 合計計算機

ユーザーが数値を入力し続け、空Enterで終了。入力された数値の合計を表示する。

<details>
<summary>解答例</summary>

```python
total = 0
while True:
    line = input("数値を入力（空Enterで終了）: ")
    if line == "":
        break
    try:
        total += float(line)
    except ValueError:
        print("数値を入力してください")
print(f"合計: {total}")
```
</details>

### 3. リストのフィルタ

整数のリストから偶数だけを抽出して新しいリストを作る。

```python
# 例: [1, 2, 3, 4, 5, 6] → [2, 4, 6]
```

<details>
<summary>解答例</summary>

```python
numbers = [1, 2, 3, 4, 5, 6]
evens = [n for n in numbers if n % 2 == 0]
print(evens)  # [2, 4, 6]

# または for ループで
evens = []
for n in numbers:
    if n % 2 == 0:
        evens.append(n)
```
</details>

## まとめ

- **分岐**: `if` / `elif` / `else`
- **反復**: `for`（リスト、range）、`while`
- **制御**: `break`（ループ脱出）、`continue`（スキップ）
- **f-string**: `f"{変数}"` で文字列に変数を埋め込む

## 次のステップ

1時間版を完了しました！より深く学びたい場合は、[3時間版](../3hours/README.md) に進んでください。関数、辞書、例外、オブジェクト指向まで体系的に学べます。
