# Phase 5: テスト

## 学習目標

- TCAのテストの考え方を理解する
- Reducerのテストを書く
- Effectのテストを書く
- 統合テストを実装する

## TCAのテストの利点

TCAはテストしやすいように設計されています：

1. **純粋関数**: Reducerは純粋関数なので、テストが簡単
2. **分離**: ビジネスロジックがViewから分離されている
3. **予測可能性**: 同じ入力に対して常に同じ出力

## 基本的なReducerのテスト

### Step 1: テストのセットアップ

```swift
import XCTest
import ComposableArchitecture
@testable import YourApp

class CounterReducerTests: XCTestCase {
    func testIncrement() {
        let store = TestStore(
            initialState: CounterState(count: 0),
            reducer: counterReducer,
            environment: ()
        )
        
        store.send(.increment) {
            $0.count = 1
        }
    }
}
```

### Step 2: 複数のActionのテスト

```swift
func testMultipleActions() {
    let store = TestStore(
        initialState: CounterState(count: 0),
        reducer: counterReducer,
        environment: ()
    )
    
    store.send(.increment) {
        $0.count = 1
    }
    
    store.send(.increment) {
        $0.count = 2
    }
    
    store.send(.decrement) {
        $0.count = 1
    }
    
    store.send(.reset) {
        $0.count = 0
    }
}
```

## Effectを含むReducerのテスト

### Step 1: Mock Environmentの作成

```swift
// TodoEnvironment.swift
struct TodoEnvironment {
    var apiClient: APIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension TodoEnvironment {
    static let test = TodoEnvironment(
        apiClient: APIClient(
            fetchTodos: {
                [
                    Todo(description: "Test Todo 1"),
                    Todo(description: "Test Todo 2")
                ]
            },
            saveTodo: { _ in },
            deleteTodo: { _ in }
        ),
        mainQueue: .immediate
    )
}
```

### Step 2: Effectのテスト

```swift
class TodoReducerTests: XCTestCase {
    func testLoadTodos() {
        let store = TestStore(
            initialState: TodoState(),
            reducer: todoReducer,
            environment: .test
        )
        
        store.send(.onAppear) {
            $0.isLoading = true
        }
        
        store.receive(.todosLoaded([Todo(description: "Test Todo 1"), Todo(description: "Test Todo 2")])) {
            $0.todos = [Todo(description: "Test Todo 1"), Todo(description: "Test Todo 2")]
            $0.isLoading = false
        }
    }
}
```

### Step 3: エラーハンドリングのテスト

```swift
func testLoadTodosFailure() {
    let errorMessage = "Network error"
    let store = TestStore(
        initialState: TodoState(),
        reducer: todoReducer,
        environment: TodoEnvironment(
            apiClient: APIClient(
                fetchTodos: {
                    throw NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                },
                saveTodo: { _ in },
                deleteTodo: { _ in }
            ),
            mainQueue: .immediate
        )
    )
    
    store.send(.onAppear) {
        $0.isLoading = true
    }
    
    store.receive(.todoLoadFailed(errorMessage)) {
        $0.errorMessage = errorMessage
        $0.isLoading = false
    }
}
```

## 非同期Effectのテスト

### タイマーのテスト

```swift
class TimerReducerTests: XCTestCase {
    func testTimer() {
        let scheduler = TestScheduler()
        let store = TestStore(
            initialState: TimerState(),
            reducer: timerReducer,
            environment: TimerEnvironment(
                timer: AsyncStream { continuation in
                    scheduler.schedule(after: scheduler.now.advanced(by: .seconds(1))) {
                        continuation.yield(Date())
                    }
                }
            )
        )
        
        store.send(.start) {
            $0.isRunning = true
        }
        
        scheduler.advance(by: .seconds(1))
        
        store.receive(.tick) {
            $0.count = 1
        }
        
        store.send(.stop) {
            $0.isRunning = false
        }
    }
}
```

## 統合テスト

### 複数のReducerを組み合わせたテスト

