package util;

import java.io.InputStream;

import org.springframework.core.io.InputStreamResource;

public class MultipartInputStreamFileResource extends InputStreamResource {
	    private final String filename;
	    
	 public MultipartInputStreamFileResource(InputStream inputStream, String filename) {
// MultipartInputStreamFileResource : 파일 이름을 명확하게 전달하기 위해" 사용하는 클래스
        super(inputStream);
        this.filename = filename;
	    }

	    @Override
	    public String getFilename() {
	        return this.filename;
	    }

	    @Override
	    public long contentLength() {
	        return -1;  // unknown
	    }
	}

	
	

