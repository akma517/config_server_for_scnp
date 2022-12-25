# 기본 도커파일 스크립트
# 스프링부트 마이크로서비스의 전체 JAR 파일을 복사한다.

# # 도커 런타임에 사용될 도커 이미지를 지정
# FROM openjdk:17-slim

# # 관리자 정보를 추가한다.
# LABEL maintainer = "hsu2112 <akma517@naver.com>"

# # 애플리케이션 JAR 파일을 추가한다. (dockerfile-maven-plugin에 설정된 JAR_FILE 변수를 정의한다.)
# ARG JAR_FILE

# # 애플리케이션 JAR를 도커 이미속 파일 시스템에 복사한다.
# COPY ${JAR_FILE} app.jar

# # JAR를 언패키징한다.
# RUN mkdir -p target/dependency && (cd target/dependency; jar -xf /app.jar)

# # 애플리케이션을 실행한다.
# ENTRYPOINT [ "java","-jar","/app.jar" ]


# 멀티스테이지 빌드 도커파일
# 스프링부트 애플리케이션의 실행에만 필요되는 것만 복사
# 생성할 도커 이미지를 최적화시킴
# 애플리케이션 실행에 필수 사항이 않은 것을 제외

# stage 1
# 컨테이너 자바 런타임 세팅 (build 라는 별칭을 달아줌)
FROM openjdk:17-slim as build

# 관리자 정보 추가
LABEL maintainer = "hsu2112 <akma517@naver.com>"

# 애플리케이션 JAR 파일을 추가한다. (dockerfile-maven-plugin에 설정된 JAR_FILE 변수를 정의한다.)
ARG JAR_FILE

# 애플리케이션 JAR를 도커 이미속 파일 시스템에 복사한다.
COPY ${JAR_FILE} app.jar

# JAR를 언패키징한다.
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf /app.jar)

# stage 2 (새로운 이미지는 스프링 부트 앱에 대한 통짜 JAR 파일 대신 여러 레이어로 구성된다.)
# 동등 자바 런타임 세팅
FROM openjdk:17-slim

# 볼륨 포인트 추가 
VOLUME /tmp

# 언패키징된 애플리케이셔늘 새 컨테이너에 복사
ARG DEPENDENCY=/target/dependency

COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

# 애플리케이션 실행
ENTRYPOINT [ "java", "-cp", "app:app/lib/*","com.hushush.configserver.ConfigserverApplication" ]             