package com.example.demo.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.example.demo.vo.UserVO;

public class UserRowMapper implements RowMapper<UserVO> {
    @Override
    public UserVO mapRow(ResultSet rs, int rowNum) throws SQLException {
        UserVO user = new UserVO();
        user.setUserId(rs.getString("user_id"));
        user.setPassword(rs.getString("password"));
        user.setUserName(rs.getString("user_name"));
        user.setEmail(rs.getString("email"));
        user.setGender(rs.getString("gender"));
        // force_change 컬럼 읽기
        user.setForceChange(rs.getBoolean("force_change"));
        return user;
    }
}
