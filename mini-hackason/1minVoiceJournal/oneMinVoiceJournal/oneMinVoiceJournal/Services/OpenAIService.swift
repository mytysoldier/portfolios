import Foundation

struct OpenAIService {
    enum ServiceError: Error, LocalizedError {
        case missingBaseURL
        case invalidBaseURL
        case invalidResponse
        case decodingFailed
        case requestFailed(statusCode: Int)

        var errorDescription: String? {
            switch self {
            case .missingBaseURL:
                return "解析サーバーのURLが設定されていません。"
            case .invalidBaseURL:
                return "解析サーバーのURLが不正です。"
            case .invalidResponse:
                return "解析サーバーから想定外のレスポンスが返されました。"
            case .decodingFailed:
                return "解析結果の読み取りに失敗しました。"
            case .requestFailed(let statusCode):
                return "解析サーバーの呼び出しに失敗しました (status: \(statusCode))。"
            }
        }
    }

    private let baseURL: URL
    private let appKey: String?
    private let anonKey: String?
    private let session: URLSession

    init(
        baseURLString: String? = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
        appKey: String? = Bundle.main.object(forInfoDictionaryKey: "APP_CLIENT_KEY") as? String,
        anonKey: String? = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
        session: URLSession = .shared
    ) throws {
        #if DEBUG
        debugPrint("API_BASE_URL (raw):", baseURLString ?? "nil")
        #endif
        guard let baseURLString, !baseURLString.isEmpty else {
            throw ServiceError.missingBaseURL
        }
        let trimmedBaseURLString = baseURLString.trimmingCharacters(in: .whitespacesAndNewlines)
        #if DEBUG
        debugPrint("API_BASE_URL (trimmed):", trimmedBaseURLString)
        #endif
        guard let baseURL = URL(string: trimmedBaseURLString) else {
            throw ServiceError.invalidBaseURL
        }
        self.baseURL = baseURL
        self.appKey = appKey?.isEmpty == false ? appKey : nil
        self.anonKey = anonKey?.isEmpty == false ? anonKey : nil
        self.session = session
    }

    func transcribeAudio(at url: URL, model: String = "whisper-1", temperature: Double = 0) async throws -> String {
        var request = makeRequest(url: baseURL.appendingPathComponent("oneMinVoiceJournalTranscribe"))
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = try buildMultipartBody(boundary: boundary, fileURL: url, model: model, temperature: temperature)
        let (data, response) = try await session.upload(for: request, from: body)
        try handleResponse(response, data: data)
        #if DEBUG
        if let bodyString = String(data: data, encoding: .utf8) {
            debugPrint("Whisper response:", bodyString)
        }
        #endif

        struct WhisperResponse: Decodable { let text: String }
        struct TranscriptResponse: Decodable { let transcript: String }

        if let whisper = try? JSONDecoder().decode(WhisperResponse.self, from: data) {
            return whisper.text
        }
        if let transcript = try? JSONDecoder().decode(TranscriptResponse.self, from: data) {
            return transcript.transcript
        }
        throw ServiceError.decodingFailed
    }

    func analyzeEmotion(from transcript: String) async throws -> AnalysisPayload {
        var request = makeRequest(url: baseURL.appendingPathComponent("oneMinVoiceJournalAnalyze"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = AnalyzeRequest(transcript: transcript)
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await session.data(for: request)
        try handleResponse(response, data: data)
        #if DEBUG
        if let bodyString = String(data: data, encoding: .utf8) {
            debugPrint("Chat completion response:", bodyString)
        }
        #endif

        let decoder = JSONDecoder()
        if let response = try? decoder.decode(AnalyzeResponse.self, from: data) {
            return response.analysis
        }
        if let analysis = try? decoder.decode(AnalysisPayload.self, from: data) {
            return analysis
        }
        if let rawString = String(data: data, encoding: .utf8) {
            let jsonData = try sanitizeJSONString(rawString)
            if let analysis = try? decodeAnalysis(from: jsonData) {
                return analysis
            }
        }
        throw ServiceError.decodingFailed
    }
}

extension OpenAIService {
    struct AnalysisPayload: Codable {
        let emotion: String
        let title: String
        let summary: String
        let advice: String
    }
}

private extension OpenAIService {
    func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        if let anonKey {
            request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
            request.setValue(anonKey, forHTTPHeaderField: "apikey")
        }
        if let appKey {
            request.setValue(appKey, forHTTPHeaderField: "X-App-Key")
        }
        return request
    }

    struct AnalyzeRequest: Encodable {
        let transcript: String
    }

    struct AnalyzeResponse: Decodable {
        let analysis: AnalysisPayload
    }

    func buildMultipartBody(boundary: String, fileURL: URL, model: String, temperature: Double) throws -> Data {
        var data = Data()
        func append(_ string: String) {
            if let d = string.data(using: .utf8) {
                data.append(d)
            }
        }

        let fileData = try Data(contentsOf: fileURL)
        let filename = fileURL.lastPathComponent
        let mimetype = "audio/m4a"

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        append("Content-Type: \(mimetype)\r\n\r\n")
        data.append(fileData)
        append("\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        append("\(model)\r\n")

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"temperature\"\r\n\r\n")
        append("\(temperature)\r\n")

        append("--\(boundary)--\r\n")
        return data
    }

    func handleResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            #if DEBUG
            if let bodyString = String(data: data, encoding: .utf8) {
                debugPrint("OpenAI error response (\(httpResponse.statusCode)): \(bodyString)")
            }
            #endif
            throw ServiceError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }

    func sanitizeJSONString(_ string: String) throws -> Data {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if let start = trimmed.firstIndex(of: "{"), let end = trimmed.lastIndex(of: "}") {
            let jsonSubstring = trimmed[start...end]
            if let data = String(jsonSubstring).data(using: .utf8) {
                return data
            }
        }
        if let data = trimmed.data(using: .utf8) {
            return data
        }
        throw ServiceError.decodingFailed
    }

    func decodeAnalysis(from data: Data) throws -> AnalysisPayload {
        if let payload = try? JSONDecoder().decode(AnalysisPayload.self, from: data) {
            return payload
        }

        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            throw ServiceError.decodingFailed
        }

        func value(for keys: [String]) -> String? {
            for key in keys {
                if let value = jsonObject[key] as? String {
                    return value
                }
            }
            return nil
        }

        guard
            let emotion = value(for: ["emotion", "感情カテゴリー"]),
            let title = value(for: ["title", "タイトル"]),
            let summary = value(for: ["summary", "要約"]),
            let advice = value(for: ["advice", "アドバイス"])
        else {
            throw ServiceError.decodingFailed
        }

        guard let translation = try? translateFromJapanese(jsonObject) else {
            throw ServiceError.decodingFailed
        }
        return translation
    }

    func translateFromJapanese(_ json: [String: Any]) throws -> AnalysisPayload {
        guard
            let emotion = (json["emotion"] as? String) ?? (json["感情カテゴリー"] as? String),
            let title = (json["title"] as? String) ?? (json["タイトル"] as? String),
            let summary = (json["summary"] as? String) ?? (json["要約"] as? String),
            let advice = (json["advice"] as? String) ?? (json["アドバイス"] as? String)
        else {
            throw ServiceError.decodingFailed
        }

        return AnalysisPayload(
            emotion: emotion,
            title: title,
            summary: summary,
            advice: advice
        )
    }
}
