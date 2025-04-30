package jiyeon;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "user")
public class UserEntity_JY {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id")
    private String userId;
    
    private String password;
    @Column(name = "user_name")
    private String userName;
    private String email;

    // 필요한 필드만

    // 기본 생성자 + Getter/Setter
    public String getUserName() {
        return userName;
    }

    public String getUserId() {
        return userId;
    }

    
}

