package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.example.demo.security.OAuth2SuccessHandler;
import com.example.demo.service.CustomOAuth2UserService;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {
	private final CustomOAuth2UserService customOAuth2UserService;
    private final OAuth2SuccessHandler oAuth2SuccessHandler;
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeRequests()
                .antMatchers("/", "/index", "/login", "/logout", "/register", "/find", "/find/**", "/css/**", "/js/**", "/images/**").permitAll()
                .anyRequest().authenticated()
            .and()
            .oauth2Login()
            	.loginPage("/index") // 모달 창 사용
            	.userInfoEndpoint()
                .userService(customOAuth2UserService) // 사용자 정보 처리할 서비스
            .and()
            	.successHandler(oAuth2SuccessHandler) // 로그인 성공 후 처리
            .and()
            .logout()
                .logoutSuccessUrl("/index")
                .invalidateHttpSession(true);

        return http.build();
    }
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

