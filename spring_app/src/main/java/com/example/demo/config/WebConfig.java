package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    // 추가적인 MVC 설정이 필요하면 여기에 작성
	// 송이 추가
	@Bean
	public RestTemplate restTemplate() {
	    HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	    factory.setConnectTimeout(5000);
	    factory.setReadTimeout(60000);

	    RestTemplate restTemplate = new RestTemplate(factory);
	    restTemplate.getMessageConverters().add(new org.springframework.http.converter.FormHttpMessageConverter());
	    restTemplate.getMessageConverters().add(new org.springframework.http.converter.json.MappingJackson2HttpMessageConverter());
	    return restTemplate;
	    }
}
