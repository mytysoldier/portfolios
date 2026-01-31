# Phase 3: 複雑な状態管理

## 学習目標

- ネストしたStateの管理方法を学ぶ
- Reducerの合成方法を理解する
- 親子関係のある機能を実装する
- スコープの概念を理解する

## ネストしたState

アプリケーションが大きくなると、Stateを階層的に構造化する必要があります。

### 例: アプリ全体のState

```swift
struct AppState: Equatable {
    var counter: CounterState
    var todo: TodoState
    var user: UserState
}
```

### ネストしたReducerの合成

各機能のReducerを合成して、アプリ全体のReducerを作成します：

```swift
let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    counterReducer.pullback(
        state: \.counter,
        action: /AppAction.counter,
        environment: { _ in () }
    ),
    todoReducer.pullback(
        state: \.todo,
        action: /AppAction.todo,
        environment: { _ in () }
    )
)
```

## Pullbackの概念

`pullback`は、小さなReducerを大きなReducerに変換する関数です。

### Pullbackの型シグネチャ

```swift
func pullback<GlobalState, GlobalAction, GlobalEnvironment>(
    state toLocalState: WritableKeyPath<GlobalState, LocalState>,
    action toLocalAction: CasePath<GlobalAction, LocalAction>,
    environment toLocalEnvironment: @escaping (GlobalEnvironment) -> LocalEnvironment
) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment>
```

### Pullbackの例

```swift
// ローカルのReducer
let counterReducer = Reducer<CounterState, CounterAction, Void> { ... }

// グローバルのReducerに変換
let appReducer = counterReducer.pullback(
    state: \AppState.counter,           // グローバルStateからローカルStateへのパス
    action: /AppAction.counter,          // グローバルActionからローカルActionへのパス
    environment: { _ in () }            // グローバルEnvironmentからローカルEnvironmentへの変換
)
```

## CasePath

`CasePath`は、列挙型のケースへの型安全なパスです。

### CasePathの使い方

```swift
enum AppAction: Equatable {
    case counter(CounterAction)
    case todo(TodoAction)
}

// CasePathの作成
let counterActionPath = /AppAction.counter

// 使用例
if let counterAction = counterActionPath.extract(from: appAction) {
    // CounterActionを取得
}
```

## 実践例: 複数の機能を組み合わせる

### Step 1: 各機能のStateとActionを定義

```swift
// CounterState.swift
struct CounterState: Equatable {
    var count: Int = 0
}

enum CounterAction: Equatable {
    case increment
    case decrement
}

// TodoState.swift
struct TodoState: Equatable {
    var todos: [Todo] = []
    var newTodoDescription: String = ""
}

enum TodoAction: Equatable {
    case addTodo
    case deleteTodo(IndexSet)
    case toggleTodo(id: UUID)
    case updateNewTodoDescription(String)
}
```

### Step 2: アプリ全体のStateとActionを定義

```swift
// AppState.swift
struct AppState: Equatable {
    var counter: CounterState
    var todo: TodoState
    var selectedTab: Tab = .counter
    
    enum Tab: Equatable {
        case counter
        case todo
    }
}

// AppAction.swift
enum AppAction: Equatable {
    case counter(CounterAction)
    case todo(TodoAction)
    case selectTab(AppState.Tab)
}
```

### Step 3: 各機能のReducerを実装

```swift
// CounterReducer.swift
let counterReducer = Reducer<CounterState, CounterAction, Void> { state, action, _ in
    switch action {
    case .increment:
        state.count += 1
        return .none
    case .decrement:
        state.count -= 1
        return .none
    }
}

// TodoReducer.swift
let todoReducer = Reducer<TodoState, TodoAction, Void> { state, action, _ in
    switch action {
    case .addTodo:
        guard !state.newTodoDescription.isEmpty else {
            return .none
        }
        let newTodo = Todo(description: state.newTodoDescription)
        state.todos.append(newTodo)
        state.newTodoDescription = ""
        return .none
    case .deleteTodo(let indexSet):
        state.todos.remove(atOffsets: indexSet)
        return .none
    case .toggleTodo(let id):
        if let index = state.todos.firstIndex(where: { $0.id == id }) {
            state.todos[index].isComplete.toggle()
        }
        return .none
    case .updateNewTodoDescription(let description):
        state.newTodoDescription = description
        return .none
    }
}
```

### Step 4: アプリ全体のReducerを合成

```swift
// AppReducer.swift
let appReducer = Reducer<AppState, AppAction, Void>.combine(
    counterReducer.pullback(
        state: \.counter,
        action: /AppAction.counter,
        environment: { _ in () }
    ),
    todoReducer.pullback(
        state: \.todo,
        action: /AppAction.todo,
        environment: { _ in () }
    ),
    Reducer<AppState, AppAction, Void> { state, action, _ in
        switch action {
        case .selectTab(let tab):
            state.selectedTab = tab
            return .none
        case .counter, .todo:
            return .none
        }
    }
)
```

