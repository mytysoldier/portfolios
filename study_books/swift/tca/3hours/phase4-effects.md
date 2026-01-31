# Phase 4: Effect（副作用）の扱い

## 学習目標

- Effectとは何かを理解する
- 非同期処理をEffectで扱う方法を学ぶ
- API呼び出しを実装する
- タイマーとスケジューラーを使う
- Effectの合成とキャンセルを理解する

## Effectとは

Effectは、Reducerから返される値で、副作用（API呼び出し、タイマー、データベースアクセスなど）を表します。

### Effectの種類

1. **即座に実行されるEffect**: `.none`, `.fireAndForget`
2. **非同期Effect**: `.task`, `.run`
3. **PublisherベースのEffect**: `.publisher`
4. **合成Effect**: `.merge`, `.concatenate`

## 基本的なEffect

### .none

副作用がない場合に返すEffect：

```swift
case .increment:
    state.count += 1
    return .none
```

### .fireAndForget

結果を待たずに実行するEffect：

```swift
case .saveData:
    return .fireAndForget {
        // バックグラウンドで実行
        UserDefaults.standard.set(state.data, forKey: "data")
    }
```

## 非同期処理

### .task

Swift 5.5のasync/awaitを使った非同期処理：

```swift
case .loadData:
    return .task {
        let data = try await apiClient.fetchData()
        return .dataLoaded(data)
    }
```

### .run

より柔軟な非同期処理：

```swift
case .loadData:
    return .run { send in
        do {
            let data = try await apiClient.fetchData()
            await send(.dataLoaded(data))
        } catch {
            await send(.dataLoadFailed(error))
        }
    }
```

## 実践例: API呼び出し

### Step 1: API Clientの定義

```swift
// APIClient.swift
struct APIClient {
    var fetchTodos: () async throws -> [Todo]
    var saveTodo: (Todo) async throws -> Void
    var deleteTodo: (UUID) async throws -> Void
}

extension APIClient {
    static let live = APIClient(
        fetchTodos: {
            // 実際のAPI呼び出し
            let url = URL(string: "https://api.example.com/todos")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Todo].self, from: data)
        },
        saveTodo: { todo in
            // 実際のAPI呼び出し
            let url = URL(string: "https://api.example.com/todos")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(todo)
            _ = try await URLSession.shared.data(for: request)
        },
        deleteTodo: { id in
            // 実際のAPI呼び出し
            let url = URL(string: "https://api.example.com/todos/\(id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            _ = try await URLSession.shared.data(for: request)
        }
    )
    
    static let mock = APIClient(
        fetchTodos: {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒待機
            return [
                Todo(description: "Mock Todo 1"),
                Todo(description: "Mock Todo 2")
            ]
        },
        saveTodo: { _ in },
        deleteTodo: { _ in }
    )
}
```

### Step 2: Environmentの定義

```swift
// TodoEnvironment.swift
struct TodoEnvironment {
    var apiClient: APIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension TodoEnvironment {
    static let live = TodoEnvironment(
        apiClient: .live,
        mainQueue: .main
    )
    
    static let mock = TodoEnvironment(
        apiClient: .mock,
        mainQueue: .immediate
    )
}
```

### Step 3: StateとActionの更新

```swift
// TodoState.swift
struct TodoState: Equatable {
    var todos: [Todo] = []
    var isLoading: Bool = false
    var errorMessage: String?
}

// TodoAction.swift
enum TodoAction: Equatable {
    case onAppear
    case todosLoaded([Todo])
    case todoLoadFailed(String)
    case addTodo(Todo)
    case deleteTodo(UUID)
    case todoSaved
    case todoSaveFailed(String)
}
```

### Step 4: Reducerの実装

```swift
// TodoReducer.swift
let todoReducer = Reducer<TodoState, TodoAction, TodoEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        state.errorMessage = nil
        return .task {
            do {
                let todos = try await environment.apiClient.fetchTodos()
                return .todosLoaded(todos)
            } catch {
                return .todoLoadFailed(error.localizedDescription)
            }
        }
        
    case .todosLoaded(let todos):
        state.todos = todos
        state.isLoading = false
        return .none
        
    case .todoLoadFailed(let message):
        state.errorMessage = message
        state.isLoading = false
        return .none
        
    case .addTodo(let todo):
        return .task {
            do {
                try await environment.apiClient.saveTodo(todo)
                return .todoSaved
            } catch {
                return .todoSaveFailed(error.localizedDescription)
            }
        }
        
    case .todoSaved:
        // 成功時は再読み込み
        return .task {
            do {
                let todos = try await environment.apiClient.fetchTodos()
                return .todosLoaded(todos)
            } catch {
                return .todoLoadFailed(error.localizedDescription)
            }
        }
        
    case .todoSaveFailed(let message):
        state.errorMessage = message
        return .none
        
    case .deleteTodo(let id):
        return .task {
            do {
                try await environment.apiClient.deleteTodo(id)
                return .todoSaved
            } catch {
                return .todoSaveFailed(error.localizedDescription)
            }
        }
    }
}
```

