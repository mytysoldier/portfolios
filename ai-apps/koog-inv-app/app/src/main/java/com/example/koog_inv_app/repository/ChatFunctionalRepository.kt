package com.example.koog_inv_app.repository

import ai.koog.agents.core.agent.AIAgent
import ai.koog.agents.core.agent.functionalStrategy
import ai.koog.agents.core.dsl.extension.asAssistantMessage
import ai.koog.agents.core.dsl.extension.containsToolCalls
import ai.koog.agents.core.dsl.extension.executeMultipleTools
import ai.koog.agents.core.dsl.extension.extractToolCalls
import ai.koog.agents.core.dsl.extension.requestLLM
import ai.koog.agents.core.dsl.extension.requestLLMMultiple
import ai.koog.agents.core.dsl.extension.sendMultipleToolResults
import ai.koog.agents.core.tools.ToolRegistry
import ai.koog.agents.core.tools.reflect.tools
import ai.koog.prompt.executor.clients.google.GoogleModels
import ai.koog.prompt.executor.llms.all.simpleGoogleAIExecutor
import com.example.koog_inv_app.BuildConfig
import com.example.koog_inv_app.tools.MathTools

class ChatFunctionalRepository {
    // Functional agent
    val mathAgent = AIAgent<String, String>(
        systemPrompt = "あなたは優秀な数学の先生です。",
        promptExecutor = simpleGoogleAIExecutor(BuildConfig.GEMINI_API_KEY),
        llmModel = GoogleModels.Gemini2_5Flash,
        strategy = functionalStrategy { input ->
            val draft = requestLLM("Draft: $input")
            val improved = requestLLM("Improve and clarify: $draft")
            val resonse = requestLLM("Format the result as bold: $improved")
            resonse.asAssistantMessage().content
        }
    )

    val toolRegistry = ToolRegistry {
        tools(MathTools())
    }

    val mathAgentWithTools = AIAgent<String, String>(
        systemPrompt = "あなたは優秀な数学の専門家です。ユーザーの問題を解決し、その過程を自己評価して、最高の回答を提供します。",
        promptExecutor = simpleGoogleAIExecutor(BuildConfig.GEMINI_API_KEY),
        llmModel = GoogleModels.Gemini2_5Flash,
//        toolRegistry = toolRegistry,
        strategy = functionalStrategy { input ->
            // ステップ１：最初の回答を生成
            val initialAnswer = requestLLM("数学の問題を解いてください：$input").asAssistantMessage().content

            // ステップ２：批判的検討を行う
            val criticalEvaluation = requestLLM("""
                以下の回答を批判的に検討してください：

                【問題】$input
                【回答】$initialAnswer

                以下の観点で評価してください：
                1. 計算の正確性
                2. 解法の適切性
                3. 説明の分かりやすさ
                4. 不足している点や改善すべき点

                改善が必要な場合は「要改善：」で始めて具体的な改善点を示し、
                十分な場合は「十分」で始めてください。
            """.trimIndent()).asAssistantMessage().content

            // ステップ３：必要に応じて改善された回答を生成
            if (criticalEvaluation.contains("要改善")) {
                requestLLM("""
                    批判的評価：$criticalEvaluation

                    上記の評価を踏まえ、問題「$input」により正確で詳細な回答を作成してください。
                    計算過程を丁寧に示し、必要に応じて検証も行ってください。
                """.trimIndent()).asAssistantMessage().content
            } else {
                initialAnswer
            }
        }
    )

    suspend fun sendMessage(prompt: String): String {
        return try {
//            mathAgent.run(prompt)
            mathAgentWithTools.run(prompt)
        } catch (e: Exception) {
            "エラーが発生しました: ${e.message}"
        }
    }
}