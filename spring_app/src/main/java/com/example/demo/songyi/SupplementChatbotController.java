package com.example.demo.songyi;


import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SupplementChatbotController {

    private final SupplementChatbotService chatbotService;

    @GetMapping("/supplement")
    public String chatbotPage() {
        return "supplementChatbot_songyi";
    }

    
    //ajax 요청처리를 위해서 기존 요청 주석 처리 2025-04-21
	/*
	 * @PostMapping("/supplement/ask") public String askQuestion(@RequestParam
	 * String question, Model model) { String answer =
	 * chatbotService.askChatbot(question); model.addAttribute("question",
	 * question); model.addAttribute("answer", answer); return
	 * "supplementChatbot_songyi"; }
	 */
    
    
    
 // 챗봇과 대화이력 가져오기 2025-04-22
    @GetMapping("/SupplementHistory")
    public String loadChatHistory(
            @RequestParam("userId") Long userId,
            @RequestParam(name = "page", defaultValue = "1") int page,
            Model model) {

        int pageSize = 5;
        String apiUrl = "http://localhost:8000/supplement/history/" + userId + "?page=" + page + "&size=" + pageSize;
        RestTemplate restTemplate = new RestTemplate();

        List<Map<String, Object>> historyList = new ArrayList<>();
        int totalPages = 1;

        try {
            // ✅ Map으로 받아야 함
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.GET,
                    null,
                    new ParameterizedTypeReference<Map<String, Object>>() {}
            );

            Map<String, Object> result = response.getBody();
            if (result != null) {
                // ✅ "history"는 리스트인데 내부는 LinkedHashMap 형태임
                Object historyRaw = result.get("history");
                if (historyRaw instanceof List<?>) {
                    List<?> rawList = (List<?>) historyRaw;
                    for (Object item : rawList) {
                        if (item instanceof Map) {
                            historyList.add((Map<String, Object>) item);
                        }
                    }
                }

                Object totalPagesRaw = result.get("total_pages");
                if (totalPagesRaw instanceof Number) {
                    totalPages = ((Number) totalPagesRaw).intValue();
                }
            }

        } catch (Exception e) {
            System.out.println("❌ FastAPI 호출 실패: " + e.getMessage());
            e.printStackTrace(); // 상세 스택 확인
        }

        
        
        model.addAttribute("historyList", historyList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("userId", userId);
        return "supplementChatbotHistory_songyi";
    }

}
