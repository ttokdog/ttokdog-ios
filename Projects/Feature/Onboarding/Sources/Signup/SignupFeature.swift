import Foundation
import ComposableArchitecture


@Reducer
struct SignupFeature: Reducer {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        // 입력값
        public var id: String = ""
        public var password: String = ""
        public var passwordConfirm: String = ""
        public var email: String = ""
        public var nickname: String = ""
        
        // 아이디 중복확인
        public var idCheckResult: IDCheckResult? = nil
        public var isCheckingId: Bool = false
        
        // 비밀번호 표시
        public var isPasswordVisible: Bool = false
        public var isPasswordConfirmVisible: Bool = false
        
        
        // 닉네임 중복확인
        public var nicknameCheckResult: NicknameCheckResult? = nil
        public var isCheckingNickname: Bool = false
        
        // 아이디 형식
        public var isIdValid: Bool {
            let regex = #"^[a-z0-9]{6,15}$"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
        }
        
        // 비밀번호 형식
        public var isPasswordValid: Bool {
            let regex = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,20}$"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        }
        
        // 이메일 형식
        public var isEmailValid: Bool {
            let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
        }
        
        // 닉네임 형식
        public var isNicknameValid: Bool {
            let regex = #"^[가-힣a-zA-Z0-9]{1,10}$"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
        }
        
        // 회원가입 활성화
//        public var isSignUpEnabled: Bool {
//            isIdValid
//            && idCheckResult == .available
//            && isPasswordValid
//            && !isPasswordConfirmMismatch
//            && !passwordConfirm.isEmpty
//            && isEmailVerified
//            && isNicknameValid
//            && nicknameCheckResult == .available
//        }
        
        
        public init() {}
    }

    
    // MARK: - Action
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // 네비게이션
        case backButtonTapped
        
        // 아이디
        case checkDuplicateIdTapped
        case checkDuplicateIdResponse(IDCheckResult)
        case clearIdTapped
        
        
        // 비밀번호
        case togglePasswordVisibility
        case togglePasswordConfirmVisibility
        case clearPasswordTapped
        case clearPasswordConfirmTapped
        
        // 이메일
        case clearEmailTapped
        
        // 닉네임
        case checkDuplicateNicknameTapped
        case checkDuplicateNicknameResponse(NicknameCheckResult)
        case clearNicknameTapped
        
        // 회원가입
        case signUpTapped
        
    }

    // MARK: - Reducer
    
    public var body: some ReducerOf<Self> {

    }
    

    
    
    
    public enum IDCheckResult: Equatable {
        case available // 아이디 이용가능
        case duplicate // 아이디 중복
        case invalidFormat // 아이디 잘못된 형식
    }
    
    public enum NicknameCheckResult: Equatable {
        case available // 닉네임 이용가능
        case duplicate // 닉네임 중복
    }
    

}
