package com.example.demo.repository;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.mapper.ChatRowMapper;
import com.example.demo.vo.ChatVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ChatRepositoryImpl implements ChatRepository {
	private final JdbcTemplate jdbcTemplate;
	
	@Override
	public List<ChatVO> findByUserId(String userId){
		String sql = "SELECT * FROM chat_history where user_id = ? ORDER BY created_at DESC";
		return jdbcTemplate.query(sql,  new ChatRowMapper(), userId);
	}
}
