// ImageController_JY.java 추가 수정본
package com.example.demo.Controller;

import java.io.IOException;
import java.security.Principal;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dto.imageDTO_JY;
import com.example.demo.repository.UserRepository;
import com.example.demo.security.CustomUserDetails;
import com.example.demo.service.ChatService;
import com.example.demo.service.imageService_JY;
import com.example.demo.service.imagehist_JY;
import com.example.demo.vo.UserVO;

@Controller
public class ImageController_JY {
   
    @Autowired
    private imageService_JY imageService;

    @Autowired
    
    private imagehist_JY imagehist;
    @Autowired
    private UserRepository userRepository; // 👈 자동 주입

    
    @Autowired
    private ChatService chatService;

    @GetMapping("/diagnose")
    public String showDiagnosisPage() {
        return "image_JY"; // 이미지 진단 페이지
    }
    
    @GetMapping("/imagehistory/simple")
    public String imageHistory(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser != null) {
            model.addAttribute("imagehistory", imagehist.getimagehistoryByUser(loginUser.getUserId()));
            return "imagehistory_JY";
        }
        return "redirect:/chat";
    }

    @PostMapping("/diagnose") // 이미지 질환 예측
    public String diagnoseImage(@RequestParam("image") MultipartFile image,
                                @RequestParam("disease") String disease,
                                @RequestParam("user_id") String user_id,
                                @RequestParam("user_name") String user_name,
                                Model model) {
        try {
            Map<String, Object> result = imageService.getDiagnosisResult(image, disease,user_id,user_name);
            model.addAttribute("title", result.get("title"));
            model.addAttribute("user_id", result.get("user_id"));
            model.addAttribute("user_name", result.get("user_name"));
            model.addAttribute("diagnosis", result.get("diagnosis"));
            model.addAttribute("confidence", result.get("confidence"));
            model.addAttribute("resultImage", result.get("result_image"));
            model.addAttribute("allProbabilities", result.get("probabilities")); // 이름 수정
            model.addAttribute("fileName", image.getOriginalFilename());
            
            // 메시지 생성
            String diagnosisResult = result.get("diagnosis").toString();
            String responseMessage;
            
            if (disease.equals("eye")) {
                switch(diagnosisResult) {
                    case "cataract":
                        responseMessage = "백내장이 의심됩니다. 안과 전문의의 상담을 권장합니다.";
                        break;
                    case "diabetic_retinopathy":
                        responseMessage = "당뇨병성 망막병증이 의심됩니다. 빠른 시일 내에 안과 검진이 필요합니다.";
                        break;
                    case "glaucoma":
                        responseMessage = "녹내장이 의심됩니다. 안과 전문의의 진단이 필요합니다.";
                        break;
                    case "normal":
                        responseMessage = "정상으로 판단됩니다. 하지만 정기적인 안과 검진은 항상 중요합니다.";
                        break;
                    default:
                        responseMessage = "진단 결과: " + diagnosisResult;
                }
            } else if (disease.equals("Brain")) {
                switch(diagnosisResult) {
                    case "glioma":
                        responseMessage = "신경교종이 의심됩니다.";
                        break;
                    case "meningioma":
                        responseMessage = "수막종이 의심됩니다.";
                        break;
                    case "notumor":
                        responseMessage = "종양없음을 판단됩니다.";
                        break;
                    case "pituitary":
                        responseMessage = "뇌하수체로 의심됩니다.";
                        break;
                    default:
                        responseMessage = "진단 결과: " + diagnosisResult;
                }
            } else if (disease.equals("lc")) {
                switch(diagnosisResult) {
                    case "adenocarcinoma":
                        responseMessage = "폐 선암이 의심됩니다. 즉시 종양 전문의와 상담하세요.";
                        break;
                    case "large.cell.carcinoma":
                        responseMessage = "폐 대세포암이 의심됩니다. 즉시 종양 전문의와 상담하세요.";
                        break;
                    case "squamous.cell.carcinoma":
                        responseMessage = "폐 편평세포암이 의심됩니다. 즉시 종양 전문의와 상담하세요.";
                        break;
                    case "normal":
                        responseMessage = "폐 이상이 발견되지 않았습니다. 정기적인 검진을 유지하세요.";
                        break;
                    default:
                        responseMessage = "진단 결과: " + diagnosisResult;
                }
            } else {
                responseMessage = "진단 결과: " + diagnosisResult;
            }
            
            model.addAttribute("response", responseMessage);
        } catch (IOException e) {
            model.addAttribute("message", "이미지 분석 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            model.addAttribute("message", "FastAPI 서버와의 통신에 실패했습니다: " + e.getMessage());
            e.printStackTrace();
        }
        return "image_JY";
    }
    
    @GetMapping("/imagehistory")
    public String showImageHistory(@RequestParam(defaultValue = "0") int page,
                                   @RequestParam(defaultValue = "10") int size,
                                   Model model,
                                   Principal principal) {
        if (principal == null) {
            return "redirect:/login"; // 로그인 안 되어 있으면 로그인 페이지로
        }
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        String userId = userDetails.getUserId(); // 정확한 userId
        
        UserVO user = userRepository.findByUserId(userId); // 중복 문제 없음
        System.out.println("이미지 페이징된 이력 조회 시작: userId = " + userId);

        Pageable pageable = PageRequest.of(page, size);
        Page<imageDTO_JY> pageResult = imagehist.getimageHistoryPage(userId, pageable);

        model.addAttribute("imagehistory", pageResult.getContent());
        model.addAttribute("totalPages", pageResult.getTotalPages());
        model.addAttribute("currentPage", page);

        return "imagehistory_JY";
    }       
}