### Step 5: Viewの実装

```swift
// AppView.swift
struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            TabView(selection: viewStore.binding(
                get: { $0.selectedTab },
                send: AppAction.selectTab
            )) {
                CounterView(
                    store: self.store.scope(
                        state: { $0.counter },
                        action: AppAction.counter
                    )
                )
                .tabItem {
                    Label("Counter", systemImage: "number")
                }
                .tag(AppState.Tab.counter)
                
                TodoView(
                    store: self.store.scope(
                        state: { $0.todo },
                        action: AppAction.todo
                    )
                )
                .tabItem {
                    Label("Todo", systemImage: "list.bullet")
                }
                .tag(AppState.Tab.todo)
            }
        }
    }
}
```

## Scopeの概念

`scope`は、Storeを部分的にスコープする関数です。子Viewに必要な部分だけを渡すことができます。

### Scopeの型シグネチャ

```swift
func scope<LocalState, LocalAction>(
    state toLocalState: @escaping (State) -> LocalState,
    action fromLocalAction: @escaping (LocalAction) -> Action
) -> Store<LocalState, LocalAction>
```

### Scopeの例

```swift
// グローバルなStore
let appStore = Store(
    initialState: AppState(...),
    reducer: appReducer,
    environment: ()
)

// Counter用にスコープ
let counterStore = appStore.scope(
    state: { $0.counter },
    action: AppAction.counter
)

// Todo用にスコープ
let todoStore = appStore.scope(
    state: { $0.todo },
    action: AppAction.todo
)
```

## より複雑な例: ネストしたTodoリスト

### Step 1: ネストしたStateの定義

```swift
struct TodoListState: Equatable {
    var todos: [TodoItemState] = []
    var newTodoDescription: String = ""
}

struct TodoItemState: Equatable, Identifiable {
    let id: UUID
    var description: String
    var isComplete: Bool
    var subtodos: [TodoItemState] = []
}
```

### Step 2: ネストしたActionの定義

```swift
enum TodoListAction: Equatable {
    case addTodo
    case deleteTodo(IndexSet)
    case todoItem(id: UUID, action: TodoItemAction)
    case updateNewTodoDescription(String)
}

enum TodoItemAction: Equatable {
    case toggleComplete
    case delete
    case addSubtodo
    case updateDescription(String)
}
```

### Step 3: ネストしたReducerの実装

```swift
let todoItemReducer = Reducer<TodoItemState, TodoItemAction, Void> { state, action, _ in
    switch action {
    case .toggleComplete:
        state.isComplete.toggle()
        return .none
    case .delete:
        // 親Reducerで処理
        return .none
    case .addSubtodo:
        let newSubtodo = TodoItemState(description: "新しいサブタスク")
        state.subtodos.append(newSubtodo)
        return .none
    case .updateDescription(let description):
        state.description = description
        return .none
    }
}

let todoListReducer = Reducer<TodoListState, TodoListAction, Void> { state, action, _ in
    switch action {
    case .addTodo:
        guard !state.newTodoDescription.isEmpty else {
            return .none
        }
        let newTodo = TodoItemState(description: state.newTodoDescription)
        state.todos.append(newTodo)
        state.newTodoDescription = ""
        return .none
        
    case .deleteTodo(let indexSet):
        state.todos.remove(atOffsets: indexSet)
        return .none
        
    case .todoItem(let id, let action):
        if let index = state.todos.firstIndex(where: { $0.id == id }) {
            switch action {
            case .delete:
                state.todos.remove(at: index)
            default:
                return todoItemReducer.run(
                    &state.todos[index],
                    action,
                    ()
                )
            }
        }
        return .none
        
    case .updateNewTodoDescription(let description):
        state.newTodoDescription = description
        return .none
    }
}
```

## 練習問題

### 1. カウンターとTodoを組み合わせたアプリ

カウンター機能とTodo機能を持つタブアプリを作成してください。

### 2. ネストしたTodoリスト

サブタスクを持つTodoリストアプリを作成してください。

### 3. 設定画面

アプリの設定を管理する機能を追加し、他の機能と組み合わせてください。

## まとめ

- ネストしたStateは階層的に構造化できる
- `pullback`で小さなReducerを大きなReducerに変換できる
- `scope`でStoreを部分的にスコープできる
- `CasePath`で型安全にActionを処理できる

## 次のステップ

[Phase 4](./phase4-effects.md)では、Effect（副作用）の扱い方を学びます。
