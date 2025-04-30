package jiyeon;


import java.util.ArrayList;
import java.util.List;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
public class SideController_JY {

	
private final ChatService_JY chatService;

public SideController_JY(ChatService_JY chatService) {
    this.chatService = chatService;
}


//@ModelAttribute("chatList")
//public List<ChatHistory> populateChatList(@AuthenticationPrincipal UserDetails userDetails) {
//    if (userDetails == null) return new ArrayList<>();
//    return chatService.getRecentChats(userDetails.getUsername());
//}
    
@ModelAttribute("chatList")
public List<ChatHistory_JY> populateChatList(@AuthenticationPrincipal UserDetails userDetails) {
    String username = userDetails.getUsername();
    System.out.println("🔍 현재 로그인한 사용자: " + username);

    List<ChatHistory_JY> chats = chatService.getRecentChats(username);
    System.out.println("📋 조회된 대화 수: " + chats.size());
    return chats;
}

}