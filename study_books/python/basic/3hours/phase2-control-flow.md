# Phase 2: 制御フロー

## 学習目標

- if / elif / else の全てのパターンを理解する
- for ループと while ループを自在に使えるようになる
- range()、break、continue、else 節を理解する

> **出典**: [Python公式チュートリアル §4. More Control Flow Tools](https://docs.python.org/3/tutorial/controlflow.html)。PCEP試験の29%が制御フローに関する出題です。

## 理論: 条件分岐

### if 文

Pythonでは**インデント**がブロックを定義します。コロン `:` の後にインデントされたブロックが続きます[^1]。

```python
if condition:
    # condition が True のとき実行
    statement1
elif another_condition:
    # 最初の if が False で、another_condition が True のとき
    statement2
else:
    # どれも False のとき
    statement3
```

### ネストしたif

```python
x = 10
y = 5
if x > 0:
    if y > 0:
        print("両方とも正")
    else:
        print("xのみ正")
```

### pass 文

何もしないプレースホルダー。構文上ブロックが必要な場合に使用します。

```python
if condition:
    pass   # 後で実装する
```

> **出典**: [Python Tutorial §4.6. pass Statements](https://docs.python.org/3/tutorial/controlflow.html#pass-statements)

### match 文（Python 3.10+）

パターンマッチングによる分岐です。

```python
def http_error(status):
    match status:
        case 200:
            return "OK"
        case 404:
            return "Not Found"
        case 500 | 502:
            return "Server Error"
        case _:
            return "Unknown"
```

[^1]: [PCEP Exam Syllabus - Control Flow](https://pythoninstitute.org/pcep-exam-syllabus)

## 理論: ループ

### for 文

シーケンス（リスト、文字列、range、辞書など）の各要素に対して反復します。

```python
# リストの反復
for item in [1, 2, 3]:
    print(item)

# 文字列の反復
for char in "Python":
    print(char, end=' ')

# range(start, stop, step)
for i in range(5):        # 0, 1, 2, 3, 4
    print(i)
for i in range(2, 8, 2):   # 2, 4, 6
    print(i)
```

> **出典**: [Python Tutorial §4.2. for Statements](https://docs.python.org/3/tutorial/controlflow.html#for-statements)

### range() の詳細

```python
# range(stop)        → 0 から stop-1 まで
# range(start, stop) → start から stop-1 まで
# range(start, stop, step) → start から stop-1 まで、step 刻み

list(range(5))      # [0, 1, 2, 3, 4]
list(range(2, 6))   # [2, 3, 4, 5]
list(range(0, 10, 2))  # [0, 2, 4, 6, 8]
```

### while 文

条件が真の間、繰り返し実行します。

```python
n = 0
while n < 5:
    print(n)
    n += 1
```

### break と continue

```python
for i in range(10):
    if i == 3:
        continue   # 3をスキップして次へ
    if i == 7:
        break      # 7でループ終了
    print(i)
```

### for / while の else 節

ループが `break` で中断されなかった場合に `else` が実行されます。

```python
for n in range(2, 10):
    for x in range(2, n):
        if n % x == 0:
            break
    else:
        print(n, "は素数")
```

> **出典**: [Python Tutorial §4.4. break and continue](https://docs.python.org/3/tutorial/controlflow.html#break-and-continue-statements), [§4.5. else Clauses on Loops](https://docs.python.org/3/tutorial/controlflow.html#else-clauses-on-loops)

## 実践: 練習プログラム

venv が有効な状態で、以下のプログラムを `fizzbuzz.py` などとして保存し実行してください。

### Step 1: FizzBuzz の完成版

```python
# fizzbuzz.py
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

### Step 2: 素数判定

```python
# prime_check.py
def is_prime(n):
    if n < 2:
        return False
    for i in range(2, int(n ** 0.5) + 1):
        if n % i == 0:
            return False
    return True

for n in range(2, 30):
    if is_prime(n):
        print(n, end=' ')
# 2 3 5 7 11 13 17 19 23 29
```

## 練習問題

1. **九九表**: 2重ループで九九表を出力する
2. **フィボナッチ数列**: 100未満のフィボナッチ数を全て出力する
3. **ネストループ**: ピラミッド（`*` を使った三角形）を出力する

## まとめ

- `if` / `elif` / `else` で条件分岐
- `for` はシーケンスの反復、`range()` で数値シーケンス
- `while` は条件が真の間の反復
- `break`（脱出）、`continue`（スキップ）、`else`（未中断時）

## 次のステップ

[Phase 3](./phase3-data-structures.md) では、リスト、タプル、辞書、セットを詳しく学びます。
