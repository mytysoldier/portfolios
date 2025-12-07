import Foundation
import SwiftData

@MainActor
final class DetailViewModel: ObservableObject {
    let entry: JournalEntry
    private let modelContext: ModelContext

    init(entry: JournalEntry, modelContext: ModelContext) {
        self.entry = entry
        self.modelContext = modelContext
    }

    var audioURL: URL? {
        guard let path = entry.audioFilePath else { return nil }
        return URL(fileURLWithPath: path)
    }

    func deleteEntry() throws {
        if let url = audioURL {
            try? FileManager.default.removeItem(at: url)
        }
        modelContext.delete(entry)
        try modelContext.save()
    }
}