### Step 5: Viewの更新

```swift
// TodoView.swift
struct TodoView: View {
    let store: Store<TodoState, TodoAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewStore.todos) { todo in
                            Text(todo.description)
                        }
                        .onDelete { indexSet in
                            let ids = indexSet.map { viewStore.todos[$0].id }
                            for id in ids {
                                viewStore.send(.deleteTodo(id))
                            }
                        }
                    }
                }
            }
            .alert(
                item: viewStore.binding(
                    get: { $0.errorMessage.map(ErrorAlert.init) },
                    send: { _ in .todoLoadFailed("") }
                )
            ) { alert in
                Alert(title: Text("エラー"), message: Text(alert.message))
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct ErrorAlert: Identifiable {
    let id = UUID()
    let message: String
}
```

## タイマーとスケジューラー

### タイマーの実装

```swift
// TimerState.swift
struct TimerState: Equatable {
    var count: Int = 0
    var isRunning: Bool = false
}

enum TimerAction: Equatable {
    case start
    case stop
    case tick
}

// TimerReducer.swift
let timerReducer = Reducer<TimerState, TimerAction, TimerEnvironment> { state, action, environment in
    switch action {
    case .start:
        state.isRunning = true
        return .run { send in
            for await _ in environment.timer {
                await send(.tick)
            }
        }
        .cancellable(id: TimerID())
        
    case .stop:
        state.isRunning = false
        return .cancel(id: TimerID())
        
    case .tick:
        state.count += 1
        return .none
    }
}

struct TimerID: Hashable {}

// TimerEnvironment.swift
struct TimerEnvironment {
    var timer: AsyncStream<Date>
}

extension TimerEnvironment {
    static let live = TimerEnvironment(
        timer: AsyncStream { continuation in
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                continuation.yield(Date())
            }
            continuation.onTermination = { _ in
                timer.invalidate()
            }
        }
    )
}
```

## Effectの合成

### .merge

複数のEffectを同時に実行：

```swift
case .loadMultipleData:
    return .merge(
        .task {
            let users = try await apiClient.fetchUsers()
            return .usersLoaded(users)
        },
        .task {
            let posts = try await apiClient.fetchPosts()
            return .postsLoaded(posts)
        }
    )
```

### .concatenate

複数のEffectを順番に実行：

```swift
case .sequentialOperations:
    return .concatenate(
        .task {
            try await apiClient.saveData()
            return .dataSaved
        },
        .task {
            let data = try await apiClient.fetchData()
            return .dataLoaded(data)
        }
    )
```

## Effectのキャンセル

### キャンセル可能なEffect

```swift
case .startPolling:
    return .run { send in
        for await _ in environment.timer {
            await send(.poll)
        }
    }
    .cancellable(id: PollingID())
    
case .stopPolling:
    return .cancel(id: PollingID())
```

### 自動キャンセル

Viewが消えたときに自動的にキャンセル：

```swift
case .onAppear:
    return .task {
        // 処理
    }
    .cancellable(id: TaskID(), cancelInFlight: true)
```

## 練習問題

### 1. 検索機能

検索クエリを入力すると、APIを呼び出して結果を表示する機能を実装してください。

**ヒント**:
- デバウンス（入力が止まってから検索）を実装
- キャンセル可能なEffectを使う

### 2. リアルタイム更新

定期的にAPIを呼び出してデータを更新する機能を実装してください。

**ヒント**:
- タイマーを使う
- バックグラウンドに移行したら停止

### 3. リトライ機能

API呼び出しが失敗した場合、自動的にリトライする機能を実装してください。

**ヒント**:
- Effectの合成を使う
- 最大リトライ回数を設定

## まとめ

- Effectは副作用を表す
- `.task`と`.run`で非同期処理を実装できる
- Environmentで依存関係を注入できる
- Effectは合成やキャンセルが可能

## 次のステップ

[Phase 5](./phase5-testing.md)では、TCAを使ったテストの書き方を学びます。
