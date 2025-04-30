package com.example.demo.dto;

import java.sql.Timestamp;

import lombok.Data;
// 회원가입, 정보수정, 로그인시 입력받은값 전달 클래스
@Data
public class imageDTO_JY {
	    private int id;
	    private String userId;
	    private String userName;       // 누락됨
	    private String fileName;       // Java에서는 snake_case → camelCase 권장
	    private String diseaseType;    // 위와 동일
	    private String diagnosis;
	    private double confidence;     // 소수점 맞추기 (DECIMAL → double)
	    private Timestamp createdAt;
    

    
}
