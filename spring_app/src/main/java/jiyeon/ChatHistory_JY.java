package jiyeon;

import java.time.Duration;
import java.time.LocalDateTime;

public class ChatHistory_JY {
    private Long id;
    private String title;
    private LocalDateTime created_at;

    public ChatHistory_JY(Long id, String title, LocalDateTime created_at) {
        this.id = id;
        this.title = title;
        this.created_at = created_at;
    }

    public String getRelativeTime() {
        Duration duration = Duration.between(created_at, LocalDateTime.now());
        if (duration.toMinutes() < 1) return "방금 전";
        else if (duration.toHours() < 1) return duration.toMinutes() + "분 전";
        else if (duration.toDays() < 1) return duration.toHours() + "시간 전";
        else return duration.toDays() + "일 전";
    }

    // Getter/Setter 생략 가능 (Lombok 사용 가능)
}
