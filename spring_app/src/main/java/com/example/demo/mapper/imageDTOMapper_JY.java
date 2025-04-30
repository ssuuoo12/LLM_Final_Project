package com.example.demo.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.example.demo.dto.imageDTO_JY;

public class imageDTOMapper_JY implements RowMapper<imageDTO_JY> {
    @Override
    public imageDTO_JY mapRow(ResultSet rs, int rowNum) throws SQLException {
        imageDTO_JY dto = new imageDTO_JY();
        dto.setFileName(rs.getString("file_name"));
        dto.setDiagnosis(rs.getString("diagnosis"));
        dto.setConfidence(rs.getDouble("confidence"));
        dto.setCreatedAt(rs.getTimestamp("created_at"));
        return dto;
    }
}

