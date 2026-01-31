# Phase 6: 実践的なアプリケーション構築

## 学習目標

- 複数の機能を組み合わせたアプリケーションを構築する
- ナビゲーションを実装する
- エラーハンドリングを実装する
- パフォーマンスを最適化する
- 実務で使えるパターンを学ぶ

## アプリケーションの概要

このPhaseでは、以下の機能を持つTodoアプリケーションを構築します：

1. Todoリストの表示・追加・削除・編集
2. カテゴリー別のフィルタリング
3. 検索機能
4. データの永続化
5. オフライン対応
6. エラーハンドリング

## プロジェクト構造

```
TodoApp/
├── Models/
│   ├── Todo.swift
│   └── Category.swift
├── Core/
│   ├── AppState.swift
│   ├── AppAction.swift
│   └── AppReducer.swift
├── Features/
│   ├── TodoList/
│   │   ├── TodoListState.swift
│   │   ├── TodoListAction.swift
│   │   ├── TodoListReducer.swift
│   │   └── TodoListView.swift
│   ├── TodoDetail/
│   │   ├── TodoDetailState.swift
│   │   ├── TodoDetailAction.swift
│   │   ├── TodoDetailReducer.swift
│   │   └── TodoDetailView.swift
│   └── Search/
│       ├── SearchState.swift
│       ├── SearchAction.swift
│       ├── SearchReducer.swift
│       └── SearchView.swift
├── Services/
│   ├── APIClient.swift
│   ├── StorageService.swift
│   └── NetworkMonitor.swift
└── Utilities/
    ├── Extensions.swift
    └── Helpers.swift
```

## Step 1: モデルの定義

```swift
// Models/Todo.swift
import Foundation

struct Todo: Equatable, Identifiable, Codable {
    let id: UUID
    var description: String
    var isComplete: Bool
    var category: Category
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        description: String,
        isComplete: Bool = false,
        category: Category = .personal,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.description = description
        self.isComplete = isComplete
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// Models/Category.swift
enum Category: String, Equatable, Codable, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case shopping = "Shopping"
    case other = "Other"
}
```

## Step 2: サービスの実装

```swift
// Services/StorageService.swift
import Foundation

struct StorageService {
    var saveTodos: ([Todo]) throws -> Void
    var loadTodos: () throws -> [Todo]
}

extension StorageService {
    static let live = StorageService(
        saveTodos: { todos in
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        },
        loadTodos: {
            guard let data = UserDefaults.standard.data(forKey: "todos") else {
                return []
            }
            return try JSONDecoder().decode([Todo].self, from: data)
        }
    )
    
    static let test = StorageService(
        saveTodos: { _ in },
        loadTodos: { [] }
    )
}

// Services/NetworkMonitor.swift
import Network
import Combine

class NetworkMonitor: ObservableObject {
    @Published var isConnected = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
```

## Step 3: TodoList機能の実装

```swift
// Features/TodoList/TodoListState.swift
struct TodoListState: Equatable {
    var todos: [Todo] = []
    var filteredTodos: [Todo] = []
    var selectedCategory: Category?
    var searchText: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var isOffline: Bool = false
}

// Features/TodoList/TodoListAction.swift
enum TodoListAction: Equatable {
    case onAppear
    case todosLoaded([Todo])
    case todoLoadFailed(String)
    case addTodo(Todo)
    case deleteTodo(UUID)
    case toggleTodo(UUID)
    case selectCategory(Category?)
    case updateSearchText(String)
    case networkStatusChanged(Bool)
    case dismissError
}

// Features/TodoList/TodoListReducer.swift
let todoListReducer = Reducer<TodoListState, TodoListAction, TodoListEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        return .merge(
            .task {
                let todos = try await environment.storageService.loadTodos()
                return .todosLoaded(todos)
            },
            .run { send in
                for await isConnected in environment.networkMonitor.$isConnected.values {
                    await send(.networkStatusChanged(isConnected))
                }
            }
        )
        
    case .todosLoaded(let todos):
        state.todos = todos
        state.isLoading = false
        return .task {
            state.filteredTodos = filterTodos(state.todos, category: state.selectedCategory, searchText: state.searchText)
            return .none
        }
        
    case .todoLoadFailed(let message):
        state.errorMessage = message
        state.isLoading = false
        return .none
        
    case .addTodo(let todo):
        state.todos.append(todo)
        return .merge(
            .task {
                try environment.storageService.saveTodos(state.todos)
                return .todosLoaded(state.todos)
            },
            .fireAndForget {
                if environment.networkMonitor.isConnected {
                    try? await environment.apiClient.saveTodo(todo)
                }
            }
        )
        
    case .deleteTodo(let id):
        state.todos.removeAll { $0.id == id }
        return .task {
            try environment.storageService.saveTodos(state.todos)
            return .todosLoaded(state.todos)
        }
        
    case .toggleTodo(let id):
        if let index = state.todos.firstIndex(where: { $0.id == id }) {
            state.todos[index].isComplete.toggle()
            state.todos[index].updatedAt = Date()
        }
        return .task {
            try environment.storageService.saveTodos(state.todos)
            return .todosLoaded(state.todos)
        }
        
    case .selectCategory(let category):
        state.selectedCategory = category
        return .none
        
    case .updateSearchText(let text):
        state.searchText = text
        return .none
        
    case .networkStatusChanged(let isConnected):
        state.isOffline = !isConnected
        return .none
        
    case .dismissError:
        state.errorMessage = nil
        return .none
    }
}
.reduce { state, action in
    // フィルタリングの更新
    if case .selectCategory = action, case .updateSearchText = action {
        state.filteredTodos = filterTodos(state.todos, category: state.selectedCategory, searchText: state.searchText)
    }
    return .none
}

private func filterTodos(_ todos: [Todo], category: Category?, searchText: String) -> [Todo] {
    var filtered = todos
    
    if let category = category {
        filtered = filtered.filter { $0.category == category }
    }
    
    if !searchText.isEmpty {
        filtered = filtered.filter { $0.description.localizedCaseInsensitiveContains(searchText) }
    }
    
    return filtered
}
```

