package com.example.demo.vo;

import lombok.Data;
// 실 유저 데이터 나타내는 클래스
@Data
public class UserVO {
    private Long id;
    private String userId;
    private String password;
    private String userName;
    private String gender;
    private String email;
    private String role;
    private String provider;
    private String providerId;
    private String createdAt;
    private String updatedAt;
    private boolean forceChange;
    
    public boolean isForceChange() {
        return forceChange;
    }

    public void setForceChange(boolean forceChange) {
        this.forceChange = forceChange;
    }
}