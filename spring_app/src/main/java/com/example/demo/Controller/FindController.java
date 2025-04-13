package com.example.demo.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/find")
@RequiredArgsConstructor
public class FindController {
    private final UserService userService;
    
    //find.jsp로 이동
    @GetMapping
    public String showFindPage() {
        return "find";
    }
    
    @PostMapping("/id")
    public String findId(@RequestParam String userName, @RequestParam String email, Model model) {
        String userId = userService.findUserId(userName, email);
        if (userId != null) {
            model.addAttribute("message", "아이디는 " + userId + " 입니다.");
        } else {
            model.addAttribute("error", "일치하는 회원 정보가 없습니다.");
        }
        return "find";
    }

    @PostMapping("/password")
    public String resetPassword(@RequestParam String userId, @RequestParam String email, RedirectAttributes ra) {
        String tempPassword = userService.resetPasswordAndReturn(userId, email);
        if (tempPassword != null) {
            ra.addFlashAttribute("message", "임시 비밀번호는 \"" + tempPassword + "\" 입니다. 로그인 후 비밀번호를 변경해주세요.");
        } else {
            ra.addFlashAttribute("error", "회원 정보를 찾을 수 없습니다.");
        }
        return "redirect:/find";
    }
}
