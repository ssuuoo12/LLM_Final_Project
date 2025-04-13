package com.example.demo.dto;

import lombok.Data;
// 회원가입, 정보수정, 로그인시 입력받은값 전달 클래스
@Data
public class UserDTO {
    private String userId;
    private String password;
    private String userName;
    private String gender;
    private String email;
}
