package com.example.demo.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class imageVO_JY {
// diagnosis_result
//	CREATE TABLE diagnosis_result (
	
//		    id INT AUTO_INCREMENT PRIMARY KEY,
//		    user_id varchar(255) NOT NULL,
//		    user_name VARCHAR(100) NOT NULL, 
//		    file_name VARCHAR(255) NOT NULL,
//		    disease_type VARCHAR(50) NOT NULL,
//		    diagnosis VARCHAR(50) NOT NULL,
//		    confidence DECIMAL(5, 2) NOT NULL,
//		    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
//		    FOREIGN KEY (user_id) REFERENCES user(user_id) -- user 테이블과 연동된다면
//		);
	
    private int id;
    private String userId;
    private String userName;       // 누락됨
    private String fileName;       // Java에서는 snake_case → camelCase 권장
    private String diseaseType;    // 위와 동일
    private String diagnosis;
    private double confidence;     // 소수점 맞추기 (DECIMAL → double)
    private Timestamp createdAt;
	
	
}
