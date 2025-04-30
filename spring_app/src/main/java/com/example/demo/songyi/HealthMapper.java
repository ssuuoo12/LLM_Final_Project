package com.example.demo.songyi;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.data.repository.query.Param;


//송이
@Mapper
public interface HealthMapper {
	  @Select("""
		        SELECT 
		            file_id AS fileId, 
		            file_name AS fileName, 
		            score, 
		            risk_level AS riskLevel, 
		            reg_date AS regDate, 
		            user_id AS userId 
		        FROM HealthScore 
		        WHERE user_id = #{userId} 
		        ORDER BY reg_date DESC
		    """)
		    List<HealthScoreHistoryDTO> findByUserId(@Param("userId") long userId);
}
