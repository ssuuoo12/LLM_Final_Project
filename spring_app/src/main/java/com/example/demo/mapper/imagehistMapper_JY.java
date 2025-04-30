package com.example.demo.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.example.demo.dto.imageDTO_JY;
import com.example.demo.vo.imageVO_JY;

public class imagehistMapper_JY implements RowMapper<imageVO_JY> {
    @Override
    public imageVO_JY mapRow(ResultSet rs, int rowNum) throws SQLException {
    	imageVO_JY result = new imageVO_JY();
        result.setId(rs.getInt("id"));
        result.setUserId(rs.getString("user_id"));
        result.setUserName(rs.getString("user_name"));
        result.setFileName(rs.getString("file_name"));
        result.setDiseaseType(rs.getString("disease_type"));
        result.setDiagnosis(rs.getString("diagnosis"));
        result.setConfidence(rs.getDouble("confidence")); // DECIMAL → double
        result.setCreatedAt(rs.getTimestamp("created_at"));
        return result;
    }
    

    
}
