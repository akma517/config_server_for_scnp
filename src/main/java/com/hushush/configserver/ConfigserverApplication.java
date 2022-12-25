package com.hushush.configserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer	// 이 서비스를 스프링 클라우드 컨피그 서비스로 활성화
public class ConfigserverApplication {
	public static void main(String[] args) {
		SpringApplication.run(ConfigserverApplication.class, args);
	}

}
