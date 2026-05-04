import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - Terms Agreement View
/// 약관동의 화면 View 입니다
public struct TermsAgreementView: View {
    
    // MARK: - Properties
    public var store: StoreOf<TermsAgreementFeature>
    
    // MARK: - init
    public init(store: StoreOf<TermsAgreementFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading) {
            
            // TODO: 상단 네비게이션바 구현하기
            
            Text("회원가입을 위해\n약관에 동의해주세요")
                .typographyText(.title1)
                .foregroundStyle(Color.gray900)
            
            
            Spacer()
            
            
            VStack(alignment: .leading, spacing: 13) {
                termsAgreementAllCheckRow
                termsAgreementRowList
            }
            
            termsAgreementSignupButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        
    }
    
    // MARK: - Terms Agreement All Check Row (전체동의)
    private var termsAgreementAllCheckRow: some View {
        HStack(spacing: 8) {
            Button(action: {
                store.send(.allCheckToggled)
            }, label: {
                Image.checkFill
                    .renderingMode(.template)
                    .foregroundStyle(store.isAllChecked ? Color.primary500 : Color.gray300)
            })
            
            Text("약관 전체동의")
                .typographyText(.body2)
                .foregroundStyle(Color.gray800)
        }
    }

    // MARK: - Terms Agreement Row List
    private var termsAgreementRowList: some View {
        VStack(spacing: 10) {
            TermsAgreementRowView(title: "[필수] 이용약관",
                                  isChecked: store.isTermsChecked,
                                  onCheck: { store.isTermsChecked = $0 },
                                  onDetailTapped: { })

            TermsAgreementRowView(title: "[필수] 개인정보 수집 및 이용 동의",
                                  isChecked: store.isPrivacyChecked,
                                  onCheck: { store.isPrivacyChecked = $0 },
                                  onDetailTapped: { })

            TermsAgreementRowView(title: "[필수] 개인정보 제3자 정보제공 동의",
                                  isChecked: store.isThirdPartyChecked,
                                  onCheck: { store.isThirdPartyChecked = $0 },
                                  onDetailTapped: { })

            TermsAgreementRowView(title: "[필수] 만 14세 이상 사용자",
                                  isChecked: store.isAgeChecked,
                                  onCheck: { store.isAgeChecked = $0},
                                  onDetailTapped: { })

            TermsAgreementRowView(title: "[선택] 위치정보 이용 동의",
                                  isChecked: store.isLocationChecked,
                                  onCheck: { store.isLocationChecked = $0 },
                                  onDetailTapped: { })

            TermsAgreementRowView(title: "[선택] 마케팅 수신 동의",
                                  isChecked: store.isMarketingChecked,
                                  onCheck: { store.isMarketingChecked = $0 },
                                  onDetailTapped: { })
        }
        .padding(.leading, 6)
    }

    // MARK: - terms Agreement Signup Button (동의하고 가입하기)
    private var termsAgreementSignupButton: some View {
        return Button(action: {
            // TODO: 동의하고 가입하기 액션 구현하기
            
        }, label: {
            Text("동의하고 가입하기")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(store.isRequiredAllChecked ?  Color.primary500 : Color.gray300)
                .foregroundStyle(Color.white)
                .typography(.buttonL)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        })
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
    
    
}

// MARK: - Preview
#Preview("기본 - 모두 미체크") {
    TermsAgreementView(
        store: .init(
            initialState: TermsAgreementFeature.State(),
            reducer: { TermsAgreementFeature() }
        )
    )
}


#Preview("필수 약관만 체크 - 가입 버튼 활성화") {
    TermsAgreementView(
        store: .init(
            initialState: {
                var state = TermsAgreementFeature.State()
                state.isTermsChecked = true
                state.isPrivacyChecked = true
                state.isThirdPartyChecked = true
                state.isAgeChecked = true
                return state
            }(),
            reducer: { TermsAgreementFeature() })
    )
}


#Preview("선택 약관만 체크") {
    TermsAgreementView(
        store: .init(
            initialState: {
                var state = TermsAgreementFeature.State()
                state.isLocationChecked = true
                state.isMarketingChecked = true
                return state
            }(),
            reducer: { TermsAgreementFeature() })
    )
    
}

#Preview("전체 동의") {
    TermsAgreementView(
        store: .init(
            initialState: {
                var state = TermsAgreementFeature.State()
                state.isAllChecked = true
                state.isTermsChecked = true
                state.isPrivacyChecked = true
                state.isThirdPartyChecked = true
                state.isAgeChecked = true
                state.isLocationChecked = true
                state.isMarketingChecked = true
                return state
            }(),
            reducer: { TermsAgreementFeature() })
    )
}
