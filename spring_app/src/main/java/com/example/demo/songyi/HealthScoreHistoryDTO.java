package com.example.demo.songyi;
//송이
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data // @Getter + @Setter + @ToString + @EqualsAndHashCode 포함
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HealthScoreHistoryDTO {
	private Long fileId;
    private String fileName;
    private Float score;
    private String riskLevel;
    private LocalDateTime regDate;
    private Long userId;
    public Date getRegDateAsDate() {
    	if (this.regDate == null) return null;
        return Date.from(this.regDate.atZone(ZoneId.systemDefault()).toInstant());
    }
}
