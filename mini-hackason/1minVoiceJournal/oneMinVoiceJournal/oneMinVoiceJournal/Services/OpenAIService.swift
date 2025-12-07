import Foundation

struct OpenAIService {
    enum ServiceError: Error, LocalizedError {
        case missingAPIKey
        case invalidResponse
        case decodingFailed
        case requestFailed(statusCode: Int)

        var errorDescription: String? {
            switch self {
            case .missingAPIKey:
                return "一部の解析設定が不足しています。"
            case .invalidResponse:
                return "解析サーバーから想定外のレスポンスが返されました。"
            case .decodingFailed:
                return "解析結果の読み取りに失敗しました。"
            case .requestFailed(let statusCode):
                return "解析サーバーの呼び出しに失敗しました (status: \(statusCode))。"
            }
        }
    }

    private let apiKey: String
    private let session: URLSession

    init(apiKey: String? = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], session: URLSession = .shared) throws {
        guard let apiKey, !apiKey.isEmpty else {
            throw ServiceError.missingAPIKey
        }
        self.apiKey = apiKey
        self.session = session
    }

    func transcribeAudio(at url: URL, model: String = "whisper-1", temperature: Double = 0) async throws -> String {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/audio/transcriptions")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

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
        guard let whisper = try? JSONDecoder().decode(WhisperResponse.self, from: data) else {
            throw ServiceError.decodingFailed
        }
        return whisper.text
    }

    func analyzeEmotion(from transcript: String, model: String = "gpt-4o-mini") async throws -> AnalysisPayload {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let systemPrompt = """
        あなたは感情分析AIです。以下のユーザーの音声テキストを読み、感情カテゴリー・タイトル・要約・アドバイスを JSON 形式で出力してください。
        感情カテゴリーは次のいずれかです：Happy, Calm, Neutral, Sad, Angry, Hurt, Overwhelmed
        """

        let userPrompt = transcript

        let payload = ChatRequest(
            model: model,
            messages: [
                .init(role: "system", content: systemPrompt),
                .init(role: "user", content: userPrompt)
            ],
            responseFormat: .jsonObject
        )

        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await session.data(for: request)
        try handleResponse(response, data: data)
        #if DEBUG
        if let bodyString = String(data: data, encoding: .utf8) {
            debugPrint("Chat completion response:", bodyString)
        }
        #endif

        let completion = try JSONDecoder().decode(ChatResponse.self, from: data)
        guard let contentString = completion.choices.first?.message.content else {
            throw ServiceError.invalidResponse
        }
        #if DEBUG
        debugPrint("OpenAI response:", contentString)
        #endif

        let jsonData = try sanitizeJSONString(contentString)
        do {
            return try decodeAnalysis(from: jsonData)
        } catch {
            #if DEBUG
            debugPrint("Failed to decode analysis:", String(data: jsonData, encoding: .utf8) ?? "N/A")
            #endif
            throw ServiceError.decodingFailed
        }
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
    struct ChatRequest: Encodable {
        struct Message: Encodable {
            let role: String
            let content: String
        }

        struct ResponseFormat: Encodable {
            let type: String

            static var jsonObject: ResponseFormat {
                ResponseFormat(type: "json_object")
            }
        }

        let model: String
        let messages: [Message]
        let responseFormat: ResponseFormat

        private enum CodingKeys: String, CodingKey {
            case model, messages
            case responseFormat = "response_format"
        }
    }

    struct ChatResponse: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable {
                let role: String
                let content: String
            }

            let index: Int
            let message: Message
        }

        let choices: [Choice]
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
