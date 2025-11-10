package com.example.koog_inv_app.repository

import ai.koog.agents.core.agent.AIAgent
import ai.koog.prompt.dsl.prompt
import ai.koog.prompt.executor.clients.google.GoogleModels
import ai.koog.prompt.executor.llms.all.simpleGoogleAIExecutor
import com.example.koog_inv_app.BuildConfig

class ChatRepository {
    private val agent = AIAgent(
        promptExecutor = simpleGoogleAIExecutor(BuildConfig.GEMINI_API_KEY),
        systemPrompt = "あなたはプロのシステムエンジニアです。",
        llmModel = GoogleModels.Gemini2_5Flash
    )

    suspend fun sendMessage(prompt: String): String {
        return try {
            agent.run(prompt)
        } catch (e: Exception) {
            "エラーが発生しました: ${e.message}"
        }
    }
}