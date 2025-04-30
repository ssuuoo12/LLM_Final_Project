package com.example.demo.Controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.example.demo.service.ChatService;
import com.example.demo.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final RestTemplate restTemplate = new RestTemplate();
    private final ChatService chatService;

    @Value("${fastapi.url}")
    private String FASTAPI_BASE_URL;

    @GetMapping("/history")
    public String chatHistory(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser != null) {
            model.addAttribute("chatHistory", chatService.getChatHistoryByUser(loginUser.getUserId()));
            return "history";
        }
        return "redirect:/chat";
    }
    @GetMapping("/chat")
    public String chat3() {
        return "chat";
    }
    /*
    @PostMapping("/chat/send")
    public String sendMessage(
            @RequestParam("message") String message,
            HttpSession session,
            Model model
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        String userId = loginUser.getUserId();
        String requestUrl = FASTAPI_BASE_URL + "/chat/chat";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        Map<String, String> request = Map.of("user_id", userId, "message", message);
        HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);

        String answer = "(응답을 불러오지 못했습니다)";
        try {
            // ✅ FastAPI 응답: {"response": "텍스트 답변"}
            ResponseEntity<Map> responseEntity = restTemplate.postForEntity(requestUrl, entity, Map.class);
            Map<String, Object> apiResponse = responseEntity.getBody();

            if (apiResponse != null && apiResponse.get("response") instanceof String) {
                answer = (String) apiResponse.get("response");

                // ✅ DB 저장
                chatService.saveChat(userId, message, answer);
            }

        } catch (Exception e) {
            System.err.println("❌ FastAPI 호출 실패: " + e.getMessage());
            answer = "FastAPI 호출 실패: " + e.getMessage();
        }

        // ✅ JSP에서 보여줄 질문/답변
        model.addAttribute("userMessage", message);
        model.addAttribute("botAnswer", answer);

        return "chat"; // chat.jsp 렌더링
    }
	*/
    @PostMapping(value = "/chat/send-ajax", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, String> sendAjaxMessage(
            @RequestBody Map<String, String> payload,
            HttpSession session
    ) {
        String userId = payload.get("user_id");
        String message = payload.get("message");

        String answer = "(응답 실패)";
        try {
            String requestUrl = FASTAPI_BASE_URL + "/chat/chat";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            Map<String, String> request = Map.of("user_id", userId, "message", message);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);

            ResponseEntity<Map> responseEntity = restTemplate.postForEntity(requestUrl, entity, Map.class);
            Map<String, Object> apiResponse = responseEntity.getBody();

            if (apiResponse != null && apiResponse.get("response") instanceof String) {
                answer = (String) apiResponse.get("response");

                // DB 저장
                chatService.saveChat(userId, message, answer);
            }

        } catch (Exception e) {
            answer = "FastAPI 호출 실패: " + e.getMessage();
        }

        return Map.of("response", answer);
    }


}
