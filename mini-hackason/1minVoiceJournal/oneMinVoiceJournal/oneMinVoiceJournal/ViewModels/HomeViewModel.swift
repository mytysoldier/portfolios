import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    enum ProcessingStage {
        case idle
        case transcribing
        case analyzing
    }

    @Published var analysisResult: AnalysisResult?
    @Published var navigateToResult = false
    @Published private(set) var stage: ProcessingStage = .idle
    @Published var analysisError: String?

    private var lastRecordingURL: URL?
    private var retryCount = 0
    private let maxRetryCount = 1

    var isProcessing: Bool {
        stage != .idle
    }

    var processingMessage: String? {
        switch stage {
        case .idle:
            return nil
        case .transcribing:
            return "音声を文字起こし中..."
        case .analyzing:
            return "感情分析中..."
        }
    }

    var canRetry: Bool {
        lastRecordingURL != nil && !isProcessing && retryCount < maxRetryCount
    }

    func updateDraft(with result: AnalysisResult) {
        analysisResult = result
        navigateToResult = true
    }

    func reset() {
        analysisResult = nil
        navigateToResult = false
        stage = .idle
        analysisError = nil
        lastRecordingURL = nil
        retryCount = 0
    }

    func processRecording(at url: URL) async {
        await processRecording(at: url, isRetry: false)
    }

    private func processRecording(at url: URL, isRetry: Bool) async {
        stage = .transcribing
        analysisError = nil
        lastRecordingURL = url
        if !isRetry {
            retryCount = 0
        }

        do {
            let service = try OpenAIService()
            let transcript = try await service.transcribeAudio(at: url)
            stage = .analyzing
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
            analysisError = localizedMessage(for: error)
        }

        stage = .idle
    }

    func retryProcessing() async {
        guard let url = lastRecordingURL, retryCount < maxRetryCount else { return }
        retryCount += 1
        await processRecording(at: url, isRetry: true)
    }

    private func localizedMessage(for error: Error) -> String {
        if let serviceError = error as? OpenAIService.ServiceError {
            return serviceError.localizedDescription
        }
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return "ネットワーク接続を確認してから再試行してください。（\(nsError.localizedDescription)）"
        }
        return error.localizedDescription
    }
}
