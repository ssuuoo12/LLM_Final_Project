package com.example.demo.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class ChatServiceDiet_ha {

    private static final Logger logger = LoggerFactory.getLogger(ChatServiceDiet_ha.class);

    public Map<String, String> getDietRecommendation(String disease, String mealTime) {
        String fastapiUrl = "http://localhost:8000/diet";

        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("disease", disease);      // ✅ FastAPI가 기대하는 키
        requestBody.put("meal_time", mealTime);   // ✅

        logger.debug("📤 요청 데이터: {}", requestBody);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestBody, headers);
        RestTemplate restTemplate = new RestTemplate();

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(fastapiUrl, entity, Map.class);
            logger.debug("✅ FastAPI 응답 수신: {}", response);

            Map<String, String> raw = response.getBody();
            logger.debug("📥 응답 바디: {}", raw);

            Map<String, String> result = new HashMap<>();
            result.put("disease", disease);
            result.put("meal_time", mealTime);
            result.put("recommend", raw.getOrDefault("recommend", "-"));
            result.put("allowed", raw.getOrDefault("allowed", "-"));
            result.put("restricted", raw.getOrDefault("restricted", "-"));

            return result;

        } catch (Exception e) {
            logger.error("❌ FastAPI 요청 중 오류 발생: {}", e.getMessage());
            Map<String, String> errorResult = new HashMap<>();
            errorResult.put("disease", disease); 
            errorResult.put("meal_time", mealTime);
            errorResult.put("recommend", "-");
            errorResult.put("allowed", "-");
            errorResult.put("restricted", "-");
            return errorResult;
        }
    }
}
