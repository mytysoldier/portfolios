# Phase 5: オブジェクト指向プログラミング

## 学習目標

- クラスとインスタンスの概念を理解する
- 継承とポリモーフィズムを扱えるようになる
- プライベート変数と名前のマングリングを理解する
- イテレータとジェネレータの基礎を学ぶ

> **出典**: [Python公式チュートリアル §9. Classes](https://docs.python.org/3/tutorial/classes.html)。PCAP試験の34%がObject-Oriented Programmingに関する出題です。

## 理論: クラスとインスタンス

### クラス定義

```python
class Dog:
    """犬を表すクラス"""

    def __init__(self, name, age):
        """コンストラクタ（初期化）"""
        self.name = name   # インスタンス変数
        self.age = age

    def bark(self):
        """インスタンスメソッド"""
        return f"{self.name} says: Woof!"

# インスタンス化
my_dog = Dog("Buddy", 3)
print(my_dog.bark())  # Buddy says: Woof!
```

- `__init__`: コンストラクタ。インスタンス作成時に自動で呼ばれる
- `self`: インスタンス自身を参照する（慣例的に `self` を使用）
- インスタンス変数: `self.変数名` で定義

> **出典**: [Python Tutorial §9.3. A First Look at Classes](https://docs.python.org/3/tutorial/classes.html#a-first-look-at-classes)

### クラス変数とインスタンス変数

```python
class Dog:
    species = "Canis familiaris"  # クラス変数（全インスタンスで共有）

    def __init__(self, name):
        self.name = name  # インスタンス変数

print(Dog.species)        # Canis familiaris
my_dog = Dog("Buddy")
print(my_dog.species)    # Canis familiaris
print(my_dog.name)       # Buddy
```

> **出典**: [Python Tutorial §9.3.5. Class and Instance Variables](https://docs.python.org/3/tutorial/classes.html#class-and-instance-variables)

## 理論: 継承

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        raise NotImplementedError("サブクラスで実装してください")

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof!"

class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow!"

dog = Dog("Buddy")
cat = Cat("Whiskers")
print(dog.speak())  # Buddy says Woof!
print(cat.speak())  # Whiskers says Meow!
```

### super() による親クラスの呼び出し

```python
class Dog(Animal):
    def __init__(self, name, breed):
        super().__init__(name)   # 親の __init__ を呼ぶ
        self.breed = breed
```

### 多重継承

Pythonは多重継承をサポートします。メソッド解決順序（MRO）に従います。

```python
class A:
    def method(self):
        print("A")

class B(A):
    def method(self):
        print("B")
        super().method()

class C(A):
    def method(self):
        print("C")
        super().method()

class D(B, C):
    pass

d = D()
d.method()  # B, C, A の順で呼ばれる
```

> **出典**: [Python Tutorial §9.5. Inheritance](https://docs.python.org/3/tutorial/classes.html#inheritance)

## 理論: プライベート変数

Pythonには真のプライベートはありませんが、`_` で始める名前は「内部用」の慣例があります。
`__`（ダブルアンダースコア）で始めると**名前マングリング**が適用されます。

```python
class MyClass:
    def __init__(self):
        self._single = "internal"      # 慣例上のプライベート
        self.__double = "mangled"      # 名前マングリング

    def get_double(self):
        return self.__double

obj = MyClass()
# obj.__double  # AttributeError
print(obj._MyClass__double)  # マングリング後の名前でアクセス可能（非推奨）
```

> **出典**: [Python Tutorial §9.6. Private Variables](https://docs.python.org/3/tutorial/classes.html#private-variables)

## 理論: 特殊メソッド（マジックメソッド）

`__xxx__` の形式のメソッドで、演算子や組み込み関数の動作をカスタマイズします。

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):           # str() で呼ばれる
        return f"Point({self.x}, {self.y})"

    def __repr__(self):          # repr() で呼ばれる
        return f"Point({self.x}, {self.y})"

    def __add__(self, other):    # + 演算子
        return Point(self.x + other.x, self.y + other.y)

    def __len__(self):           # len() で呼ばれる（この例では不適切だが例として）
        return 2
```

> **出典**: [Python Data Model](https://docs.python.org/3/reference/datamodel.html)

## 理論: イテレータとジェネレータ

### イテレータ

`__iter__` と `__next__` を実装したオブジェクトです。

```python
class CountDown:
    def __init__(self, start):
        self.current = start

    def __iter__(self):
        return self

    def __next__(self):
        if self.current <= 0:
            raise StopIteration
        self.current -= 1
        return self.current + 1

for num in CountDown(3):
    print(num)  # 3, 2, 1
```

### ジェネレータ

`yield` を使うと、より簡潔にイテレータを定義できます。PCAP試験の出題範囲です。

```python
def countdown(n):
    while n > 0:
        yield n
        n -= 1

for num in countdown(3):
    print(num)  # 3, 2, 1

# ジェネレータ式
squares = (x**2 for x in range(5))
```

> **出典**: [Python Tutorial §9.8. Iterators](https://docs.python.org/3/tutorial/classes.html#iterators)、[§9.9. Generators](https://docs.python.org/3/tutorial/classes.html#generators)

## 実践: OOPを使ったプログラム

### Step 1: 銀行口座クラス

```python
# bank_account.py
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        if amount > 0:
            self.balance += amount
            return True
        return False

    def withdraw(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            return True
        return False

    def __str__(self):
        return f"{self.owner}'s account: balance ${self.balance}"

acc = BankAccount("Alice", 1000)
acc.deposit(500)
acc.withdraw(200)
print(acc)  # Alice's account: balance $1300
```

### Step 2: 継承の例 - 貯蓄口座

```python
class SavingsAccount(BankAccount):
    def __init__(self, owner, balance=0, interest_rate=0.01):
        super().__init__(owner, balance)
        self.interest_rate = interest_rate

    def add_interest(self):
        interest = self.balance * self.interest_rate
        self.balance += interest
        return interest
```

## 練習問題

1. `Rectangle` クラスを定義し、`area()` と `perimeter()` メソッドを実装する
2. `Shape` 基底クラスと、`Circle`、`Rectangle` サブクラスでポリモーフィズムを実装する
3. ジェネレータでフィボナッチ数列を無限に生成する

<details>
<summary>解答例</summary>

**1. Rectangle クラス**

```python
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def perimeter(self):
        return 2 * (self.width + self.height)

r = Rectangle(3, 4)
print(r.area())       # 12
print(r.perimeter())  # 14
```

**2. Shape とポリモーフィズム**

```python
class Shape:
    def area(self):
        raise NotImplementedError

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14159 * self.radius ** 2

class Rectangle(Shape):
    def __init__(self, w, h):
        self.width, self.height = w, h

    def area(self):
        return self.width * self.height

shapes = [Circle(2), Rectangle(3, 4)]
for s in shapes:
    print(s.area())
```

**3. フィボナッチジェネレータ**

```python
def fib():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# 最初の10個を取得
for i, n in enumerate(fib()):
    if i >= 10:
        break
    print(n, end=" ")
```
</details>

## まとめ

- クラス: `class`、`__init__`、`self`、インスタンス変数
- 継承: サブクラス、`super()`
- プライベート: `_`、`__`（名前マングリング）
- イテレータ/ジェネレータ: `__iter__`、`__next__`、`yield`

## 次のステップ

[Phase 6](./phase6-practical-program.md) では、モジュールとパッケージ、ファイルI/Oを含む実践的なプログラムを構築します。
