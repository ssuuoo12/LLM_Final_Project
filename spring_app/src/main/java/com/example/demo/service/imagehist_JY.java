package com.example.demo.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.example.demo.dto.imageDTO_JY;
import com.example.demo.vo.imageVO_JY;

public interface imagehist_JY {

	List<imageVO_JY> getimagehistoryByUser(String userId); // 인터페이스에 넣기
	Page<imageDTO_JY> getimageHistoryPage(String userId, Pageable pageable); // 선언만!
}
