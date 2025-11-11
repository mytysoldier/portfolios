package com.example.koog_inv_app.repository

import ai.koog.agents.core.agent.AIAgent
import ai.koog.agents.core.agent.AIAgentFunctionalStrategy
import ai.koog.agents.core.agent.FunctionalAIAgent
import ai.koog.agents.core.agent.config.AIAgentConfig
import ai.koog.agents.core.agent.config.MissingToolsConversionStrategy
import ai.koog.agents.core.agent.config.ToolCallDescriber
import ai.koog.agents.core.tools.ToolRegistry
import ai.koog.agents.ext.tool.SayToUser
import ai.koog.agents.features.eventHandler.feature.handleEvents
import ai.koog.prompt.dsl.Prompt
import ai.koog.prompt.dsl.prompt
import ai.koog.prompt.executor.clients.google.GoogleModels
import ai.koog.prompt.executor.llms.all.simpleGoogleAIExecutor
import com.example.koog_inv_app.BuildConfig
import kotlinx.datetime.LocalDateTime
import kotlinx.datetime.LocalTime

class ChatRepository {
    // Single-run agent
    private val agent = AIAgent(
        promptExecutor = simpleGoogleAIExecutor(BuildConfig.GEMINI_API_KEY),
        systemPrompt = "あなたはプロのシステムエンジニアです。",
        llmModel = GoogleModels.Gemini2_5Flash,
        temperature = 0.7,
        toolRegistry = ToolRegistry {
            tool(SayToUser)
        }
    ) {
        handleEvents { 
            // Handle tool calls
            onToolCallStarting { eventContext ->
                println("Tool called: ${eventContext.tool.name} with args ${eventContext.toolArgs}")
            }
            // Handle event triggered when the agent complete its execution
            onAgentCompleted { eventContext ->
                println("Agent completed its run. result: ${eventContext.result}")
            }
        }
    }

    suspend fun sendMessage(prompt: String): String {
        return try {
            agent.run(prompt)
        } catch (e: Exception) {
            "エラーが発生しました: ${e.message}"
        }
    }
}