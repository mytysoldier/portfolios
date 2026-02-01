# Phase 1: TCAの理論と基本概念

## 学習目標

- TCAの設計思想と理論的背景を理解する
- 関数型プログラミングの基礎を理解する
- State、Action、Reducerの詳細な役割を理解する
- 一方向データフローの重要性を理解する

## TCAの設計思想

### なぜTCAが生まれたのか？

従来のSwiftUIアプリケーションでは、以下の問題が発生しがちでした：

1. **状態管理の複雑さ**: `@State`、`@Binding`、`@ObservedObject`など、複数の状態管理方法が混在
2. **テストの困難さ**: Viewとビジネスロジックが密結合
3. **再利用性の低さ**: コンポーネント間で状態を共有するのが難しい
4. **デバッグの困難さ**: 状態変更の追跡が困難

TCAは、これらの問題を解決するために設計されました。

### 関数型プログラミングの原則

TCAは関数型プログラミングの原則に基づいています：

#### 1. 純粋関数（Pure Functions）

純粋関数とは、同じ入力に対して常に同じ出力を返し、副作用を持たない関数です。

```swift
// 純粋関数の例
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

// 副作用を持つ関数（純粋関数ではない）
var globalCounter = 0
func incrementGlobal() {
    globalCounter += 1  // 副作用：外部の状態を変更
}
```

Reducerは純粋関数です。同じStateとActionの組み合わせに対して、常に同じ結果を返します。

#### 2. 不変性（Immutability）

TCAでは、Stateは不変（immutable）として扱われます。Stateを変更するのではなく、新しいStateを作成します。

```swift
// TCAのReducer（内部的には可変だが、概念的には不変）
struct CounterReducer: Reducer {
    struct State: Equatable {
        var count: Int = 0
    }
    
    enum Action: Equatable {
        case increment
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .increment:
            state.count += 1  // inoutで参照渡しだが、概念的には新しいStateとして扱う
            return .none
        }
    }
}
```

**ポイント**:
- `inout`キーワードでStateを参照渡しにしているが、概念的には不変として扱う
- TCAが内部的にStateの変更を検知し、新しいStateとして扱う
- これにより、状態変更の追跡とデバッグが容易になる

#### 3. 関数の合成（Function Composition）

小さな関数を組み合わせて、より大きな関数を作成できます。

```swift
// 小さなReducer
struct CounterReducer: Reducer { ... }
struct TodoReducer: Reducer { ... }

// 組み合わせたReducer
struct AppReducer: Reducer {
    var body: some Reducer<AppState, AppAction> {
        Reduce { state, action in
            // アプリ全体のロジック
            return .none
        }
        .ifLet(\.counter, action: /AppAction.counter) {
            CounterReducer()
        }
        .ifLet(\.todo, action: /AppAction.todo) {
            TodoReducer()
        }
    }
}
```

または、`Scope`を使って合成することもできます：

```swift
struct AppReducer: Reducer {
    var body: some Reducer<AppState, AppAction> {
        Scope(state: \.counter, action: /AppAction.counter) {
            CounterReducer()
        }
        Scope(state: \.todo, action: /AppAction.todo) {
            TodoReducer()
        }
    }
}
```

## State、Action、Reducerの詳細

### State（状態）

Stateは、アプリケーションの現在の状態を表す構造体です。

#### Stateの設計原則

1. **完全性**: アプリケーションのすべての状態を含める
2. **正規化**: 重複を避け、単一の真実の源とする
3. **Equatable準拠**: 状態の変更を検知できるようにする

```swift
struct AppState: Equatable {
    var counter: CounterState
    var todos: [Todo]
    var isLoading: Bool
    var errorMessage: String?
}

struct CounterState: Equatable {
    var count: Int
    var step: Int
}
```

#### Stateの階層構造

Stateは階層的に構造化できます：

```swift
struct AppState: Equatable {
    var counter: CounterState
    var user: UserState
    var settings: SettingsState
}
```

