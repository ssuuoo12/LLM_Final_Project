package com.example.demo.service;
//Google OAuth 로그인으로 사용자 정보를 받아서,
//DB에 저장하거나 기존 유저를 불러와서 Security에 등록하는 역할.
import java.util.Map;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.example.demo.repository.UserRepository;
import com.example.demo.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        Map<String, Object> attributes = oAuth2User.getAttributes();

        String providerId = (String) attributes.get("sub"); // 구글은 "sub"
        String email = (String) attributes.get("email");
        String name = (String) attributes.get("name");

        UserVO user = userRepository.findByUserId(email);
        if (user == null) {
            // 자동 회원가입
            UserVO newUser = new UserVO();
            newUser.setUserId(email);
            newUser.setUserName(name);
            newUser.setEmail(email);
            newUser.setProvider("google");
            newUser.setProviderId(providerId);
            newUser.setRole("USER");
            userRepository.saveByOAuth(newUser); // 별도 메서드 구현 필요
        }

        return new DefaultOAuth2User(
            java.util.Collections.singleton(new SimpleGrantedAuthority("ROLE_USER")),
            attributes,
            "email"
        );
    }
}
