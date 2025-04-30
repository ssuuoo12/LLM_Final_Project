package com.example.demo.mapper;

import com.example.demo.vo.ChatVO;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ChatRowMapper implements RowMapper<ChatVO> {
    @Override
    public ChatVO mapRow(ResultSet rs, int rowNum) throws SQLException {
        ChatVO chat = new ChatVO();
        chat.setId(rs.getLong("id"));
        chat.setUserId(rs.getString("user_id"));
        chat.setMessage(rs.getString("message"));
        chat.setResponse(rs.getString("response"));
        chat.setCreatedAt(rs.getTimestamp("created_at"));
        return chat;
    }
}
