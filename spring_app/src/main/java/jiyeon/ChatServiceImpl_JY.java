//package jiyeon;
//
//import java.time.LocalDateTime;
//import java.util.List;
//import java.util.stream.Collectors;
//
//import org.springframework.stereotype.Service;
//
//import lombok.RequiredArgsConstructor;
//
//@Service
//@RequiredArgsConstructor
//public class ChatServiceImpl_JY implements ChatService_JY {
//
//    private final ChatRepository_JY chatRepository;
//
//    @Override
//    public List<ChatHistory_JY> getRecentChats(String userName) {
//        return chatRepository.findAllChatsByUserName(userName)
//                .stream()
//                .map(chat -> new ChatHistory_JY(
//                        chat.getId(),
//                        chat.getTitle(),
//                        chat.getCreatedAt()
//                ))
//                .collect(Collectors.toList());
//    }
//
//    
//    
//    
//    
//}
//
