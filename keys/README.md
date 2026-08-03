# 🔐 앱 공장 키(Keys) 보관함

이 폴더는 보안이 가장 중요한 파일들을 로컬(자신의 컴퓨터)에만 보관하기 위한 전용 금고입니다. 
**이 폴더 안에 넣은 모든 파일은 자동으로 `.gitignore` 처리되어 절대 GitHub 원격 저장소에 올라가지 않습니다.** (단, 이 README 파일은 안내를 위해 올라갑니다.)

## 📦 넣어두어야 할 파일 목록 (규칙)

1. **`google-play-key.json`**
   - 역할: 구글 플레이 개발자 콘솔 API 접근 권한 키
   - 사용처: Fastlane에서 자동으로 앱을 스토어에 배포(`fastlane beta`, `fastlane release`)할 때 사용됩니다.

2. **`android-keystore.jks`** (또는 `.keystore`)
   - 역할: 안드로이드 앱 서명(Signing) 파일
   - 사용처: Android 앱 릴리즈 빌드 시 위조 방지를 위해 사용됩니다.

3. **`key.properties`**
   - 역할: JKS 파일의 비밀번호가 적힌 설정 파일
   - 사용처: `android/app/build.gradle`에서 자동으로 이 파일을 읽어들여 서명을 진행합니다.
   
---

### 📝 `key.properties` 작성 예시
```properties
storePassword=당신의스토어비밀번호
keyPassword=당신의키비밀번호
keyAlias=upload
storeFile=../../keys/android-keystore.jks
```
