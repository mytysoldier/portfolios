package com.example.koog_inv_app.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.koog_inv_app.model.ChatMessage
import com.example.koog_inv_app.repository.ChatRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class ChatViewModel(
    private val repository: ChatRepository = ChatRepository()
) : ViewModel() {
    private val _messages = MutableStateFlow<List<ChatMessage>>(emptyList())
    val messages = _messages.asStateFlow()

    fun sendMessage(userInput: String) {
        if (userInput.isBlank()) return

        val updatedList = _messages.value + ChatMessage(userInput, isUser = true)
        _messages.value = updatedList

        viewModelScope.launch {
            val aiResponse = repository.sendMessage(userInput)
            _messages.value = _messages.value + ChatMessage(aiResponse, isUser = false)
        }

    }
}