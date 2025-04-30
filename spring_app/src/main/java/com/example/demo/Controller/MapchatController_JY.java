package com.example.demo.Controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.security.CustomUserDetails;
import com.example.demo.service.MapChatService_JY;

@Controller
public class MapchatController_JY {

    @Autowired
    private MapChatService_JY mapChatService;

    // 고유한 세션 키 상수 정의 (다른 컨트롤러와 충돌 방지)
    private static final String SESSION_USER_ID = "mapUserId";
    private static final String SESSION_CHAT_HISTORY = "mapChatHistory";

    @GetMapping("/mapc")
    public String chatbotPage(HttpSession session, Model model,
                              @AuthenticationPrincipal CustomUserDetails userDetails) {
        // ✅ userId 세션에 저장 (로그인한 경우만)
        if (userDetails != null && userDetails.getUser() != null) {
            session.setAttribute(SESSION_USER_ID, userDetails.getUser().getUserId());
        } else {
            session.setAttribute(SESSION_USER_ID, "guest"); // 로그인 안 된 경우도 처리
        }

        // ✅ 이전 대화 이력 제거
        session.removeAttribute(SESSION_CHAT_HISTORY);
        model.addAttribute("history", new ArrayList<>());

        return "mapchat_JY";
    }

    @GetMapping("/mapc/ask")
    public String redirectAskForm() {
        return "redirect:/mapc";
    }

    @PostMapping("/mapc/ask")
    public String askQuestion(@RequestParam String question,
                              HttpSession session,
                              Model model) {
        String userId = (String) session.getAttribute(SESSION_USER_ID);
        System.out.println("🧪 현재 세션 userId: " + userId);

        if (userId == null) {
            return "redirect:/mapc";
        }

        String answer = mapChatService.askChatbot(userId, question);

        // ✅ 세션에서 이전 이력 가져오기 (고유 키 사용)
        List<Map<String, String>> history = (List<Map<String, String>>) session.getAttribute(SESSION_CHAT_HISTORY);
        if (history == null) {
            history = new ArrayList<>();
        }

        // ✅ 질문/답변 추가
        history.add(Map.of(
            "role", "user",
            "content", question,
            "timestamp", LocalDateTime.now().toString()
        ));
        history.add(Map.of(
            "role", "assistant",
            "content", answer,
            "timestamp", LocalDateTime.now().toString()
        ));

        // ✅ 세션 및 모델에 반영
        session.setAttribute(SESSION_CHAT_HISTORY, history);
        model.addAttribute("history", history);

        return "mapchat_JY";
    }

    @GetMapping("/mapc/history")
    public String chatHistory(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        String userId = userDetails.getUser().getUserId();
        model.addAttribute("history", mapChatService.loadChatHistory(userId));
        return "map_history_JY";
    }
}
