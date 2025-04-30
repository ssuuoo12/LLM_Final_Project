package com.example.demo.Controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.service.ChatServiceDiet_ha;

@Controller
public class ChatControllerDiet_ha {

    @Autowired
    private ChatServiceDiet_ha chatService_ha;

    @GetMapping("/dietForm")
    public String chatPage() {
        System.out.println("✅ [GET] /diet 요청 받음 → dietForm.jsp로 이동");
        return "dietForm";
    }
    
    @PostMapping("/recommend-diet")
    public String recommendDiet(@RequestParam String disease,
                                 @RequestParam String mealTime,
                                 Model model,
                                 HttpSession session) {

        System.out.println("📥 [POST] /recommend-diet 요청 수신");
        System.out.println("🔸 입력 질병: " + disease);
        System.out.println("🔸 입력 식사시간: " + mealTime);

        Map<String, String> response;

        try {
            response = chatService_ha.getDietRecommendation(disease, mealTime);
            System.out.println("✅ FastAPI 응답 수신 성공");
        } catch (Exception e) {
            System.out.println("❌ FastAPI 호출 실패: " + e.getMessage());
            response = new HashMap<>();
            response.put("recommend", "FastAPI 호출 실패: " + e.getMessage());
            response.put("allowed", "-");
            response.put("restricted", "-");
        }

        // 응답 내용 출력
        System.out.println("🔸 추천 식단: " + response.get("recommend"));
        System.out.println("🔸 권장 식품: " + response.get("allowed"));
        System.out.println("🔸 제한 식품: " + response.get("restricted"));

        // JSP에 결과 전달
        model.addAttribute("recommend", response.get("recommend"));
        model.addAttribute("allowed", response.get("allowed"));
        model.addAttribute("restricted", response.get("restricted"));

        // 세션 히스토리 관리
        List<Map<String, String>> history = (List<Map<String, String>>) session.getAttribute("history");
        if (history == null) {
            history = new ArrayList<>();
            System.out.println("📦 세션 히스토리 초기화");
        }

        Map<String, String> entry = new HashMap<>();
        entry.put("질병", disease);
        entry.put("식사시간", mealTime);
        entry.put("추천식단", response.get("recommend"));
        entry.put("권장식단", response.get("allowed"));
        entry.put("제한식단", response.get("restricted"));

        history.add(0, entry);  // 최근 순으로 정렬
        session.setAttribute("history", history);

        System.out.println("✅ 추천 기록 세션 저장 완료 (" + history.size() + "개)");

        return "dietResult";
    }
}