```swift
class AppReducerTests: XCTestCase {
    func testAppFlow() {
        let store = TestStore(
            initialState: AppState(
                counter: CounterState(count: 0),
                todo: TodoState()
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                todo: .test,
                counter: ()
            )
        )
        
        // Counterのテスト
        store.send(.counter(.increment)) {
            $0.counter.count = 1
        }
        
        // Todoのテスト
        store.send(.todo(.updateNewTodoDescription("New Todo"))) {
            $0.todo.newTodoDescription = "New Todo"
        }
        
        store.send(.todo(.addTodo)) {
            $0.todo.todos = [Todo(description: "New Todo")]
            $0.todo.newTodoDescription = ""
        }
    }
}
```

## テストのベストプラクティス

### 1. テスト可能な設計

- Environmentで依存関係を注入
- 純粋関数としてReducerを実装
- 副作用をEffectに分離

### 2. テストの構造

```swift
func testFeatureName_ActionName_ExpectedBehavior() {
    // Given: 初期状態を設定
    let store = TestStore(...)
    
    // When: Actionを送信
    store.send(.action) {
        // Then: 期待される状態変更を検証
        $0.property = expectedValue
    }
}
```

### 3. Mockの作成

```swift
extension APIClient {
    static let test = APIClient(
        fetchTodos: { [] },
        saveTodo: { _ in },
        deleteTodo: { _ in }
    )
    
    static func mock(fetchTodos: @escaping () async throws -> [Todo] = { [] }) -> APIClient {
        APIClient(
            fetchTodos: fetchTodos,
            saveTodo: { _ in },
            deleteTodo: { _ in }
        )
    }
}
```

## 実践例: 完全なテストスイート

```swift
class TodoReducerTests: XCTestCase {
    func testAddTodo() {
        let store = TestStore(
            initialState: TodoState(),
            reducer: todoReducer,
            environment: .test
        )
        
        store.send(.updateNewTodoDescription("Buy milk")) {
            $0.newTodoDescription = "Buy milk"
        }
        
        store.send(.addTodo) {
            $0.todos = [Todo(description: "Buy milk")]
            $0.newTodoDescription = ""
        }
    }
    
    func testAddEmptyTodo() {
        let store = TestStore(
            initialState: TodoState(),
            reducer: todoReducer,
            environment: .test
        )
        
        store.send(.addTodo) {
            // 状態は変更されない（空文字のため）
        }
    }
    
    func testDeleteTodo() {
        let todo1 = Todo(description: "Todo 1")
        let todo2 = Todo(description: "Todo 2")
        let store = TestStore(
            initialState: TodoState(todos: [todo1, todo2]),
            reducer: todoReducer,
            environment: .test
        )
        
        store.send(.deleteTodo(IndexSet(integer: 0))) {
            $0.todos = [todo2]
        }
    }
    
    func testToggleTodo() {
        let todo = Todo(description: "Todo", isComplete: false)
        let store = TestStore(
            initialState: TodoState(todos: [todo]),
            reducer: todoReducer,
            environment: .test
        )
        
        store.send(.toggleTodo(id: todo.id)) {
            $0.todos[0].isComplete = true
        }
    }
    
    func testLoadTodos() async {
        let todos = [
            Todo(description: "Todo 1"),
            Todo(description: "Todo 2")
        ]
        let store = TestStore(
            initialState: TodoState(),
            reducer: todoReducer,
            environment: TodoEnvironment(
                apiClient: APIClient(
                    fetchTodos: { todos },
                    saveTodo: { _ in },
                    deleteTodo: { _ in }
                ),
                mainQueue: .immediate
            )
        )
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(.todosLoaded(todos)) {
            $0.todos = todos
            $0.isLoading = false
        }
    }
}
```

## 練習問題

### 1. カウンターReducerのテスト

カウンターReducerのすべてのActionをテストしてください。

### 2. API呼び出しのテスト

成功と失敗の両方のケースをテストしてください。

### 3. 統合テスト

複数の機能を組み合わせた統合テストを書いてください。

## まとめ

- TCAはテストしやすい設計になっている
- `TestStore`を使ってReducerをテストできる
- Mock Environmentで依存関係を制御できる
- Effectもテスト可能

## 次のステップ

[Phase 6](./phase6-practical-app.md)では、実践的なアプリケーションを構築します。
