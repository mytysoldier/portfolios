package com.example.koog_inv_app.tools

import ai.koog.agents.core.tools.annotations.LLMDescription
import ai.koog.agents.core.tools.annotations.Tool
import ai.koog.agents.core.tools.reflect.ToolSet
import java.io.BufferedReader
import java.io.InputStreamReader

@LLMDescription("Inventory management tools (reads from resources/inventory.csv)")
class InventoryTools : ToolSet {
    @Tool
    @LLMDescription("Find the current stock for an item by its name")
    fun findStock(@LLMDescription("Item name to search") itemName: String) : String {
        val resource = this::class.java.classLoader.getResourceAsStream("inventory.csv")
            ?: return "Error: inventory.csv not found in resources."

        val reader = BufferedReader(InputStreamReader(resource))
        val lines = reader.readLines().drop(1) // skip header

        val match = lines.map { it.split(",") }
            .find { it[0].equals(itemName, ignoreCase = true) }

        return if (match != null) {
            val stock = match[1].toIntOrNull() ?: 0
            if (stock > 0) "Stock for ${match[0]}: $stock items available."
            else "Stock for ${match[0]} is currently 0. Please restock soon."
        } else {
            "No record found for item: $itemName"
        }
    }
}