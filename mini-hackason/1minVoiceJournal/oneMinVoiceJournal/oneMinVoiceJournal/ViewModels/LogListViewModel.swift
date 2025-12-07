import Foundation
import SwiftData

@MainActor
final class LogListViewModel: ObservableObject {
    @Published private(set) var entries: [JournalEntry] = []
    @Published var fetchError: String?

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadEntries() {
        do {
            let descriptor = FetchDescriptor<JournalEntry>(
                sortBy: [SortDescriptor(\JournalEntry.createdAt, order: .reverse)]
            )
            entries = try modelContext.fetch(descriptor)
        } catch {
            fetchError = error.localizedDescription
        }
    }
}
