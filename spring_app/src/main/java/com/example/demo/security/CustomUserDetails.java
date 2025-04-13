package com.example.demo.security;

import java.util.Collection;
import java.util.Collections;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.example.demo.vo.UserVO;

public class CustomUserDetails implements UserDetails {

    private final UserVO user;

    public CustomUserDetails(UserVO user) {
        this.user = user;
    }

    public UserVO getUser() {
        return user;
    }

    @Override
    public String getUsername() {
        return user.getUserName(); // 또는 user.getUserId()도 가능
    }

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(() -> "ROLE_USER");
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }
    @Override
    public boolean isEnabled() {
        return true;
    }
}
