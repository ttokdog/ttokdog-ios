import Foundation
import ComposableArchitecture

// MARK: - Response

/// 인증번호 검증 요청 결과
public enum VerifyResponse: Equatable, Sendable {
    /// 인증번호 불일치
    case mismatch
    /// 인증 성공 — 마스킹된 가입 아이디 동봉 (이메일로 전송됨)
    case successEmailSignup(maskedId: String)
    /// 인증 성공 — 이미 소셜 가입된 계정
    case successSocialSignup(provider: VerificationCodeFeature.SocialProvider)
    /// 입력 시도 횟수(5회) 초과 (서버 권위)
    case attemptExceeded
    /// 일일 인증 요청 횟수(10회) 초과 (서버 권위)
    case dailyExceeded
}

/// 인증번호 재전송 요청 결과
public enum ResendResponse: Equatable, Sendable {
    /// 재전송 성공
    case sent
    /// 재전송 횟수(5회) 초과
    case resendExceeded
    /// 일일 인증 요청 횟수(10회) 초과
    case dailyExceeded
}

// MARK: - Client

/// 인증번호 검증/재전송 의존성.
///
/// 백엔드 미연동 단계에서는 stub `liveValue`로 동작하며,
/// 실 연동 시 `Domain/Service` 프로토콜로 추출한 뒤 `Domain/Data` 구현으로 교체한다.
@DependencyClient
public struct VerificationCodeClient: Sendable {
    /// 인증번호 검증
    public var verify: @Sendable (_ email: String, _ code: String) async throws -> VerifyResponse
    /// 인증번호 재전송
    public var resend: @Sendable (_ email: String) async throws -> ResendResponse
}

extension VerificationCodeClient: DependencyKey {
    /// 1차 구현 단계 — 실제 백엔드 연동 전 stub.
    /// `123456`은 성공(이메일 가입), 그 외 6자리는 mismatch로 응답.
    public static let liveValue: VerificationCodeClient = .init(
        verify: { _, code in
            try? await Task.sleep(for: .seconds(1))
            switch code {
            case "123456": return .successEmailSignup(maskedId: "tto***")
            default:       return .mismatch
            }
        },
        resend: { _ in
            try? await Task.sleep(for: .seconds(1))
            return .sent
        }
    )

    public static let testValue = VerificationCodeClient()
}

public extension DependencyValues {
    var verificationCodeClient: VerificationCodeClient {
        get { self[VerificationCodeClient.self] }
        set { self[VerificationCodeClient.self] = newValue }
    }
}
