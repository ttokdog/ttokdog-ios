import Foundation
import OSLog

// MARK: - LogCategory

/// 로그를 분류하는 카테고리.
/// Console.app에서 카테고리별 필터링이 가능하다.
///
/// 사용 예시:
/// ```swift
/// logger.info("API 요청 시작", category: .network)
/// logger.error("토큰 만료", category: .auth)
/// ```
public enum LogCategory: String {
    case network = "Network"
    case auth = "Auth"
    case ui = "UI"
    case data = "Data"
    case general = "General"
}

// MARK: - LoggerClient

/// OSLog 기반 로거.
///
/// ## 기본 사용법
/// ```swift
/// let logger = LoggerClient()
///
/// logger.debug("디버그 메시지")           // DEBUG 빌드에서만 출력
/// logger.info("유저 로그인 성공")          // 일반 정보
/// logger.warning("캐시 만료 임박")         // 경고
/// logger.error("네트워크 실패", category: .network)  // 에러 (privacy: .private)
/// logger.error(someError, category: .network)       // Error 객체 직접 전달
/// ```
///
/// ## 로그 레벨 가이드
/// | 레벨 | 용도 | privacy | 비고 |
/// |------|------|---------|------|
/// | debug | 개발 중 디버깅 | .public | DEBUG 빌드 전용 |
/// | info | 일반 운영 정보 | .public | |
/// | notice | 주목할 만한 이벤트 | .public | |
/// | warning | 잠재적 문제 | .public | |
/// | error | 오류 발생 | .private | 민감 정보 보호 |
/// | fault | 시스템 수준 심각한 오류 | .private | 민감 정보 보호 |
///
/// ## Console.app에서 확인
/// 1. Console.app 실행
/// 2. 좌측에서 시뮬레이터/디바이스 선택
/// 3. subsystem: `com.ttokdog` 또는 category 이름으로 필터링
///
/// ## privacy 참고
/// - `.public`: Console.app에서 메시지 원문이 그대로 보임
/// - `.private`: 디버거 미연결 시 `<private>`으로 마스킹됨 (error, fault에 적용)
public struct LoggerClient: Sendable {
    private let subsystem: String

    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.ttokdog") {
        self.subsystem = subsystem
    }

    private func logger(for category: LogCategory) -> Logger {
        Logger(subsystem: subsystem, category: category.rawValue)
    }

    /// DEBUG 빌드에서만 출력. Release에서는 완전히 제거됨.
    public func debug(_ message: String, category: LogCategory = .general) {
        #if DEBUG
        logger(for: category).debug("\(message, privacy: .public)")
        #endif
    }

    public func info(_ message: String, category: LogCategory = .general) {
        logger(for: category).info("\(message, privacy: .public)")
    }

    public func notice(_ message: String, category: LogCategory = .general) {
        logger(for: category).notice("\(message, privacy: .public)")
    }

    public func warning(_ message: String, category: LogCategory = .general) {
        logger(for: category).warning("\(message, privacy: .public)")
    }

    /// 에러 메시지에 유저 데이터, 토큰 등이 포함될 수 있어 privacy: .private 적용.
    public func error(_ message: String, category: LogCategory = .general) {
        logger(for: category).error("\(message, privacy: .private)")
    }

    /// Error 객체를 직접 전달. `String(reflecting:)`으로 상세 정보 출력.
    public func error(_ error: Error, category: LogCategory = .general) {
        logger(for: category).error("\(String(reflecting: error), privacy: .private)")
    }

    /// 시스템 수준의 심각한 오류. 앱이 정상 동작할 수 없는 상황에서 사용.
    public func fault(_ message: String, category: LogCategory = .general) {
        logger(for: category).fault("\(message, privacy: .private)")
    }
}
