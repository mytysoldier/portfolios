import Foundation
import SwiftData

@MainActor
final class ResultViewModel: ObservableObject {
    let analysisResult: AnalysisResult

    init(analysisResult: AnalysisResult) {
        self.analysisResult = analysisResult
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
    }
}
