//package jiyeon;
//
//
//import java.util.List;
//
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.data.jpa.repository.Query;
//import org.springframework.data.repository.query.Param;
//
//public interface ChatRepository_JY extends JpaRepository<DiagnosisResultEntity_JY, Long> {
//	
//
//
//	@Query("SELECT d FROM DiagnosisResultEntity_JY d WHERE d.user.userName = :userName ORDER BY d.createdAt DESC")
//	List<DiagnosisResultEntity_JY> findAllChatsByUserName(@Param("userName") String userName);
//
//}
//
