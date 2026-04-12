# 똑독 iOS 아키텍처 가이드

## 개요

똑독(Ttokdog)은 **Tuist 기반 모듈러 아키텍처(TMA)** 로 구성된 iOS 앱입니다.
SwiftUI + TCA(The Composable Architecture)를 사용하며, 레이어별로 명확히 분리된 모듈 구조를 따릅니다.

> **현재 단계:** 아키텍처 셋업 완료, 앱 기능 개발 진입 전. Feature 모듈은 스텁 상태입니다.

### 기술 스택

| 항목 | 버전/비고 |
|------|----------|
| iOS Deployment Target | 18.0 |
| Swift | 6.0 |
| Xcode | 로컬은 Swift 6.0 / iOS 18.0 빌드 가능한 버전 사용, CI는 16.3 고정 |
| Tuist | `.mise.toml`에서 4.142.0 버전 고정 |
| UI Framework | SwiftUI |
| 상태 관리 | TCA (The Composable Architecture) |
| 테스트 | Swift Testing |

### Swift 6 주의사항

이 프로젝트는 Swift 6.0을 사용합니다. 모든 코드에서 아래 사항을 기본 전제로 개발합니다.

- `Sendable` 준수: actor 경계를 넘는 타입은 반드시 `Sendable`
- `@MainActor`: UI 관련 코드에 명시적 actor isolation
- TCA의 `Effect`, `DependencyClient` 등도 concurrency 규칙을 따름
- 컴파일러가 표시하는 concurrency 경고를 무시하지 않고 해결

---

## 프로젝트 시작하기

### 사전 준비

```bash
# Tuist 설치 (mise 사용)
mise install tuist

# 또는 직접 설치
curl -Ls https://install.tuist.io | bash
```

### 프로젝트 셋업

```bash
# 1. 외부 패키지 설치
tuist install

# 2. Xcode 프로젝트 생성
tuist generate

# 3. 생성된 워크스페이스 열기
open ttokdog.xcworkspace
```

### DEVELOPMENT_TEAM 설정

프로젝트 빌드를 위해 xcconfig에 팀 ID를 설정해야 합니다.

```
# xcconfigs/Debug.xcconfig (또는 Release.xcconfig)
DEVELOPMENT_TEAM_ID = YOUR_TEAM_ID
```

**동작 흐름:**
1. xcconfig 파일에 `DEVELOPMENT_TEAM_ID` 값 입력
2. `Configuration+.swift`가 xcconfig를 빌드 설정에 연결
3. `Project+Environment.swift`에서 `DEVELOPMENT_TEAM = $(DEVELOPMENT_TEAM_ID)`로 매핑
4. 모든 프로젝트/타깃이 해당 값을 상속

**xcconfigs는 `.gitignore`에 의해 커밋되지 않습니다.** `DEVELOPMENT_TEAM_ID` 등 민감한 빌드 설정값이 포함되기 때문입니다. 새 팀원은 로컬에서 `xcconfigs/` 디렉토리를 직접 생성하고 위 값을 입력해야 합니다.

CI 환경에서는 `CODE_SIGNING_ALLOWED=NO` + `CODE_SIGNING_REQUIRED=NO`로 서명을 비활성화하여 simulator build만 수행하므로 xcconfig가 불필요합니다. (`.github/workflows/ci.yml` 참고)

### 주요 명령어 (Makefile)

```bash
make install               # tuist install (SPM 의존성 설치)
make generate              # tuist generate
make setup                 # install + generate (처음 세팅 시)
make clean                 # 캐시/Derived/xcodeproj 전체 정리
make module                # 새 모듈 생성 (대화형 CLI)
make clean-submodule-changes  # 모듈 생성으로 변경된 등록 파일 복원
```

---

## 레이어 구조

```
App
 └── Feature
      └── Domain
           └── Core
                └── Shared
```

각 레이어는 **아래 레이어만** 참조할 수 있습니다. 같은 레이어 내 서브모듈 간 참조는 허용하되, 상위 레이어 참조는 금지합니다.

각 레이어에는 **우산(umbrella) 타깃**이 있습니다. 우산 타깃은 빌드 의존성을 집계하는 역할입니다. 상위 레이어에서 `.feature`, `.domain` 등으로 참조하면 해당 레이어의 모든 서브모듈이 빌드 그래프에 포함됩니다.

> 모듈 생성 CLI(`make module`)로 새 모듈을 추가하면 해당 레이어의 `{Layer}Exports.swift`에 `@_exported import`가 자동 등록됩니다. 기존 모듈의 Exports 파일은 아직 스텁 상태이며, 필요에 따라 정리합니다.

