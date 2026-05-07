import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

public struct VerificationCodeView: View {
    @Bindable public var store: StoreOf<VerificationCodeFeature>

    public init(store: StoreOf<VerificationCodeFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(
                    title: "인증번호 입력",
                    onBack: { store.send(.backButtonTapped) }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        header
                            .padding(.top, 18)   // 네비게이션 바와의 간격
                        VerificationCodeInputField(
                            text: $store.code,
                            isError: store.inputState == .error
                        )
                        .padding(.top, 21)       // 헤더와의 간격
                        codeMismatchSlot         // 입력 필드 ↔ 인증 확인 버튼 사이 고정 46pt 슬롯
                        verifyButton
                        timerRow
                            .padding(.top, 24)   // 인증 확인 버튼과의 간격
                        resentNotice             // 남은 시간 라벨 아래 8pt
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .scrollDismissesKeyboard(.interactively)

                Spacer(minLength: 0)
            }
            .background(Color.gray50)
            .onAppear { store.send(.onAppear) }
            .dismissKeyboardOnTap()

            if let alert = store.alert {
                alertOverlay(for: alert)
            }
        }
        .onChange(of: store.alert == nil) { _, isClosed in
            // alert이 새로 뜨는 순간 키보드 내림 — alert이 자연스럽게 화면 정중앙에 표시되도록.
            if !isClosed {
                dismissKeyboard()
            }
        }
    }

    /// 현재 first responder를 resign하여 키보드를 내림.
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }

    // MARK: - Header

    /// 마스킹된 이메일은 body5, 안내 문구는 body8로 톤 분리.
    private var header: some View {
        (Text(store.maskedEmail).typographyText(.body5)
         + Text(" 으로\n발송된 인증번호를 입력해주세요.").typographyText(.body8))
            .foregroundStyle(Color.gray800)
            .typographyLineSpacing(.body8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Verify Button

    private var verifyButton: some View {
        PrimaryButton(title: "인증 확인", isEnabled: store.isVerifyEnabled) {
            store.send(.verifyTapped)
        }
    }

    // MARK: - Timer Row

    private var timerRow: some View {
        HStack(spacing: 0) {
            Text("남은 시간 \(store.formattedTime)")
                .typography(.body11)
                .foregroundStyle(Color.error)

            Spacer()

            Button {
                store.send(.resendTapped)
            } label: {
                Text("재전송")
                    .typography(.label1)
                    .foregroundStyle(store.isResendEnabled ? Color.primary500 : Color.gray400)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .overlay(
                        Capsule().stroke(
                            store.isResendEnabled ? Color.primary500 : Color.gray300,
                            lineWidth: 1
                        )
                    )
            }
            .disabled(!store.isResendEnabled)
        }
    }

    // MARK: - Inline Messages

    /// 입력 필드와 인증 확인 버튼 사이 고정 46pt 영역.
    /// 코드 불일치 메시지가 있을 때만 안에 표시되고, 메시지 유무에 따라 버튼 위치는 변하지 않는다.
    /// 글씨체/색상은 남은 시간 라벨과 동일(body11 + error). 좌측에 ⚠ 아이콘 동반.
    private var codeMismatchSlot: some View {
        ZStack(alignment: .leading) {
            Color.clear.frame(maxWidth: .infinity).frame(height: 46)
            if case .codeMismatch(let remaining) = store.bottomMessage {
                HStack(spacing: 7) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.error)
                    Text("인증번호를 정확히 입력해주세요. (\(remaining)회 남음)")
                        .typography(.body11)
                        .foregroundStyle(Color.error)
                }
            }
        }
    }

    /// 남은 시간 라벨 아래 8pt에 노출되는 재전송 안내 메시지..
    @ViewBuilder
    private var resentNotice: some View {
        if case .resent = store.bottomMessage {
            Text("인증번호가 재전송되었어요. 메일함을 확인해주세요")
                .typography(.body11)
                .foregroundStyle(Color.error)
                .padding(.top, 8)
        }
    }

    // MARK: - Alert Overlay

    @ViewBuilder
    private func alertOverlay(for alert: VerificationCodeFeature.AlertKind) -> some View {
        switch alert {
        case .timeExpired:
            CustomAlert(
                title: "인증 시간이 초과되었어요.\n다시 시도해주세요.",
                primaryButtonTitle: "확인",
                primaryAction: { store.send(.alertConfirmed) }
            )
        case .attemptExceeded:
            CustomAlert(
                title: "입력 횟수(5회)를 초과했어요.\n인증번호를 다시 요청해주세요.",
                primaryButtonTitle: "확인",
                primaryAction: { store.send(.alertConfirmed) }
            )
        case .resendExceeded:
            CustomAlert(
                title: "인증번호 재발송횟수(5회)를 초과했어요.\n24시간 뒤에 다시 시도하세요.",
                primaryButtonTitle: "돌아가기",
                primaryAction: { store.send(.alertConfirmed) }
            )
        case .dailyExceeded:
            CustomAlert(
                title: "일일 인증 요청(10회)를 초과했어요.\n24시간 뒤에 다시 시도하세요.",
                primaryButtonTitle: "돌아가기",
                primaryAction: { store.send(.alertConfirmed) }
            )
        case .successEmailSignup(let maskedId):
            CustomAlert(
                title: "이메일로 가입하신 아이디를 보냈어요.",
                description: "개인정보 보호를 위해 화면에는 일부만 표시해요.\n메일함에서 전체 아이디를 확인해주세요.",
                primaryButtonTitle: "로그인 하러가기",
                primaryAction: { store.send(.alertConfirmed) }
            ) {
                Text("( 아이디 : \(maskedId) )")
                    .typography(.body6)
                    .foregroundStyle(Color.primary500)
            }
        case .successSocialSignup(let provider):
            CustomAlert(
                title: "이미 \(provider.displayName)로 가입한 계정이에요.",
                description: "\(provider.displayName)로 로그인 해주세요.",
                primaryButtonTitle: "\(provider.displayName) 로그인",
                primaryAction: { store.send(.alertConfirmed) }
            )
        }
    }
}

// MARK: - Preview

#Preview("기본") {
    VerificationCodeView(
        store: .init(
            initialState: VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com"),
            reducer: { VerificationCodeFeature() }
        )
    )
}

#Preview("입력 중 (2자)") {
    VerificationCodeView(
        store: .init(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "22"
                return s
            }(),
            reducer: { VerificationCodeFeature() }
        )
    )
}

#Preview("재전송 활성 + 안내") {
    VerificationCodeView(
        store: .init(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "22"
                s.remainingSeconds = 120
                s.bottomMessage = .resent
                return s
            }(),
            reducer: { VerificationCodeFeature() }
        )
    )
}

#Preview("코드 오류") {
    VerificationCodeView(
        store: .init(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "225485"
                s.inputState = .error
                s.bottomMessage = .codeMismatch(remaining: 4)
                return s
            }(),
            reducer: { VerificationCodeFeature() }
        )
    )
}

#Preview("Alert - 시간 초과") {
    VerificationCodeView(
        store: .init(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .timeExpired
                return s
            }(),
            reducer: { VerificationCodeFeature() }
        )
    )
}

#Preview("Alert - 인증성공 이메일") {
    VerificationCodeView(
        store: .init(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .successEmailSignup(maskedId: "tto***")
                return s
            }(),
            reducer: { VerificationCodeFeature() }
        )
    )
}

#Preview("Alert - 인증성공 카카오") {
    VerificationCodeView(
        store: .init(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .successSocialSignup(provider: .kakao)
                return s
            }(),
            reducer: { VerificationCodeFeature() }
        )
    )
}
