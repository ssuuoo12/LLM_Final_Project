package com.example.demo.repository;

public class ChatRequestDiet_ha {

    private String disease;     // 질병명 (예: "당뇨", "고혈압" 등)
    private String mealTime;    // 식사 시간 (예: "아침", "점심", "저녁")
    private String userMessage; // 사용자가 직접 입력한 메시지(추가 정보 등)
	
    public ChatRequestDiet_ha(String disease, String mealTime, String userMessage) {
		super();
		this.disease = disease;
		this.mealTime = mealTime;
		this.userMessage = userMessage;
	}

	public String getDisease() {
		return disease;
	}

	public void setDisease(String disease) {
		this.disease = disease;
	}

	public String getMealTime() {
		return mealTime;
	}

	public void setMealTime(String mealTime) {
		this.mealTime = mealTime;
	}

	public String getUserMessage() {
		return userMessage;
	}

	public void setUserMessage(String userMessage) {
		this.userMessage = userMessage;
	}
	
}
