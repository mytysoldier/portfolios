package com.example.koog_inv_app.tools

import ai.koog.agents.core.tools.annotations.LLMDescription
import ai.koog.agents.core.tools.annotations.Tool
import ai.koog.agents.core.tools.reflect.ToolSet

@LLMDescription("汎用問い合わせ分析・品質チェックツール")
class InquiryAnalysisTools : ToolSet {

    @Tool
    @LLMDescription("問い合わせの種類と複雑どを分析")
    fun analyzeInquiry(@LLMDescription("分析する問い合わせ内容") inquiry: String): String {
        val keywords = inquiry.lowercase()

        // 問い合わせ種類の判定
        val type = when {
            keywords.contains("エラー") || keywords.contains("バグ") -> "技術的問題"
            keywords.contains("使い方") || keywords.contains("方法") -> "使用方法"
            keywords.contains("とは") || keywords.contains("説明") -> "説明要求"
            keywords.contains("できない") || keywords.contains("困った") -> "トラブル解決"
            else -> "一般的質問"
        }

        // 複雑度の判定
        val complexity = when {
            inquiry.length < 50 -> "簡単"
            inquiry.contains("複数") || inquiry.contains("組み合わせ") -> "複雑"
            else -> "中程度"
        }

        return """
          【分析結果】
          問い合わせ種類: $type
          複雑度レベル: $complexity
          推奨対応: ${getRecommendedAction(type, complexity)}
      """.trimIndent()
    }

    private fun getRecommendedAction(type: String, complexity: String): String {
        return when (type) {
            "技術的問題" -> "詳細調査と段階的解決方法の提示"
            "使用方法" -> "具体例を含む分かりやすい手順説明"
            "説明要求" -> "基本概念から応用まで体系的説明"
            else -> "ユーザーのニーズに合わせた丁寧な回答"
        }
    }
}