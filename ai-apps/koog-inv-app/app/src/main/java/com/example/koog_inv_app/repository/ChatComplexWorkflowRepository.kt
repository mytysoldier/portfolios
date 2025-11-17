package com.example.koog_inv_app.repository

import ai.koog.agents.core.agent.AIAgent
import ai.koog.agents.core.agent.config.AIAgentConfig
import ai.koog.agents.core.agent.config.MissingToolsConversionStrategy
import ai.koog.agents.core.agent.config.ToolCallDescriber
import ai.koog.agents.core.dsl.builder.forwardTo
import ai.koog.agents.core.dsl.builder.strategy
import ai.koog.agents.core.dsl.extension.nodeExecuteTool
import ai.koog.agents.core.dsl.extension.nodeLLMRequest
import ai.koog.agents.core.dsl.extension.nodeLLMSendToolResult
import ai.koog.agents.core.dsl.extension.onToolCall
import ai.koog.agents.core.tools.ToolRegistry
import ai.koog.agents.core.tools.reflect.tools
import ai.koog.prompt.dsl.Prompt
import ai.koog.prompt.executor.clients.google.GoogleModels
import ai.koog.prompt.executor.llms.all.simpleGoogleAIExecutor
import com.example.koog_inv_app.BuildConfig
import com.example.koog_inv_app.tools.InquiryAnalysisTools

class ChatComplexWorkflowRepository {
    val promptExecutor = simpleGoogleAIExecutor(BuildConfig.GEMINI_API_KEY)

    val generalInquiryStrategy = strategy("General Inquiry Handler") {
        val nodeReceiveInput by nodeLLMRequest()
        val nodeDecideTool by nodeExecuteTool()
        val nodeSendToolResult by nodeLLMSendToolResult()

        edge(nodeStart forwardTo nodeReceiveInput)

        edge(
            (nodeReceiveInput forwardTo nodeDecideTool)
                    onToolCall { true }
        )

        edge(nodeDecideTool forwardTo nodeSendToolResult)
        edge(nodeSendToolResult forwardTo nodeFinish)
    }

    // ツールレジストリ
    val inquiryTools = ToolRegistry {
        tools(InquiryAnalysisTools())
    }

    // エージェント設定
    val generalInquiryAgentConfig = AIAgentConfig(
        prompt = Prompt.build("general-inquiry-agent") {
            system(
                """
                  あなたは汎用問い合わせ対応アシスタントです。
                  ユーザーからの質問に対して、まず内容を分析し、適切なツールを使用して回答してください。
                  分かりやすく丁寧な回答を心がけてください。  
                """.trimIndent()
            )
        },
        model = GoogleModels.Gemini2_5Flash,
        maxAgentIterations = 5,
        missingToolsConversionStrategy = MissingToolsConversionStrategy.Missing(ToolCallDescriber.JSON)
    )

    // エージェント実態
    val generalInquiryAgent = AIAgent(
        promptExecutor = promptExecutor,
        toolRegistry = inquiryTools,
        strategy = generalInquiryStrategy,
        agentConfig = generalInquiryAgentConfig
    )

    suspend fun sendMessage(inquiry: String): String {
        return try {
            generalInquiryAgent.run(inquiry).content
        } catch (e: Exception) {
            "申し訳ございません。処理中にエラーが発生しました: ${e.message}"
        }
    }
}