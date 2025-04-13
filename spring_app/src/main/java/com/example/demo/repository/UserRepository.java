package com.example.demo.repository;

import com.example.demo.dto.UserDTO;
import com.example.demo.vo.UserVO;

public interface UserRepository {
    UserVO findByUserId(String userId);
    boolean save(UserDTO userDTO);
    boolean saveByOAuth(UserVO userVO); //소셜 로그인용
    boolean update(UserDTO userDTO); // 업데이트용 메서드
    boolean delete(String userId); //삭제용 메서드
    // 비밀번호 변경용 메서드
    boolean updatePassword(String userId, String encodedPw, boolean forceChange);
    String findUserIdByNameAndEmail(String name, String email);
}
