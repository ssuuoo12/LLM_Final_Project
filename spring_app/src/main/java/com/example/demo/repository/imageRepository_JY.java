package com.example.demo.repository;

import java.util.List;

import com.example.demo.vo.ChatVO;
import com.example.demo.vo.UserVO;
import com.example.demo.vo.imageVO_JY;

public interface imageRepository_JY {
	
	// 이미지 진단 이력
	List<imageVO_JY> findByimagehistory(String userId);
	
	 
	
}
 