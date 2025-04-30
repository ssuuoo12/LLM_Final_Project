package com.example.demo.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.example.demo.dto.imageDTO_JY;
import com.example.demo.mapper.imageDTOMapper_JY;
import com.example.demo.mapper.imagehistMapper_JY;
import com.example.demo.vo.imageVO_JY;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class imageServiceImpl_JY implements imagehist_JY {

    private final JdbcTemplate jdbcTemplate;

    @Override 
    public List<imageVO_JY> getimagehistoryByUser(String userId) {
    	String sql = "SELECT \n"
    			+ "    diagnosis_result.id AS id,\n"
    			+ "    diagnosis_result.user_id AS user_id,\n"
    			+ "    diagnosis_result.user_name AS user_name,\n"
    			+ "    diagnosis_result.file_name AS file_name,\n"
    			+ "    diagnosis_result.disease_type AS disease_type,\n"
    			+ "    diagnosis_result.diagnosis AS diagnosis,\n"
    			+ "    diagnosis_result.confidence AS confidence,\n"
    			+ "    diagnosis_result.created_at AS created_at\n"
    			+ "FROM diagnosis_result\n"
    			+ "WHERE diagnosis_result.user_id = ?\n"
    			+ "ORDER BY diagnosis_result.created_at DESC";
        return jdbcTemplate.query(sql, new imagehistMapper_JY(), userId);
    }


    @Override
    public Page<imageDTO_JY> getimageHistoryPage(String userId, Pageable pageable) {
        System.out.println("이미지 페이징된 이력 조회 시작: userId = " + userId);

        String sql = "SELECT file_name, diagnosis, confidence, created_at FROM diagnosis_result WHERE user_id = ? ORDER BY created_at DESC";

        // 전체 데이터 조회
        List<imageDTO_JY> fullList = jdbcTemplate.query(sql, new imageDTOMapper_JY(), new Object[]{userId});

        int start = (int) pageable.getOffset();
        
        // ✅ 페이지 범위가 데이터 개수보다 크면 빈 페이지 반환
        if (start >= fullList.size()) {
            return new PageImpl<>(List.of(), pageable, fullList.size());
        }

        int end = Math.min(start + pageable.getPageSize(), fullList.size());

        // 실제 페이지 대상 리스트 추출
        List<imageDTO_JY> paged = fullList.subList(start, end);

        return new PageImpl<>(paged, pageable, fullList.size());
    }

	
    
    
}
