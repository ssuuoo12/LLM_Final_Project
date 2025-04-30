package com.example.demo.service;

import java.util.List;

import com.example.demo.vo.ChatVO;

public interface ChatService {
    List<ChatVO> getChatHistoryByUser(String userId);
    void saveChat(String userId, String message, String response);
}