## Step 4: ナビゲーションの実装

```swift
// AppState.swift
struct AppState: Equatable {
    var todoList: TodoListState
    var todoDetail: TodoDetailState?
    var search: SearchState?
    
    enum NavigationDestination: Equatable {
        case todoDetail(UUID)
        case search
    }
}

// AppAction.swift
enum AppAction: Equatable {
    case todoList(TodoListAction)
    case todoDetail(TodoDetailAction)
    case search(SearchAction)
    case setNavigation(AppState.NavigationDestination?)
}

// AppReducer.swift
let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    todoListReducer.pullback(
        state: \.todoList,
        action: /AppAction.todoList,
        environment: { $0.todoList }
    ),
    todoDetailReducer.pullback(
        state: \.todoDetail,
        action: /AppAction.todoDetail,
        environment: { $0.todoDetail }
    )
    .optional(),
    Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
        switch action {
        case .setNavigation(let destination):
            switch destination {
            case .todoDetail(let id):
                if let todo = state.todoList.todos.first(where: { $0.id == id }) {
                    state.todoDetail = TodoDetailState(todo: todo)
                }
            case .search:
                state.search = SearchState()
            case .none:
                state.todoDetail = nil
                state.search = nil
            }
            return .none
        case .todoList, .todoDetail, .search:
            return .none
        }
    }
)
```

## Step 5: Viewの実装

```swift
// Features/TodoList/TodoListView.swift
struct TodoListView: View {
    let store: Store<TodoListState, TodoListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    // 検索バー
                    SearchBar(text: viewStore.binding(
                        get: { $0.searchText },
                        send: TodoListAction.updateSearchText
                    ))
                    
                    // カテゴリーフィルター
                    CategoryFilter(
                        selectedCategory: viewStore.binding(
                            get: { $0.selectedCategory },
                            send: TodoListAction.selectCategory
                        )
                    )
                    
                    // Todoリスト
                    if viewStore.isLoading {
                        ProgressView()
                    } else if viewStore.filteredTodos.isEmpty {
                        EmptyStateView()
                    } else {
                        List {
                            ForEach(viewStore.filteredTodos) { todo in
                                TodoRow(todo: todo) {
                                    viewStore.send(.toggleTodo(todo.id))
                                }
                                .onTapGesture {
                                    // ナビゲーション処理
                                }
                            }
                            .onDelete { indexSet in
                                let ids = indexSet.map { viewStore.filteredTodos[$0].id }
                                for id in ids {
                                    viewStore.send(.deleteTodo(id))
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Todoリスト")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("検索") {
                            // 検索画面へ
                        }
                    }
                }
                .alert(
                    item: viewStore.binding(
                        get: { $0.errorMessage.map(ErrorAlert.init) },
                        send: { _ in .dismissError }
                    )
                ) { alert in
                    Alert(
                        title: Text("エラー"),
                        message: Text(alert.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}
```

## パフォーマンス最適化

### 1. メモ化

```swift
struct TodoRow: View {
    let todo: Todo
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isComplete ? "checkmark.square" : "square")
            }
            Text(todo.description)
        }
    }
}
```

### 2. リストの最適化

```swift
List {
    ForEach(viewStore.filteredTodos) { todo in
        TodoRow(todo: todo) {
            viewStore.send(.toggleTodo(todo.id))
        }
        .id(todo.id) // 安定したID
    }
}
```

### 3. Effectの最適化

```swift
case .updateSearchText(let text):
    state.searchText = text
    return .task {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒待機
        return .performSearch(text)
    }
    .cancellable(id: SearchID(), cancelInFlight: true)
```

## エラーハンドリング

```swift
enum AppError: LocalizedError, Equatable {
    case networkError(String)
    case storageError(String)
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "ネットワークエラー: \(message)"
        case .storageError(let message):
            return "ストレージエラー: \(message)"
        case .validationError(let message):
            return "バリデーションエラー: \(message)"
        }
    }
}
```

## 練習問題

### 1. 完全なTodoアプリ

このPhaseで学んだ内容を使って、完全なTodoアプリを実装してください。

### 2. オフライン同期

オフライン時に変更したデータを、オンライン復帰時に同期する機能を実装してください。

### 3. データのエクスポート/インポート

TodoデータをJSON形式でエクスポート/インポートする機能を実装してください。

## まとめ

このPhaseでは、実践的なアプリケーションを構築する方法を学びました。

- 複数の機能を組み合わせる方法
- ナビゲーションの実装
- エラーハンドリング
- パフォーマンス最適化
- オフライン対応

## 次のステップ

3時間版の学習を完了しました！これで、TCAを使った実践的なアプリケーションを構築できるようになりました。

さらに学びたい場合は、以下のリソースを参照してください：

- [TCA公式ドキュメント](https://github.com/pointfreeco/swift-composable-architecture)
- [Point-FreeのTCAシリーズ](https://www.pointfree.co/collections/composable-architecture)
- [TCAのサンプルプロジェクト](https://github.com/pointfreeco/swift-composable-architecture/tree/main/Examples)
