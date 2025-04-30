package com.example.demo.songyi;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class HealthScoreDTO {
    private String fileName;
    private Number score;
    private String risk;
    @JsonProperty("top_features")  // ✅ JSON 키와 매핑
    private List<String> topFeatures;     // 🔹 SHAP 주요 요인
    private String explanation;           // 🔹 AI 해석 설명
    @JsonProperty("shap_image")
    private String shapImage;

}