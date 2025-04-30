package com.example.demo.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.imageDTO_JY;
import com.example.demo.mapper.imagehistMapper_JY;
import com.example.demo.vo.imageVO_JY;

import util.MultipartInputStreamFileResource;
@Service
public class imageService_JY {

	 @Value("${fastapi.url:http://localhost:8000}")
	    private String fastApiUrl;
	    
	    private final RestTemplate restTemplate;
	    
	    public imageService_JY() {
	        this.restTemplate = new RestTemplate();
		
	    }

	    /**
	     * FastAPI로 이미지와 질환 종류를 전송하여 진단 결과를 받아옴
	     * 
	     * @param image 업로드된 이미지
	     * @param disease 질환 종류 (예: eye, skin, lc)
	     * @return 진단 결과 JSON
	     * @throws IOException 예외 발생 시
	     */
	    public Map<String, Object> getDiagnosisResult(MultipartFile image, String disease, String userId, String userName) throws IOException {
	        String url = fastApiUrl + "/diagnose/" + disease;

	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

	        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
	        body.add("file", new MultipartInputStreamFileResource(
	                image.getInputStream(),
	                image.getOriginalFilename())
	        );
	        body.add("user_id", userId);
	        body.add("user_name", userName);

	        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

	        try {
	            ResponseEntity<Map> response = restTemplate.postForEntity(url, requestEntity, Map.class);

	            if (response.getBody() != null && response.getBody().containsKey("diagnosis")) {
	                return response.getBody();
	            } else if (response.getBody() != null && response.getBody().containsKey("error")) {
	                throw new RuntimeException("FastAPI 오류: " + response.getBody().get("error"));
	            } else {
	                throw new RuntimeException("진단 실패 또는 잘못된 응답입니다.");
	            }

	        } catch (RestClientException e) {
	            throw new RuntimeException("FastAPI 서버와 통신 중 오류 발생: " + e.getMessage(), e);
	        }
	    }
	    
}