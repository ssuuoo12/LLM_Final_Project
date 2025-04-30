package com.example.demo.songyi;

import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpSession;

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

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class HealthService {

    private final RestTemplate restTemplate;

    public void saveHealthCheckup(MultipartFile file, Long userId, HttpSession session) {
        System.out.println("✅ saveHealthCheckup 받은 userId = " + userId);
        if (userId == null) {
            System.err.println("❌ user_id가 null입니다. FastAPI 호출 중단");
            handleFailure(session, "로그인 정보가 유효하지 않습니다.");
            return;
        }

        String fastApiUrl = "http://localhost:8000/predict_songyi/upload-predict-save";

        try (InputStream inputStream = file.getInputStream()) {
            // 요청 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            // multipart 요청 구성
            MultipartInputStreamFileResource fileResource =
                new MultipartInputStreamFileResource(inputStream, file.getOriginalFilename());
            HttpEntity<String> userIdPart = new HttpEntity<>(String.valueOf(userId));

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("file", fileResource);
            body.add("user_id", userIdPart);

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

            // 요청 전송
            ResponseEntity<String> response = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                ObjectMapper mapper = new ObjectMapper();
                HealthScoreDTO dto = mapper.readValue(response.getBody(), HealthScoreDTO.class);

                // 세션에 저장
                session.setAttribute("score", dto.getScore());
                session.setAttribute("risk", dto.getRisk());
                session.setAttribute("fileName", file.getOriginalFilename());
                session.setAttribute("topFeatures", dto.getTopFeatures());
                session.setAttribute("explanation", dto.getExplanation());
                session.setAttribute("shapImage", dto.getShapImage());  // ✅ base64 이미지 세션 저장

                System.out.printf("✅ FastAPI 예측 성공: score=%.2f, risk=%s\n", dto.getScore(), dto.getRisk());
            } else {
                handleFailure(session, "FastAPI 응답 실패: " + response.getStatusCode());
            }

        } catch (RestClientException e) {
            handleFailure(session, "❌ FastAPI 연결 실패: " + e.getMessage());
        } catch (Exception e) {
            handleFailure(session, "❌ 예측 처리 예외: " + e.getMessage());
        }
    }

    private final HealthMapper healthMapper;
    public Page<HealthScoreHistoryDTO> getHealthHistoryPage(Long userId, Pageable pageable) {
        System.out.println("📄 페이징된 이력 조회 시작: userId = " + userId);

        List<HealthScoreHistoryDTO> fullList = healthMapper.findByUserId(userId);  // 전체 데이터
        int start = (int) pageable.getOffset();
        int end = Math.min(start + pageable.getPageSize(), fullList.size());
        List<HealthScoreHistoryDTO> paged = fullList.subList(start, end);

        return new PageImpl<>(paged, pageable, fullList.size());
    }
   
   
    private void handleFailure(HttpSession session, String errorMessage) {
        System.err.println(errorMessage);
        session.setAttribute("score", 0.0f);
        session.setAttribute("risk", "예측 실패");
        session.setAttribute("fileName", "없음");
        session.setAttribute("topFeatures", null);
        session.setAttribute("explanation", null);
        session.setAttribute("shapImage", null);
    }
}
