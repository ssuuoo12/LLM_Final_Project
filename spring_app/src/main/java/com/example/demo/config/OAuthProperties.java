package com.example.demo.config;

import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
@Primary
@ConfigurationProperties(prefix = "custom.oauth.google")
public class OAuthProperties {
    private String clientId;
    private String clientSecret;
    private String redirectUri;
    private List<String> scope;
}
