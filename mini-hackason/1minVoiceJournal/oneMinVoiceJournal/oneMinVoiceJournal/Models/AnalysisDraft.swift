import Foundation

struct AnalysisResult: Identifiable {
    let id = UUID()
    var audioURL: URL
    var text: String
    var emotion: String
    var title: String
    var summary: String
    var advice: String
}

extension AnalysisResult {
    static func mock(url: URL) -> AnalysisResult {
        AnalysisResult(
            audioURL: url,
            text: "今日はとても良い一日でした。",
            emotion: "Happy",
            title: "良い一日",
            summary: "いいことが多かったのでハッピーな気分。",
            advice: "このポジティブな気持ちを他の人とも共有してみましょう。"
        )
    }
}
