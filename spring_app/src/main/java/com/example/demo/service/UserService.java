package com.example.demo.service;

import com.example.demo.dto.UserDTO;
import com.example.demo.vo.UserVO;

public interface UserService {
    boolean register(UserDTO dto);
    UserVO login(String userId, String password);
    UserVO getUserInfo(String userId); // 마이페이지 조회
    boolean update(UserDTO userDTO); // 수정 처리
    boolean delete(String userId); // 회원 삭제 처리
    String findUserId(String userName, String email); // 아이디 찾기용 메서드
    String resetPasswordAndReturn(String userId, String email);
    boolean isForceChange(String userId);
    void clearForceChange(String userId);
}
