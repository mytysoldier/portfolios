import Foundation
import SwiftData

@MainActor
final class LogListViewModel: ObservableObject {
    enum EmotionFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case happy = "Happy"
        case calm = "Calm"
        case neutral = "Neutral"
        case sad = "Sad"
        case angry = "Angry"
        case hurt = "Hurt"
        case overwhelmed = "Overwhelmed"

        var id: String { rawValue }

        var label: String {
            switch self {
            case .all: return "すべて"
            case .happy: return "うれしい"
            case .calm: return "落ち着き"
            case .neutral: return "ふつう"
            case .sad: return "かなしい"
            case .angry: return "いらだち"
            case .hurt: return "傷つき"
            case .overwhelmed: return "圧倒"
        }
        }

        var emotionValue: String? {
            self == .all ? nil : rawValue
        }
    }

    @Published private(set) var entries: [JournalEntry] = []
    @Published var fetchError: String?
    @Published var searchText: String = ""
    @Published var selectedFilter: EmotionFilter = .all {
        didSet { loadEntries() }
    }

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadEntries() {
        do {
            var predicates: [Predicate<JournalEntry>] = []
            if let filterEmotion = selectedFilter.emotionValue {
                predicates.append(#Predicate { $0.emotion == filterEmotion })
            }
            if !searchText.isEmpty {
                let keyword = searchText
                predicates.append(#Predicate {
                    ($0.title.localizedStandardContains(keyword)) ||
                    ($0.summary.localizedStandardContains(keyword)) ||
                    ($0.text.localizedStandardContains(keyword))
                })
            }

            let descriptor = FetchDescriptor<JournalEntry>(
                predicate: predicates.isEmpty ? nil : predicates.reduce(nil) { partial, next in
                    if let partial {
                        return #Predicate { partial.evaluate($0) && next.evaluate($0) }
                    }
                    return next
                },
                sortBy: [SortDescriptor(\JournalEntry.createdAt, order: .reverse)]
            )
            entries = try modelContext.fetch(descriptor)
        } catch {
            fetchError = error.localizedDescription
        }
    }

    func updateSearchText(_ text: String) {
        guard text != searchText else { return }
        searchText = text
        loadEntries()
    }
}
