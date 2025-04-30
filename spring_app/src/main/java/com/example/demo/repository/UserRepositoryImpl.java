package com.example.demo.repository;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.dto.UserDTO;
import com.example.demo.mapper.UserRowMapper;
import com.example.demo.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class UserRepositoryImpl implements UserRepository {

    private final JdbcTemplate jdbcTemplate;
    // 지연 추가
    @Override
    public UserVO findByUserName(String userName) {
        String sql = "SELECT * FROM user WHERE user_name = ?";
        return jdbcTemplate.queryForObject(sql, new UserRowMapper(), userName);
    }
    
    @Override
    public UserVO findByUserId(String userId) {
        try {
            String sql = "SELECT * FROM user WHERE user_id = ?";
            return jdbcTemplate.queryForObject(sql, new Object[]{userId}, new UserRowMapper());
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public boolean save(UserDTO userDTO) {
        int result = jdbcTemplate.update(
            "INSERT INTO user (user_id, password, user_name, email, gender) VALUES (?, ?, ?, ?, ?)",
            userDTO.getUserId(), userDTO.getPassword(), userDTO.getUserName(), userDTO.getEmail(),
            userDTO.getGender()
        );
        return result > 0;
    }
    @Override
    public boolean saveByOAuth(UserVO userVO) {
        int result = jdbcTemplate.update(
            "INSERT INTO user (user_id, user_name, email, provider, provider_id, role) VALUES (?, ?, ?, ?, ?, ?)",
            userVO.getUserId(), userVO.getUserName(), userVO.getEmail(),
            userVO.getProvider(), userVO.getProviderId(), userVO.getRole()
        );
        return result > 0;
    }
    
    @Override
    public boolean update(UserDTO userDTO) {
        StringBuilder sql = new StringBuilder("UPDATE user SET ");
        boolean first = true;

        // 동적으로 SQL 구성
        if (userDTO.getUserName() != null && !userDTO.getUserName().isEmpty()) {
            sql.append("user_name = ?");
            first = false;
        }
        if (userDTO.getEmail() != null && !userDTO.getEmail().isEmpty()) {
            if (!first) sql.append(", ");
            sql.append("email = ?");
            first = false;
        }
        if (userDTO.getGender() != null && !userDTO.getGender().isEmpty()) {
            if (!first) sql.append(", ");
            sql.append("gender = ?");
            first = false;
        }
        if (userDTO.getPassword() != null && !userDTO.getPassword().isEmpty()) {
            if (!first) sql.append(", ");
            sql.append("password = ?");
        }

        sql.append(" WHERE user_id = ?");

        // 파라미터 순서 유의
        java.util.List<Object> params = new java.util.ArrayList<>();
        if (userDTO.getUserName() != null && !userDTO.getUserName().isEmpty()) {
            params.add(userDTO.getUserName());
        }
        if (userDTO.getEmail() != null && !userDTO.getEmail().isEmpty()) {
            params.add(userDTO.getEmail());
        }
        if (userDTO.getGender() != null && !userDTO.getGender().isEmpty()) {
            params.add(userDTO.getGender());
        }
        if (userDTO.getPassword() != null && !userDTO.getPassword().isEmpty()) {
            params.add(userDTO.getPassword());
        }
        params.add(userDTO.getUserId());

        int result = jdbcTemplate.update(sql.toString(), params.toArray());
        return result > 0;
    }
    
    @Override
    public boolean delete(String userId) {
        String sql = "DELETE FROM user WHERE user_id = ?";
        int result = jdbcTemplate.update(sql, userId);
        return result > 0;
    }
    
    @Override
    public boolean updatePassword(String userId, String encodedPw, boolean forceChange) {
        String sql = "UPDATE user SET password = ?, force_change = ? WHERE user_id = ?";
        return jdbcTemplate.update(sql, encodedPw, forceChange, userId) > 0;
    }
    @Override
    public String findUserIdByNameAndEmail(String name, String email) {
        String sql = "SELECT user_id FROM user WHERE user_name = ? AND email = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new Object[]{name, email}, String.class);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
}