### Action（アクション）

Actionは、状態を変更するための意図を表す列挙型です。

#### Actionの設計原則

1. **明確性**: 各Actionは明確な意図を表す
2. **関連データ**: Actionに関連するデータを含める
3. **Equatable準拠**: Actionの比較を可能にする

```swift
enum CounterAction: Equatable {
    case increment
    case decrement
    case reset
    case setStep(Int)  // 関連データを含む
    case loadCount(Result<Int, Error>)  // 非同期処理の結果
}
```

#### Actionの階層構造

Actionも階層的に構造化できます：

```swift
enum AppAction: Equatable {
    case counter(CounterAction)
    case todo(TodoAction)
    case user(UserAction)
}
```

### Reducer（リデューサー）

Reducerは、Actionを受け取り、現在のStateを新しいStateに変換する純粋関数です。

#### Reducerの実装パターン

新しいTCAでは、`struct`で`Reducer`プロトコルに準拠します：

```swift
struct CounterReducer: Reducer {
    struct State: Equatable {
        var count: Int = 0
        var step: Int = 1
        var errorMessage: String?
    }
    
    enum Action: Equatable {
        case increment
        case decrement
        case reset
        case setStep(Int)
        case loadCount(Result<Int, Error>)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .increment:
            state.count += 1
            return .none
            
        case .decrement:
            state.count -= 1
            return .none
            
        case .reset:
            state.count = 0
            return .none
            
        case .setStep(let step):
            state.step = step
            return .none
            
        case .loadCount(let result):
            switch result {
            case .success(let count):
                state.count = count
            case .failure(let error):
                state.errorMessage = error.localizedDescription
            }
            return .none
        }
    }
}
```

**ポイント**:
- `struct CounterReducer: Reducer`でReducerプロトコルに準拠
- `State`と`Action`をReducer内に定義するか、`typealias`で別ファイルの型を参照
- `reduce(into:action:)`メソッドで状態を更新
- `inout`キーワードでStateを参照渡し（効率的に更新可能）
- 戻り値は`Effect<Action>`型

## 一方向データフロー

TCAは一方向データフロー（Unidirectional Data Flow）を採用しています：

```
User Interaction
      ↓
   Action
      ↓
   Reducer
      ↓
   State
      ↓
    View
      ↓
User Interaction (ループ)
```

### 一方向データフローの利点

1. **予測可能性**: 状態変更の流れが明確
2. **デバッグの容易さ**: すべての状態変更を追跡可能
3. **テストの容易さ**: 各ステップを独立してテスト可能
4. **理解の容易さ**: コードの流れが直線的

## StoreとViewStore

### Store

Storeは、StateとReducerを保持し、Actionを処理するオブジェクトです。

```swift
let store = Store(initialState: CounterReducer.State()) {
    CounterReducer()
}
```

または、`StoreOf`を使用：

```swift
let store: StoreOf<CounterReducer> = Store(initialState: CounterReducer.State()) {
    CounterReducer()
}
```

### ViewStore

ViewStoreは、ViewがStoreと対話するためのインターフェースです。

```swift
WithViewStore(self.store, observe: { $0 }) { viewStore in
    // viewStore.send(.action) でActionを送信
    // viewStore.count でStateにアクセス
    Text("Count: \(viewStore.count)")
}
```

**ポイント**:
- `observe`パラメータで、どの部分のStateを観察するかを指定
- `observe: { $0 }`でState全体を観察
- 特定のプロパティのみを観察する場合は`observe: \.count`のように指定可能

## まとめ

- TCAは関数型プログラミングの原則に基づいている
- State、Action、Reducerの3つのコンポーネントで構成される
- 一方向データフローにより、状態管理が予測可能になる
- 純粋関数と不変性により、テストとデバッグが容易になる

## 次のステップ

[Phase 2](./phase2-todo-app.md)では、Todoアプリを実装して、これらの理論を実践的に学びます。
