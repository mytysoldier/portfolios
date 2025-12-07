import Foundation
import SwiftData

@MainActor
final class ResultViewModel: ObservableObject {
    let analysisResult: AnalysisResult
    @Published var isLoading: Bool
    @Published var isSaved: Bool = false

    init(analysisResult: AnalysisResult, isLoading: Bool = false) {
        self.analysisResult = analysisResult
        self.isLoading = isLoading
    }

    func saveEntry(in modelContext: ModelContext) throws {
        let entry = JournalEntry(
            createdAt: .now,
            audioFilePath: analysisResult.audioURL.path,
            text: analysisResult.text,
            emotion: analysisResult.emotion,
            title: analysisResult.title,
            summary: analysisResult.summary,
            advice: analysisResult.advice
        )
        modelContext.insert(entry)
        try modelContext.save()
        isSaved = true
    }
}
