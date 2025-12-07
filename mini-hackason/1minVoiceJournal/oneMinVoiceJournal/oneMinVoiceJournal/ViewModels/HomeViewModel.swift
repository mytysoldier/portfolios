import Foundation
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var analysisResult: AnalysisResult?
    @Published var navigateToResult = false
    @Published var isProcessing = false
    @Published var processingMessage: String?
    @Published var analysisError: String?

    func updateDraft(with result: AnalysisResult) {
        analysisResult = result
        navigateToResult = true
    }

    func reset() {
        analysisResult = nil
        navigateToResult = false
        isProcessing = false
        processingMessage = nil
        analysisError = nil
    }

    func processRecording(at url: URL) async {
        isProcessing = true
        processingMessage = "音声を文字起こし中..."
        analysisError = nil

        do {
            let service = try OpenAIService()
            let transcript = try await service.transcribeAudio(at: url)
            processingMessage = "感情分析中..."
            let analysis = try await service.analyzeEmotion(from: transcript)
            let result = AnalysisResult(
                audioURL: url,
                text: transcript,
                emotion: analysis.emotion,
                title: analysis.title,
                summary: analysis.summary,
                advice: analysis.advice
            )
            updateDraft(with: result)
        } catch {
            analysisError = error.localizedDescription
        }

        isProcessing = false
        processingMessage = nil
    }
}
