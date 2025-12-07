import SwiftUI
import SwiftData

struct LogListView: View {
    let modelContext: ModelContext
    @StateObject private var viewModel: LogListViewModel
    @State private var searchText: String = ""

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: LogListViewModel(modelContext: modelContext))
    }

    var body: some View {
        VStack {
            filterPicker
            List(viewModel.entries) { entry in
                NavigationLink {
                    DetailView(entry: entry, modelContext: modelContext)
                } label: {
                    HStack(spacing: 12) {
                        Text(EmotionEmoji.emoji(for: entry.emotion))
                            .font(.largeTitle)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.title.isEmpty ? "タイトル未設定" : entry.title)
                                .font(.headline)
                            Text(entry.summary.isEmpty ? entry.text : entry.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                        Text(entry.createdAt, format: .dateTime.month().day())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText) { newValue in
            viewModel.updateSearchText(newValue)
        }
        .navigationTitle("ログ一覧")
        .overlay {
            if viewModel.entries.isEmpty {
                ContentUnavailableView("保存されたログがまだありません", systemImage: "text.book.closed")
            }
        }
        .onAppear(perform: viewModel.loadEntries)
        .refreshable {
            viewModel.loadEntries()
        }
        .alert("一覧の取得に失敗しました", isPresented: fetchErrorBinding) {
            Button("OK", role: .cancel) { viewModel.fetchError = nil }
        } message: {
            Text(viewModel.fetchError ?? "")
        }
    }

    private var fetchErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.fetchError != nil },
            set: { isPresented in
                if !isPresented { viewModel.fetchError = nil }
            }
        )
    }

    private var filterPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(LogListViewModel.EmotionFilter.allCases) { filter in
                    Button {
                        viewModel.selectedFilter = filter
                    } label: {
                        Text(filter.label)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .foregroundStyle(filter == viewModel.selectedFilter ? Color.accentColor : Color.primary)
                            .background(
                                Capsule()
                                    .fill(filter == viewModel.selectedFilter ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.1))
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: JournalEntry.self, configurations: config)
        let context = ModelContext(container)
        JournalEntry.SampleData.entries.forEach { context.insert($0) }
        return NavigationStack {
            LogListView(modelContext: context)
        }
        .modelContainer(container)
    } catch {
        fatalError("プレビュー用ModelContainer作成に失敗: \(error.localizedDescription)")
    }
}
