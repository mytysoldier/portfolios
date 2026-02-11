# Phase 4: 関数と例外

## 学習目標

- 関数の定義と呼び出しを理解する
- デフォルト引数、キーワード引数、*args、**kwargs を扱えるようになる
- スコープと名前空間を理解する
- 例外処理を適切に書けるようになる

> **出典**: [Python Tutorial §4.8. Defining Functions](https://docs.python.org/3/tutorial/controlflow.html#defining-functions)、[§8. Errors and Exceptions](https://docs.python.org/3/tutorial/errors.html)。PCEP試験の28%がFunctions & Exceptions、PCAPの14%がExceptionsに関する出題です。

## 理論: 関数の定義

### 基本的な関数

```python
def greet(name):
    """挨拶を返す関数（ docstring ）"""
    return f"Hello, {name}!"

result = greet("Alice")
print(result)  # Hello, Alice!
```

- `def`: 関数定義のキーワード
- `return`: 戻り値を返す（省略時は `None`）
- 三重クォート `"""..."""`: ドキュメント文字列（docstring）

> **出典**: [Python Tutorial §4.9.7. Documentation Strings](https://docs.python.org/3/tutorial/controlflow.html#documentation-strings)

### デフォルト引数

```python
def ask_ok(prompt, retries=4, reminder='Please try again!'):
    while True:
        ok = input(prompt)
        if ok in ('y', 'ye', 'yes'):
            return True
        if ok in ('n', 'no'):
            return False
        retries = retries - 1
        if retries < 0:
            raise ValueError('invalid user response')
        print(reminder)
```

**注意**: デフォルト値は**1回だけ評価**されます。ミュータブルなオブジェクト（リスト、辞書）をデフォルトにしないこと。

```python
# 危険な例
def append_to(element, target=[]):   # 悪い！
    target.append(element)
    return target

# 推奨
def append_to(element, target=None):
    if target is None:
        target = []
    target.append(element)
    return target
```

> **出典**: [Python Tutorial §4.9.1. Default Argument Values](https://docs.python.org/3/tutorial/controlflow.html#default-argument-values)

### キーワード引数

```python
def parrot(voltage, state='a stiff', action='voom', type='Norwegian Blue'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.")
    print("Lovely plumage, the", type)

# キーワードで呼び出し
parrot(1000)
parrot(voltage=1000, action='VOOOOOM')
parrot(action='VOOOOOM', voltage=1000000)
```

### 可変長引数

```python
# *args: 位置引数のタプル
def concat(*args, sep="/"):
    return sep.join(args)

concat("earth", "mars", "venus")  # "earth/mars/venus"

# **kwargs: キーワード引数の辞書
def print_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")
```

> **出典**: [Python Tutorial §4.9.4. Arbitrary Argument Lists](https://docs.python.org/3/tutorial/controlflow.html#arbitrary-argument-lists)

### ラムダ式（Lambda）

無名の小さい関数を作成します。PCAP試験の出題範囲です。

```python
>>> lambda x: x + 1
<function <lambda> at 0x...>
>>> f = lambda x, y: x + y
>>> f(2, 3)
5

# ソートの key としてよく使う
>>> pairs = [(1, 'one'), (2, 'two'), (3, 'three')]
>>> pairs.sort(key=lambda pair: pair[1])
>>> pairs
[(1, 'one'), (3, 'three'), (2, 'two')]
```

> **出典**: [Python Tutorial §4.9.6. Lambda Expressions](https://docs.python.org/3/tutorial/controlflow.html#lambda-expressions)

## 理論: スコープ

変数の参照順序（LEGB）:
1. **L**ocal: 関数内
2. **E**nclosing: 外側の関数（クロージャ）
3. **G**lobal: モジュールレベル
4. **B**uilt-in: 組み込み

```python
x = 'global'
def foo():
    x = 'local'
    print(x)  # local
foo()
print(x)  # global
```

> **出典**: [Python Tutorial §9.2. Python Scopes and Namespaces](https://docs.python.org/3/tutorial/classes.html#scopes-and-namespaces)

## 理論: 例外処理

### try / except

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    print("ゼロ除算です")
```

### 複数の例外

```python
try:
    value = int(input("数値を入力: "))
except ValueError:
    print("整数を入力してください")
except KeyboardInterrupt:
    print("キャンセルされました")
```

### else と finally

```python
try:
    f = open('file.txt')
except FileNotFoundError:
    print("ファイルが見つかりません")
else:
    try:
        data = f.read()
    finally:
        f.close()
```

- `else`: 例外が発生しなかった場合に実行
- `finally`: 例外の有無に関わらず**常に**実行（クリーンアップ用）

### raise で例外を発生させる

```python
if x < 0:
    raise ValueError("x must be non-negative")
```

### ユーザー定義例外

```python
class MyError(Exception):
    pass

raise MyError("Something went wrong")
```

> **出典**: [Python Tutorial §8. Errors and Exceptions](https://docs.python.org/3/tutorial/errors.html)、[PCAP Exam Syllabus - Exceptions](https://pythoninstitute.org/pcap-exam-syllabus)

## 実践: 関数と例外を使ったプログラム

### Step 1: 安全な入力関数

```python
def get_int(prompt="数値を入力: ", min_val=None, max_val=None):
    while True:
        try:
            value = int(input(prompt))
            if min_val is not None and value < min_val:
                raise ValueError(f"{min_val}以上で入力してください")
            if max_val is not None and value > max_val:
                raise ValueError(f"{max_val}以下で入力してください")
            return value
        except ValueError as e:
            print(f"エラー: {e}")
```

### Step 2: ファイル処理と例外

```python
def read_lines(filename):
    try:
        with open(filename) as f:
            return f.readlines()
    except FileNotFoundError:
        print(f"ファイル '{filename}' が見つかりません")
        return []
    except PermissionError:
        print("読み取り権限がありません")
        return []
```

## 練習問題

1. デフォルト引数とキーワード引数を使った関数を定義する
2. ラムダを使ってリストをソートする
3. 例外処理で堅牢な計算機（+,-,*,/）を作る

<details>
<summary>解答例</summary>

**1. デフォルト引数とキーワード引数**

```python
def greet(name, greeting="Hello", punctuation="!"):
    return f"{greeting}, {name}{punctuation}"

print(greet("Alice"))                    # Hello, Alice!
print(greet("Bob", greeting="Hi"))      # Hi, Bob!
print(greet("Carol", punctuation="."))   # Hello, Carol.
```

**2. ラムダでソート**

```python
pairs = [(2, "two"), (1, "one"), (3, "three")]
pairs.sort(key=lambda p: p[1])  # 2番目要素でソート
print(pairs)  # [(1, 'one'), (3, 'three'), (2, 'two')]
```

**3. 例外処理付き計算機**

```python
while True:
    try:
        a = float(input("数値1: "))
        op = input("演算子 (+, -, *, /): ")
        b = float(input("数値2: "))
        if op == "+":
            print(a + b)
        elif op == "-":
            print(a - b)
        elif op == "*":
            print(a * b)
        elif op == "/":
            print(a / b if b != 0 else "ゼロ除算エラー")
        else:
            print("無効な演算子")
    except ValueError:
        print("数値を入力してください")
    except KeyboardInterrupt:
        break
```
</details>

## まとめ

- 関数: `def`、`return`、デフォルト引数、*args、**kwargs
- ラムダ: 簡潔な無名関数
- 例外: `try`/`except`/`else`/`finally`、`raise`

## 次のステップ

[Phase 5](./phase5-oop.md) では、オブジェクト指向プログラミング（クラスと継承）を学びます。
