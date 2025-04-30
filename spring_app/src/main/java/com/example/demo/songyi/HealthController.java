package com.example.demo.songyi;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class HealthController {

    private final HealthService healthService;

    // 건강 검사 입력 폼
    @GetMapping("/health")
    public String showForm() {
        return "health_form_songyi";
    }

    /**
     * CSV 파일을 업로드하고 FastAPI로 건강검진 예측을 요청하는 메서드
     * 
     * @param file - 업로드된 CSV 파일 (건강검진 데이터)
     * @param session - 세션 객체 (로그인 정보 및 결과 저장용)
     * @return 결과 페이지로 리다이렉트
     * 
     * 주요 처리:
     * 1. 파일 유효성 검사 - 빈 파일인 경우 에러 처리
     * 2. 로그인 사용자 확인 - 세션에서 로그인 정보 조회 및 검증
     * 3. 건강검진 데이터 저장 - HealthService를 통해 파일 처리 및 FastAPI 호출
     * 
     * 에러 처리:
     * - 빈 파일: score=0.0, risk="파일이 비어있습니다" 설정
     * - 미로그인/ID누락: score=0.0, risk="로그인 정보 누락 또는 ID 없음" 설정
     */
    @PostMapping("/health/save")
    public String saveCheckup(@RequestParam("csvFile") MultipartFile file, HttpSession session) {
        if (file.isEmpty()) {
            session.setAttribute("score", 0.0f);
            session.setAttribute("risk", "파일이 비어있습니다");
            return "redirect:/health/result";
        }

        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        System.out.println("🔍 loginUser = " + loginUser);

        if (loginUser == null || loginUser.getId() == null) {
            session.setAttribute("score", 0.0f);
            session.setAttribute("risk", "로그인 정보 누락 또는 ID 없음");
            return "redirect:/health/result";
        }

        Long userDbId = loginUser.getId();
        System.out.println("✅ loginUser.getId() = " + userDbId);
        // session: 건강검진 결과(점수, 위험도 등)를 저장하기 위한 HttpSession 객체
        healthService.saveHealthCheckup(file, userDbId, session);

        return "redirect:/health/result";
    }

    // 예측 결과 페이지 렌더링
    @GetMapping("/health/result")
    public String showResult(Model model, HttpSession session) {
        Object scoreObj = session.getAttribute("score");
        Object riskObj = session.getAttribute("risk");
        Object fileNameObj = session.getAttribute("fileName");
        Object topFeaturesObj = session.getAttribute("topFeatures");
        Object explanationObj = session.getAttribute("explanation");
        Object shapImageObj = session.getAttribute("shapImage"); // 🔥 SHAP 이미지 base64 포함

        // 필수 값 없으면 폼으로 리다이렉트
        if (scoreObj == null || riskObj == null) {
            return "redirect:/health";
        }

        float score = (scoreObj instanceof Number) ? ((Number) scoreObj).floatValue() : 0.0f;
        String risk = (riskObj instanceof String) ? (String) riskObj : "확인 불가";
        String fileName = (fileNameObj instanceof String) ? (String) fileNameObj : "없음";
        List<String> topFeatures = (topFeaturesObj instanceof List) ? (List<String>) topFeaturesObj : new ArrayList<>();
        String explanation = (explanationObj instanceof String) ? (String) explanationObj : null;
        String shapImage = (shapImageObj instanceof String) ? (String) shapImageObj : null; // ✅ base64 이미지

        // 모델 바인딩
        model.addAttribute("score", score);
        model.addAttribute("risk", risk);
        model.addAttribute("fileName", fileName);
        model.addAttribute("topFeatures", topFeatures);
        model.addAttribute("explanation", explanation);
        model.addAttribute("shapImage", shapImage); // ✅ JSP에 전달

        return "health_result_songyi";
    }
    @GetMapping("/health/history")
    public String showHealthHistory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size,
            HttpSession session,
            Model model) {

        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getId() == null) {
            model.addAttribute("error", "로그인이 필요합니다.");
            return "health_history_songyi";
        }

        Pageable pageable = PageRequest.of(page, size);
        Page<HealthScoreHistoryDTO> historyPage = healthService.getHealthHistoryPage(loginUser.getId(), pageable);

        model.addAttribute("historyPage", historyPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", historyPage.getTotalPages());

        return "health_history_songyi";  // JSP 파일 이름
    }
}
