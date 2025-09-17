# Ubuntu KakaoTalk Bottles 자동 설치 스크립트

Ubuntu 22.04에서 Bottles를 통해 카카오톡을 자동으로 설치하는 원샷 스크립트입니다.

## 개요

이 스크립트는 다음 작업을 자동화합니다:
- Flatpak + Bottles 설치
- 카카오톡 전용 Bottle 생성
- IME 레지스트리 수정 (한글 입력 지원)
- 한글 폰트 설치 및 설정
- Bottles CLI를 통한 카카오톡 설치 프로그램 실행

카카오톡 설치 UI는 여전히 수동으로 클릭해서 진행해야 합니다 (이 부분은 자동화할 수 없습니다).

## 사용 방법

### 1. 스크립트 다운로드 및 실행 권한 부여

```bash
chmod +x install_kakaotalk_bottles.sh
```

### 2. 스크립트 실행

```bash
./install_kakaotalk_bottles.sh
```

## 스크립트 동작 과정

1. **[1/7] Flatpak + Flathub 설정**: 시스템 업데이트 및 Flatpak 설치, Flathub 저장소 추가
2. **[2/7] Bottles 설치**: Flatpak을 통한 Bottles GUI 앱 설치
3. **[3/7] 카카오톡 Bottle 생성**: "KakaoTalk"이라는 이름의 application 환경 Bottle 생성 (win64 아키텍처)
4. **[4/7] 카카오톡 설치 파일 다운로드**: `~/Downloads/KakaoTalk_Setup.exe`로 자동 다운로드 시도
5. **[5/7] IME 수정**: Wine X11 드라이버에서 한글 입력을 위한 레지스트리 설정
6. **[6/7] 한글 폰트 설치**: 나눔 폰트를 시스템에 설치하고 Bottle에 복사
7. **[7/7] 카카오톡 설치 프로그램 실행**: Bottles를 통해 설치 GUI 실행

## 요구사항

- Ubuntu 22.04 (다른 버전에서도 동작할 수 있음)
- 인터넷 연결 (패키지 및 카카오톡 설치 파일 다운로드)
- sudo 권한

## 설치 완료 후

설치가 완료되면 카카오톡은 다음 경로에서 찾을 수 있습니다:
**Bottles → KakaoTalk → Programs**

### 폰트 문제 해결

만약 폰트가 이상하게 보인다면:
1. 카카오톡 설정을 열어주세요
2. 나눔 폰트를 선택해주세요

## 기술적 세부사항

- **Bottles CLI 사용법**: `flatpak run --command=bottles-cli com.usebottles.bottles`
- **사용된 CLI 명령어**: `new`, `run`, `reg`
- **설치 방식**: Flatpak/Flathub를 통한 Bottles 설치 (권장 방법)

## 참고 자료

- [Bottles CLI 문서](https://docs.usebottles.com)
- [Flathub - Linux용 앱](https://flathub.org)

## 문제 해결

### 카카오톡 설치 파일 다운로드 실패
스크립트가 카카오톡 설치 파일을 자동으로 다운로드하지 못하는 경우:
1. [카카오톡 공식 사이트](https://www.kakaocorp.com/page/service/service/KakaoTalk)에서 PC용 설치 파일을 수동으로 다운로드
2. `~/Downloads/KakaoTalk_Setup.exe`로 저장
3. 스크립트를 다시 실행

### 권한 오류
`sudo` 권한이 필요한 단계에서 오류가 발생하면 관리자 권한으로 스크립트를 실행해주세요.

## 라이선스

이 프로젝트는 자유롭게 사용, 수정, 배포할 수 있습니다.