---

### App

앱의 진입점. `@main` 구조체와 Debug/Release 빌드 설정을 관리합니다.

```
Projects/App/
├── Project.swift
├── Sources/
│   └── TtokdogApp.swift        ← @main
├── Tests/Sources/               ← App 테스트
└── Resources/
```

- 의존성: `.feature` (Feature 우산)
- Debug/Release 타깃 분리, xcconfig로 환경변수 주입

---

### Feature

화면 단위 기능 모듈. 각 Feature는 **TCA Reducer + SwiftUI View**로 구성됩니다.

```
Projects/Feature/
├── Project.swift               ← Feature 우산 (빌드 의존성 집계)
├── Sources/FeatureExports.swift
├── Splash/
│   ├── Project.swift
│   ├── Sources/
│   │   ├── SplashFeature.swift  ← @Reducer
│   │   └── SplashView.swift     ← SwiftUI View
│   └── Tests/Sources/
│       └── SplashTests.swift
├── Common/                     ← 공통 UI 유틸 (TCA 없음)
├── Onboarding/
├── Home/
├── Profile/
├── Plan/                       ← 댕플랜 탭
└── Map/                        ← 동네산책 탭
```

**의존성 규칙:**
- 일반 Feature: `.domain` + `.shared(sources: .DesignSystem)` + `.shared(sources: .ThirdParty)`
- 인증 Feature: 위 + `.shared(sources: .ThirdPartyAuth)` (현재: Onboarding)
- Common: `.shared(sources: .DesignSystem)` + `.shared(sources: .Util)` (Domain 불필요)

**Feature 파일 구조 (실제 코드):**

```swift
// SplashFeature.swift
import Foundation
import ComposableArchitecture

@Reducer
public struct SplashFeature: Reducer {

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public init() {}

    public enum Action {
        case onAppear
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
```

```swift
// SplashView.swift
import SwiftUI
import ComposableArchitecture

public struct SplashView: View {
    @Bindable public var store: StoreOf<SplashFeature>

    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Splash")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

#Preview {
    SplashView(
        store: .init(
            initialState: SplashFeature.State(),
            reducer: { SplashFeature() }
        )
    )
}
```

---

### Domain

비즈니스 로직 레이어. Entity, Service, Data 세 모듈로 구성됩니다.

```
Projects/Domain/
├── Project.swift               ← Domain 우산
├── Entity/                     ← 순수 데이터 모델
│   ├── Project.swift
│   ├── Sources/
│   └── Tests/
├── Service/                    ← 비즈니스 인터페이스 (프로토콜)
│   ├── Project.swift
│   ├── Sources/
│   └── Tests/
└── Data/                       ← 구현체 (DTO, Mapper, Repository 구현)
    ├── Project.swift
    ├── Sources/
    └── Tests/
```

**의존성 규칙:**
| 모듈 | 의존 | 역할 |
|------|------|------|
| Entity | 없음 | 순수 모델 (struct/enum) |
| Service | Entity | 비즈니스 유스케이스 프로토콜 정의 |
| Data | Entity + Service + Core(Network, Repository) | Service 프로토콜 구현, DTO 변환 |

**설계 원칙:**
- Service는 **순수 인터페이스 모듈** — Core에 의존하지 않음
- Data가 Service 프로토콜을 구현하면서 구체적인 Core 모듈에 의존
- Entity는 어떤 레이어에도 의존하지 않는 최하위 모듈

---

### Core

기술 인프라 레이어. 비즈니스 로직과 분리된 순수 기술 모듈입니다.

```
Projects/Core/
├── Project.swift               ← Core 우산
├── Network/                    ← HTTP 클라이언트
├── KeyChain/                   ← 보안 저장소 (토큰 등)
├── UserDefault/                ← 일반 설정 저장소
├── Repository/                 ← 데이터 접근 추상화
└── JWT/                        ← JWT 디코딩/검증
```

**의존성 규칙:**
- 모든 Core 서브모듈: `dependencies: []` (독립적)
- 필요한 Shared 모듈이 있으면 개별적으로 추가 (예: `.shared(sources: .Logger)`)
- Core 서브모듈끼리의 의존은 허용하되 최소화

---

### Shared

모든 레이어에서 공유하는 횡단 관심사 모듈입니다.

```
Projects/Shared/
├── Project.swift               ← Shared 우산 (DesignSystem, Util, Logger)
├── DesignSystem/               ← 디자인 토큰, 공통 UI 컴포넌트
│   ├── Sources/
│   └── Resources/              ← 에셋 카탈로그, 폰트
├── Util/                       ← 순수 유틸리티, Extension
├── Logger/                     ← OSLog 기반 로깅
├── ThirdParty/                 ← 전역 외부 라이브러리 (TCA, NukeUI)
└── ThirdPartyAuth/             ← 인증 SDK (Kakao, Google)
```

