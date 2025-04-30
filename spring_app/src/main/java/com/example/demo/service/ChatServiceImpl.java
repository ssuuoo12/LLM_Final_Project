package com.example.demo.service;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ChatRowMapper;
import com.example.demo.vo.ChatVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public List<ChatVO> getChatHistoryByUser(String userId) {
    	String sql = "SELECT \n"
    			+ "    chat_history.id AS id,\n"
    			+ "    chat_history.user_id AS user_id,\n"
    			+ "    chat_history.message AS message,\n"
    			+ "    chat_history.response AS response,\n"
    			+ "    chat_history.created_at AS created_at\n"
    			+ "FROM chat_history\n"
    			+ "WHERE chat_history.user_id = ?\n"
    			+ "ORDER BY chat_history.created_at DESC";
        return jdbcTemplate.query(sql, new ChatRowMapper(), userId);
    }

    @Override
    public void saveChat(String userId, String message, String response) {
        String sql = "INSERT INTO chat_history (user_id, message, response) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, userId, message, response);
    }
}
