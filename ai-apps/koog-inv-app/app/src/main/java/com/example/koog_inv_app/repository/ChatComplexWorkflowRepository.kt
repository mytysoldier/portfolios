package com.example.koog_inv_app.repository

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
import com.example.koog_inv_app.tools.InventoryTools

class ChatComplexWorkflowRepository {
    val promptExecutor = simpleGoogleAIExecutor(BuildConfig.GEMINI_API_KEY)

    val invStrategy = strategy("Inventory Checker") {

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

    val inventoryAgentConfig = AIAgentConfig(
        prompt = Prompt.build("inventory-agent") {
            system(
                """
                  You are an inventory management assistant.
            The user will ask about stock for various items.
            Use the 'findStock' tool to check stock levels from the CSV file.
            Always respond with clear and friendly language.  
                """.trimIndent()
            )
        },
        model = GoogleModels.Gemini2_5Flash,
        maxAgentIterations = 0,
        missingToolsConversionStrategy = MissingToolsConversionStrategy.Missing(ToolCallDescriber.JSON)
    )

    val tools = ToolRegistry {
        tools(InventoryTools())
    }
}