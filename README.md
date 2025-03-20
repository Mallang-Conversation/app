# Mallang

이 레포지토리는 Android와 iOS 플랫폼을 지원하는 Flutter 애플리케이션입니다.

## 설치 방법

### 1. 레포지토리 복제하기

```bash
git clone https://github.com/Mallang-Conversation/app.git
```

### 2. 의존성 패키지 설치

```bash
flutter pub get
```

## 실행 방법

### Android에서 실행하기

1. Android 에뮬레이터 시작 또는 USB를 통해 실제 기기 연결
2. 다음 명령어 실행:

```bash
flutter run
```

### iOS에서 실행하기 (macOS 필요)

1. iOS 시뮬레이터 시작 또는 USB를 통해 실제 기기 연결
2. 다음 명령어 실행:

```bash
flutter run
```

## 빌드하기

### Android APK 빌드

```bash
flutter build apk
```

### iOS IPA 빌드 (macOS 필요)

```bash
flutter build ios
```

## 문제 해결

- Flutter 버전 확인: `flutter --version`
- Flutter 진단 도구 실행: `flutter doctor`
- 캐시 정리: `flutter clean`
