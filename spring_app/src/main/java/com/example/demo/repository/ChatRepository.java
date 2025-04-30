package com.example.demo.repository;

import java.util.List;

import com.example.demo.vo.ChatVO;

public interface ChatRepository {
	List<ChatVO> findByUserId(String userId);
}
 