**중요: ThirdParty / ThirdPartyAuth는 Shared 우산에 포함되지 않습니다.**

Shared 우산(`.shared`)은 DesignSystem, Util, Logger만 포함합니다.

| 모듈 | 포함 라이브러리 | 용도 |
|------|--------------|------|
| ThirdParty | TCA, NukeUI | 전역 (모든 Feature에서 사용) |
| ThirdPartyAuth | KakaoSDKAuth, KakaoSDKUser, GoogleSignIn | 인증 Feature에서만 사용 |

- 모든 Feature는 `.shared(sources: .ThirdParty)`로 TCA/NukeUI를 사용
- 인증이 필요한 Feature만 추가로 `.shared(sources: .ThirdPartyAuth)` 선언 (현재: Onboarding)

---

## 서드파티 의존성

### 패키지 선언 위치

`Tuist/Package.swift`에서 모든 외부 패키지의 URL과 최소 버전 제약을 관리합니다.

### 패키지 최소 버전 제약

| 패키지 | 최소 버전 | 용도 |
|--------|----------|------|
| swift-composable-architecture | 1.17.0 | TCA 상태 관리 |
| Nuke | 12.9.0 | 이미지 로딩 (NukeUI) — Swift 6 대응 최소 버전 |
| kakao-ios-sdk | 2.22.0 | 카카오 소셜 로그인 |
| GoogleSignIn-iOS | 9.0.0 | 구글 소셜 로그인 — Swift 6 완전 지원 |

실제 resolve된 버전은 `Tuist/Package.resolved`에서 확인할 수 있습니다.

### 버전 선택 근거

| 패키지 | 최소 버전 | 근거 |
|--------|----------|------|
| swift-composable-architecture | 1.17.0 | TCA 1.17.0부터 Swift 6 strict concurrency 완전 지원 |
| Nuke | 12.9.0 | 12.9.0에서 Swift 6 Sendable 준수 완료. 12.0.0~12.8.x는 concurrency 경고 발생 |
| kakao-ios-sdk | 2.22.0 | SDK가 아직 Swift 6 미대응(swift-tools-version: 5.3). 최소 버전을 올려도 Swift 6 효과 없음 |
| GoogleSignIn-iOS | 9.0.0 | 9.0.0에서 Swift 6 완전 지원. 8.x는 strict concurrency 미대응 |

### Swift 6 호환성

| 라이브러리 | Swift 6 대응 | 비고 |
|-----------|:----------:|------|
| TCA 1.17.0+ | ✅ | 완전 지원 |
| Nuke 12.9.0+ | ✅ | 완전 지원 |
| GoogleSignIn 9.0.0+ | ✅ | 완전 지원 |
| Kakao SDK 2.x | ⚠️ | SDK 자체가 Swift 5 모드로 컴파일되어 빌드는 가능하나, 우리 코드에서 SDK 타입을 actor 경계에서 사용할 때 Sendable 경고 발생 가능. `@preconcurrency import`로 억제 가능 |

### re-export 정책

| 라이브러리 | `@_exported` | 사용 방식 |
|-----------|:---:|----------|
| ComposableArchitecture | O | ThirdParty에서 전역 re-export |
| NukeUI | X | 사용하는 모듈에서 `import NukeUI` 직접 |
| KakaoSDKAuth/User | X | ThirdPartyAuth 모듈에서 관리, 사용처에서 직접 import |
| GoogleSignIn | X | ThirdPartyAuth 모듈에서 관리, 사용처에서 직접 import |
| Apple Sign-In | - | `import AuthenticationServices` (SDK 불필요) |

### 외부 의존성 추가 방법

1. `Tuist/Package.swift`에 `.package(url:from:)` 추가
2. `tuist install` 실행
3. 사용할 모듈의 `Project.swift`에 `.external(name: "패키지명")` 의존성 추가
4. 전역 re-export가 필요한 경우에만 `ThirdPartyExports.swift`에 `@_exported import` 추가
5. `tuist generate` 실행

---

## 의존성 흐름도

