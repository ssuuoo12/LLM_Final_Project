package com.example.demo.Controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.dto.UserDTO;
import com.example.demo.security.CustomUserDetails;
import com.example.demo.service.GoogleOAuthService;
import com.example.demo.service.UserService;
import com.example.demo.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final GoogleOAuthService googleOAuthService;
    private final BCryptPasswordEncoder passwordEncoder;
    
    @GetMapping("/")
    public String chat() {
        return "index";
    }
    @GetMapping("/index")
    public String chat2() {
        return "index";
    }
    
    @PostMapping("/login")
    public String processLogin(@RequestParam String userId,
                                @RequestParam String password,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        UserVO user = userService.login(userId, password);
        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            session.setAttribute("loginUser", user); // 기존 세션 유지
            
            //변경된 인증 처리
            CustomUserDetails customUserDetails = new CustomUserDetails(user);
            Authentication auth = new UsernamePasswordAuthenticationToken(
                customUserDetails, null, customUserDetails.getAuthorities()
            );
            SecurityContextHolder.getContext().setAuthentication(auth);

            //forceChange가 true인 경우 알림 추가
            if (user.isForceChange()) {
                redirectAttributes.addFlashAttribute("forceChange", true);
            }
            System.out.println("로그인된 사용자 forceChange 상태: " + user.isForceChange());
            redirectAttributes.addFlashAttribute("welcomeMessage", user.getUserName() + "님 환영합니다!");
            return "redirect:/index";
        } else {
            redirectAttributes.addFlashAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "redirect:/index";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/index";
    }
    
    @GetMapping("/register")
    public String register() {
        return "register";
    }
    
    @PostMapping("/register")
    public String processRegister(@ModelAttribute UserDTO userDTO, RedirectAttributes ra) {
        boolean success = userService.register(userDTO);
        if (success) {
        	ra.addFlashAttribute("regmessage", "회원가입이 완료되었습니다!");
            return "redirect:/index"; // 성공 시 index 페이지로 리다이렉트
        } else {
        	ra.addFlashAttribute("regerrorMessage", "회원가입에 실패했습니다.");
            return "register"; // 실패 시 다시 회원가입 페이지로
        }
    }
    
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser != null) {
            UserVO userInfo = userService.getUserInfo(loginUser.getUserId());
            model.addAttribute("userInfo", userInfo);
        }
        return "mypage";
    }

    // 회원정보 수정
    @PostMapping("/mypage/update")
    public String update(@ModelAttribute UserDTO userDTO, HttpSession session, RedirectAttributes ra) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/chat";

        userDTO.setUserId(loginUser.getUserId());

        boolean success = userService.update(userDTO);
        if (success) {
        	userService.clearForceChange(loginUser.getUserId());
            session.setAttribute("loginUser", userService.getUserInfo(userDTO.getUserId()));
            ra.addFlashAttribute("message", "정보가 성공적으로 수정되었습니다.");
        } else {
            ra.addFlashAttribute("message", "수정할 내용이 없습니다.");
        }

        return "redirect:/mypage";
    }
    
    // 회원 탈퇴
    @PostMapping("/mypage/delete")
    public String delete(HttpServletRequest request, HttpSession session) {
        String userId = null;

        // 1. 일반 로그인 사용자
        if (session.getAttribute("loginUser") != null) {
            UserVO user = (UserVO) session.getAttribute("loginUser");
            userId = user.getUserId();
        } else {
            // 2. 소셜 로그인 사용자
            Principal principal = request.getUserPrincipal();
            if (principal != null) {
                userId = principal.getName(); // 구글 OAuth의 경우 이메일로 저장했을 것
            }
        }
        if (userId != null && userService.delete(userId)) {
            session.invalidate();
            return "redirect:/index";
        } else {
            return "redirect:/mypage?error=탈퇴에 실패했습니다";
        }
    }
}
