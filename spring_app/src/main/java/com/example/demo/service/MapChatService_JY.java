package com.example.demo.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
@Slf4j
public class MapChatService_JY {

    private final RestTemplate restTemplate = new RestTemplate();
    private final String chatbotApiUrl = "http://localhost:8000/mapc/recommend2";
    private final String historyApiUrl = "http://localhost:8000/mapc/history/";

    public String askChatbot(String userId, String question) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(Map.of("user_id", userId, "message", question));

            HttpEntity<String> request = new HttpEntity<>(json, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(chatbotApiUrl, request, String.class);

            JsonNode root = mapper.readTree(response.getBody());
            return root.path("response").asText("❌ 응답 없음");
        } catch (Exception e) {
            log.error("❌ FastAPI 호출 실패", e);
            return "❌ 오류 발생: " + e.getMessage();
        }
    }

    public List<Map<String, String>> loadChatHistory(String userId) {
        try {
            ResponseEntity<String> response = restTemplate.getForEntity(historyApiUrl + userId, String.class);
            
            // System.out.println("📦 받은 이력: " + response.getBody());
            
            ObjectMapper mapper = new ObjectMapper();
            JsonNode array = mapper.readTree(response.getBody());

            List<Map<String, String>> history = new ArrayList<>();
            for (JsonNode node : array) { 
                Map<String, String> entry = new HashMap<>();
                entry.put("role", node.get("role").asText());
                entry.put("content", node.get("content").asText());
                entry.put("timestamp", node.get("timestamp").asText());
                history.add(entry);
            }
            return history;
        } catch (Exception e) {
            log.error("❌ 대화 이력 불러오기 실패", e);
            return Collections.emptyList();
        }
    }
}
