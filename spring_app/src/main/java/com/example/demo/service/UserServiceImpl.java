package com.example.demo.service;

import java.util.UUID;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.dto.UserDTO;
import com.example.demo.repository.UserRepository;
import com.example.demo.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public boolean register(UserDTO dto) {
        // 유저 존재 여부 확인
        if (userRepository.findByUserId(dto.getUserId()) != null) {
            return false; // 이미 존재
        }

        // 암호화 후 저장
        String hashedPw = passwordEncoder.encode(dto.getPassword());
        dto.setPassword(hashedPw);
        return userRepository.save(dto);
    }

    @Override
    public UserVO login(String userId, String password) {
        UserVO user = userRepository.findByUserId(userId);
        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            return user;
        }
        return null;
    }
    
    @Override
    public UserVO getUserInfo(String userId) {
        return userRepository.findByUserId(userId);
    }

    @Override
    public boolean update(UserDTO dto) {
    	// 비밀번호가 비어있지 않으면 암호화 처리
        if (dto.getPassword() != null && !dto.getPassword().isEmpty()) {
        	String hashedPw = passwordEncoder.encode(dto.getPassword());
            dto.setPassword(hashedPw);
        }
        return userRepository.update(dto);
    }
    
    @Override
    public boolean delete(String userId) {
        return userRepository.delete(userId);
    }
    
    @Override
    public String resetPasswordAndReturn(String userId, String email) {
        UserVO user = userRepository.findByUserId(userId);
        if (user != null && user.getEmail().equals(email)) {
            String tempPw = UUID.randomUUID().toString().substring(0, 8);
            String encoded = passwordEncoder.encode(tempPw);
            userRepository.updatePassword(userId, encoded, true);
            return tempPw;  // 여기!
        }
        return null;
    }
    
    @Override
    public boolean isForceChange(String userId) {
        UserVO user = userRepository.findByUserId(userId);
        return user != null && user.isForceChange();
    }

    @Override
    public void clearForceChange(String userId) {
    	System.out.println("⚠️ clearForceChange() called for userId: " + userId);
        userRepository.updatePassword(userId, userRepository.findByUserId(userId).getPassword(), false);
    }
    
    @Override
    public String findUserId(String userName, String email) {
        try {
            return userRepository.findUserIdByNameAndEmail(userName, email);
        } catch (Exception e) {
            // 조회 실패 시 null 반환 (없는 경우 포함)
            return null;
        }
    }
}
