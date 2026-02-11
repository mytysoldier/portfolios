# Phase 3: データ構造

## 学習目標

- リストの操作とリスト内包表記を理解する
- タプルとセットの特徴を理解する
- 辞書を自在に使えるようになる

> **出典**: [Python公式チュートリアル §5. Data Structures](https://docs.python.org/3/tutorial/datastructures.html)。PCEP試験の25%がData Collectionsに関する出題です。

## 理論: リスト（list）

### リストの基本

リストは**ミュータブル**なシーケンスです。角括弧 `[]` で作成します[^1]。

```python
fruits = ['apple', 'banana', 'cherry']
numbers = [1, 2, 3, 4, 5]
mixed = [1, 'hello', 3.14, True]
```

### インデックスとスライス

```python
>>> a = [1, 2, 3, 4, 5]
>>> a[0]
1
>>> a[-1]
5
>>> a[1:4]    # インデックス1〜3（4は含まない）
[2, 3, 4]
>>> a[::2]    # 2つおきに取得
[1, 3, 5]
>>> a[::-1]   # 逆順
[5, 4, 3, 2, 1]
```

### リストのメソッド

| メソッド | 説明 |
|----------|------|
| `append(x)` | 末尾に追加 |
| `extend(iterable)` | イテラブルを展開して追加 |
| `insert(i, x)` | インデックス i に挿入 |
| `remove(x)` | 最初の x を削除 |
| `pop([i])` | インデックス i の要素を削除して返す（省略時は末尾） |
| `clear()` | 全削除 |
| `index(x)` | x のインデックス |
| `count(x)` | x の出現回数 |
| `sort()` | 昇順ソート（インプレース） |
| `reverse()` | 逆順（インプレース） |

```python
>>> lst = [3, 1, 4, 1, 5]
>>> lst.append(9)
>>> lst.sort()
>>> lst
[1, 1, 3, 4, 5, 9]
```

### リスト内包表記（List Comprehensions）

リストを簡潔に生成する構文です。PCAP試験でも出題されます[^2]。

```python
# 基本的な形式: [式 for 変数 in イテラブル]
>>> squares = [x**2 for x in range(5)]
[0, 1, 4, 9, 16]

# 条件付き: [式 for 変数 in イテラブル if 条件]
>>> evens = [x for x in range(10) if x % 2 == 0]
[0, 2, 4, 6, 8]

# ネスト
>>> matrix = [[i*j for j in range(3)] for i in range(3)]
[[0, 0, 0], [0, 1, 2], [0, 2, 4]]
```

> **出典**: [Python Tutorial §5.1.3. List Comprehensions](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions)

[^1]: [Python Tutorial §5.1. More on Lists](https://docs.python.org/3/tutorial/datastructures.html#more-on-lists)
[^2]: [PCAP Exam Syllabus - Miscellaneous](https://pythoninstitute.org/pcap-exam-syllabus)

## 理論: タプル（tuple）

タプルは**イミュータブル**なシーケンスです。丸括弧 `()` で作成します。

```python
>>> t = (1, 2, 3)
>>> t[0]
1
>>> t[1:] = (4,)   # エラー！イミュータブル
TypeError: 'tuple' object does not support item assignment

# パッキングとアンパッキング
>>> a, b, c = 1, 2, 3
>>> x, y = y, x   # 変数の交換
```

> **出典**: [Python Tutorial §5.3. Tuples and Sequences](https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences)

## 理論: セット（set）

セットは**重複を許さない****順序なし**のコレクションです。花括弧 `{}` または `set()` で作成します。

```python
>>> s = {1, 2, 3, 2, 1}
>>> s
{1, 2, 3}

>>> basket = {'apple', 'orange', 'apple', 'banana'}
>>> 'apple' in basket
True
>>> 'pear' in basket
False
```

### セットのメソッド

```python
>>> a = {1, 2, 3}
>>> a.add(4)
>>> a.remove(2)      # 存在しないと KeyError
>>> a.discard(2)     # 存在しなくてもエラーにならない
>>> a
{1, 3, 4}
```

> **出典**: [Python Tutorial §5.4. Sets](https://docs.python.org/3/tutorial/datastructures.html#sets)

## 理論: 辞書（dict）

辞書は**キーと値のペア**を格納するマッピング型です。

```python
>>> tel = {'jack': 4098, 'sape': 4139}
>>> tel['guido'] = 4127
>>> tel['jack']
4098
>>> del tel['sape']
>>> list(tel.keys())
['jack', 'guido']
>>> 'guido' in tel
True
```

### 辞書の作成と操作

```python
# リテラル
d = {'name': 'Alice', 'age': 25}

# dict() コンストラクタ
d = dict(name='Alice', age=25)

# キーが存在しない場合のデフォルト
>>> d.get('city', 'Unknown')
'Unknown'

# 辞書内包表記
>>> {x: x**2 for x in range(5)}
{0: 0, 1: 1, 2: 4, 3: 9, 4: 16}
```

### ループでの辞書の扱い

```python
>>> knights = {'gallahad': 'the pure', 'robin': 'the brave'}
>>> for k, v in knights.items():
...     print(k, v)
gallahad the pure
robin the brave
```

> **出典**: [Python Tutorial §5.5. Dictionaries](https://docs.python.org/3/tutorial/datastructures.html#dictionaries)

## 理論: 文字列の詳細

文字列はイミュータブルなシーケンスです。豊富なメソッドがあります。

```python
>>> s = '  Hello, World!  '
>>> s.strip()
'Hello, World!'
>>> s.upper()
'  HELLO, WORLD!  '
>>> 'hello'.replace('l', 'L')
'heLLo'
>>> 'a,b,c'.split(',')
['a', 'b', 'c']
>>> '-'.join(['a', 'b', 'c'])
'a-b-c'
```

> **出典**: [PCAP Exam Syllabus - Strings 18%](https://pythoninstitute.org/pcap-exam-syllabus)

## 実践: データ構造を使ったプログラム

### Step 1: 単語カウント

```python
# word_count.py
text = "the quick brown fox jumps over the lazy dog the fox"
words = text.split()
count = {}
for word in words:
    count[word] = count.get(word, 0) + 1
for word, n in count.items():
    print(f"{word}: {n}")
```

### Step 2: リスト内包でデータ処理

```python
# 成績処理
scores = [85, 92, 78, 90, 88]
passed = [s for s in scores if s >= 80]
average = sum(scores) / len(scores)
print(f"合格者: {passed}, 平均: {average:.1f}")
```

## 練習問題

1. 2つのリストから共通要素をセットで求める
2. 辞書を使って学生名と成績を管理し、平均点を計算する
3. リスト内包で1〜20の偶数の二乗のリストを作る

<details>
<summary>解答例</summary>

**1. 共通要素をセットで求める**

```python
list1 = [1, 2, 3, 4, 5]
list2 = [4, 5, 6, 7, 8]
common = set(list1) & set(list2)
print(common)  # {4, 5}
```

**2. 辞書で学生名と成績を管理、平均点を計算**

```python
scores = {"Alice": 85, "Bob": 92, "Carol": 78}
average = sum(scores.values()) / len(scores)
print(f"平均点: {average:.1f}")
```

**3. リスト内包で偶数の二乗**

```python
squares = [x**2 for x in range(1, 21) if x % 2 == 0]
print(squares)  # [4, 16, 36, 64, 100, 144, 196, 256, 324, 400]
```
</details>

## まとめ

- **リスト**: ミュータブル、`append`、スライス、内包表記
- **タプル**: イミュータブル、アンパッキング
- **セット**: 重複なし、順序なし
- **辞書**: キーと値のマッピング、`get()`、`items()`

## 次のステップ

[Phase 4](./phase4-functions-exceptions.md) では、関数定義と例外処理を学びます。
