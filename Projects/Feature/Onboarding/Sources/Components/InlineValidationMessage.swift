import SwiftUI
import SharedDesignSystem

// MARK: - ValidationMessageType

/// 인라인 유효성 검사 메시지의 종류를 나타냅니다.
enum ValidationMessageType {
    /// 입력값이 유효하지 않을 때 사용 (예: 중복 아이디, 형식 오류)
    case error
    /// 입력값이 유효할 때 사용 (예: 사용 가능한 아이디)
    case success

    /// 메시지 및 아이콘에 적용할 색상
    var color: Color {
        switch self {
        case .error: .error
        case .success: .success
        }
    }

    // TODO: 디자인시스템 아이콘 반영하기
    var iconName: String {
        switch self {
        case .error: "exclamationmark.circle.fill"
        case .success: "checkmark.circle.fill"
        }
    }
}

// MARK: - InlineValidationMessage

/// 텍스트 필드 하단에 표시되는 인라인 유효성 검사 메시지 컴포넌트입니다.
///
/// 아이콘과 메시지 텍스트를 가로로 배치하며, `ValidationMessageType`에 따라
/// 색상과 아이콘이 자동으로 결정됩니다.
///
/// ```swift
/// InlineValidationMessage(message: "사용 가능한 아이디입니다.", type: .success)
/// InlineValidationMessage(message: "이미 사용 중인 아이디입니다.", type: .error)
/// ```
public struct InlineValidationMessage: View {
    /// 표시할 유효성 검사 메시지
    let message: String
    /// 메시지 종류 (성공 / 오류)
    let type: ValidationMessageType

    public var body: some View {
        HStack(spacing: 7) {
            Image(systemName: type.iconName)
                .foregroundStyle(type.color)

            // TODO: 성공/실패 여부 색상 의논해야함.
            Text(message)
                .foregroundStyle(type.color)
                .typography(.error)
        }
    }
}


// MARK: - Preview

#Preview("Error") {
    InlineValidationMessage(message: "아이디 혹은 비밀번호가 일치하지 않아요.", type: .error)
        .padding()
}

#Preview("Success") {
    InlineValidationMessage(message: "사용 가능한 아이디입니다.", type: .success)
        .padding()
}
