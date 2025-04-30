package com.example.demo.vo;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class ChatVO {
	private Long id;
    private String userId;
    private String message;
    private String response;
    private Timestamp createdAt;
}
