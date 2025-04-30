package com.example.demo.songyi;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
@Slf4j
public class SupplementChatbotService {

    private final RestTemplate restTemplate = new RestTemplate();

    
    String chatbotApiUrl = "http://localhost:8000/supplement/recommend";
    public String askChatbot(String question) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
            formData.add("question", question);
            

            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(formData, headers);

            ResponseEntity<String> response = restTemplate.postForEntity(chatbotApiUrl, request, String.class);

            // ✅ JSON 파싱
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.getBody());
            return root.path("response").asText("❌ 응답 없음");

        } catch (Exception e) {
            log.error("❌ FastAPI 호출 실패", e);
            return "❌ 오류 발생: " + e.getMessage();
        }
    }
}