```
Feature/Home
  → .domain                          비즈니스 로직
  → .shared(sources: .DesignSystem)  UI 컴포넌트
  → .shared(sources: .ThirdParty)    TCA, NukeUI

Feature/Onboarding
  → .domain                          비즈니스 로직
  → .shared(sources: .DesignSystem)  UI 컴포넌트
  → .shared(sources: .ThirdParty)    TCA, NukeUI
  → .shared(sources: .ThirdPartyAuth) Kakao/Google 인증

Domain/Service
  → .domain(sources: .Entity)        순수 인터페이스

Domain/Data
  → .domain(sources: .Entity)        모델
  → .domain(sources: .Service)       인터페이스 구현
  → .core(sources: .Network)         HTTP 통신
  → .core(sources: .Repository)      데이터 접근

Core/Network
  → (없음)                           독립적

Shared 우산
  → DesignSystem + Util + Logger     ThirdParty 제외
```

---

## 새 모듈 추가하기

### 대화형 CLI 사용

```bash
make module
```

이 저장소는 `Tuist/Templates/` 기반 scaffold를 사용하지 않습니다.
`Scripts/GenerateModule/` 에 있는 커스텀 Swift CLI가 파일 생성과 등록 작업을 직접 수행합니다.

실행하면 레이어, 모듈명, Tests/Example 포함 여부를 묻는 대화형 프롬프트가 나타납니다.

### 자동 생성되는 것

1. `Projects/{Layer}/{ModuleName}/` 디렉토리 + 소스 파일
2. `Projects/{Layer}/{ModuleName}/Project.swift` (레이어별 기본 의존성 포함)
3. `Plugins/DependencyPlugin/ProjectDescriptionHelpers/Module.swift`에 enum case 등록
4. 레이어 우산 `Project.swift`에 서브모듈 의존 추가
5. 레이어 `{Layer}Exports.swift`에 `@_exported import` 라인 자동 추가

Feature 레이어의 경우 TCA 보일러플레이트(`{ModuleName}Feature.swift` + `{ModuleName}View.swift`)가 자동 생성됩니다.

### 레이어별 생성 기본값

| 레이어 | 기본 의존성 | Tests 기본 | TCA 보일러플레이트 |
|--------|-----------|:---:|:---:|
| Feature | `.domain`, `.shared(DesignSystem)`, `.shared(ThirdParty)` + 필요 시 `.shared(ThirdPartyAuth)` | Y | O (Feature + View) |
| Domain | `.domain(sources: .Entity)` | Y | X |
| Core | 없음 | Y | X |
| Shared | 없음 | N | X |

> Domain의 기본값은 Service 역할(인터페이스)에 맞춰져 있습니다.
> Data 역할(구현체)의 모듈을 만드는 경우 생성 후 `Project.swift`에서 의존성을 수동 조정하세요.

### 생성 후 할 일

```bash
# 모듈 생성 후 반드시 실행
tuist generate
```

---

## 로깅

`SharedLogger` 모듈에서 OSLog 기반 로거를 제공합니다.

### 사용법

```swift
import SharedLogger

let logger = LoggerClient()

logger.debug("디버그 메시지", category: .network)    // DEBUG 빌드에서만 출력
logger.info("정보 메시지", category: .auth)
logger.notice("주목할 이벤트", category: .general)
logger.warning("경고", category: .data)
logger.error("에러 메시지", category: .ui)
logger.error(someError, category: .network)          // Error 타입 직접 전달
logger.fault("치명적 오류", category: .general)       // 시스템 레벨 기록
```

### 카테고리

| 카테고리 | 용도 |
|---------|------|
| `.network` | API 호출, 응답, 네트워크 에러 |
| `.auth` | 인증, 토큰, 로그인/로그아웃 |
| `.ui` | UI 이벤트, 화면 전환, 렌더링 |
| `.data` | 데이터 저장, 캐시, 변환 |
| `.general` | 기본값, 분류 불명확한 로그 |

---

## 테스트

Swift Testing 프레임워크를 사용합니다.

```swift
import Testing
@testable import FeatureSplash

struct SplashTests {
    @Test func example() {
        #expect(true)
    }
}
```

### 테스트 타깃이 있는 모듈

- App: iOS(Debug) 테스트
- Feature: Splash, Onboarding, Home, Profile, Plan, Map
- Domain: Entity, Service, Data
- Core: Network, KeyChain, UserDefault, Repository, JWT

---

## 빌드 설정

### 환경 분리

| 설정 | Debug | Release |
|------|-------|---------|
| xcconfig | `xcconfigs/Debug.xcconfig` | `xcconfigs/Release.xcconfig` |
| 앱 이름 | Ttokdog-Debug | Ttokdog |
| Bundle ID | com.ttokdog.Debug | com.ttokdog.app |

---

## CI/CD

### GitHub Actions — PR 빌드 체크

`main` 브랜치로의 PR이 생성되면 자동으로 빌드 검증이 실행됩니다.

**워크플로우:** `.github/workflows/ci.yml`

