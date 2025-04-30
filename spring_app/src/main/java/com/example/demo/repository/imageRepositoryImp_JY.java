package com.example.demo.repository;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;

import org.springframework.stereotype.Repository;

import com.example.demo.mapper.ChatRowMapper;
import com.example.demo.mapper.imagehistMapper_JY;
import com.example.demo.vo.ChatVO;
import com.example.demo.vo.imageVO_JY;


import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class imageRepositoryImp_JY implements imageRepository_JY {
	private final JdbcTemplate jdbcTemplate;
	


	@Override
	public List<imageVO_JY> findByimagehistory(String userId){
		String sql = "SELECT * FROM diagnosis_result where user_id = ? ORDER BY created_at DESC";
		return jdbcTemplate.query(sql,  new imagehistMapper_JY(), userId);
	}
	
	
	
}