| 항목 | 설정 |
|------|------|
| 트리거 | `pull_request` → main, `workflow_dispatch` |
| Runner | `macos-15` |
| Xcode | 16.3 고정 (`xcode-select`) |
| Tuist | `.mise.toml` 버전 자동 사용 (`jdx/mise-action`) |
| 타임아웃 | 30분 |
| Scheme | `Ttokdog-Debug` |
| 코드 서명 | 비활성화 (simulator 빌드) |

**캐싱:** `Tuist/.build` 디렉토리를 `Package.swift` + `Package.resolved` 해시로 캐싱합니다.

**동시성 제어:** 같은 PR에서 새 push가 오면 이전 빌드를 자동 취소합니다.

### 브랜치 보호

`main` 브랜치에 GitHub Repository Ruleset이 적용되어 있습니다.

| 규칙 | 설정 |
|------|------|
| Required status check | `build` (CI 통과 필수) |
| Required reviews | 0명 (리뷰 대기 없이 머지 가능하도록) |
| Dismiss stale reviews | false |
| Require up-to-date branch | false |

> 이 설정은 GitHub 서버(Repository Rulesets)에서 관리됩니다. 리뷰 프로세스를 강화할 필요가 생기면 Required reviews를 조정합니다.

---

## 문제 해결

### 프로젝트가 열리지 않거나 빌드 에러가 나는 경우

```bash
# 전체 정리 후 재생성
make clean
tuist install
tuist generate
```

### 모듈 생성 후 빌드 에러

```bash
# 모듈 생성으로 변경된 등록 파일 복원
make clean-submodule-changes

# 또는 프로젝트 재생성
tuist generate
```

### xcodeproj/xcworkspace가 꼬인 경우

```bash
# 모든 생성 파일 제거 후 재생성
make clean
tuist generate
```

---

## 프로젝트 구조 전체 트리

```
ttokdog-ios/
├── Makefile
├── Workspace.swift
├── Tuist.swift
├── Tuist/
│   ├── Package.swift                            ← 외부 패키지 선언
│   └── ProjectDescriptionHelpers/               ← Tuist 타깃 템플릿
│       ├── Project+Template.swift
│       └── DependencyDescriptionHelpers/
│           ├── SourceFileList+Template.swift
│           ├── Target+Template.swift
│           └── Target+Template/
│               ├── Target+App.swift
│               ├── Target+Feature.swift
│               ├── Target+Domain.swift
│               ├── Target+Core.swift
│               └── Target+Shared.swift
├── xcconfigs/
│   ├── Debug.xcconfig
│   └── Release.xcconfig
├── Plugins/
│   └── DependencyPlugin/
│       └── ProjectDescriptionHelpers/
│           ├── Module.swift                     ← 모듈 enum 정의
│           ├── TargetDependency+Modules.swift
│           ├── Path/Path+Module.swift
│           └── Environment/
│               └── Project+Environment.swift
├── Scripts/
│   └── GenerateModule/                          ← 모듈 생성 커스텀 CLI
├── Projects/
│   ├── App/
│   │   ├── Project.swift
│   │   ├── Sources/TtokdogApp.swift
│   │   └── Tests/Sources/
│   ├── Feature/
│   │   ├── Project.swift                        ← 우산
│   │   ├── Splash/
│   │   ├── Common/
│   │   ├── Onboarding/
│   │   ├── Home/
│   │   ├── Profile/
│   │   ├── Plan/
│   │   └── Map/
│   ├── Domain/
│   │   ├── Project.swift                        ← 우산
│   │   ├── Entity/
│   │   ├── Service/
│   │   └── Data/
│   ├── Core/
│   │   ├── Project.swift                        ← 우산
│   │   ├── Network/
│   │   ├── KeyChain/
│   │   ├── UserDefault/
│   │   ├── Repository/
│   │   └── JWT/
│   └── Shared/
│       ├── Project.swift                        ← 우산 (ThirdParty/ThirdPartyAuth 제외)
│       ├── DesignSystem/
│       ├── Util/
│       ├── Logger/
│       ├── ThirdParty/
│       └── ThirdPartyAuth/
└── docs/
    └── ARCHITECTURE.md                          ← 이 문서
```

---

## 향후 계획

- [x] ThirdParty 모듈 분리 완료 (ThirdParty: TCA+NukeUI / ThirdPartyAuth: Kakao+Google)
- [x] Feature 모듈 추가 (Plan: 댕플랜, Map: 동네산책 완료 / 마이페이지는 Profile로 기존 생성됨)
- [ ] App Coordinator / Root Reducer 구현
- [ ] DesignSystem 토큰 및 컴포넌트 구현
