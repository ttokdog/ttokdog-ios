import Foundation
import ComposableArchitecture


@Reducer
struct SignupFeature: Reducer {
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        // MARK: - 입력값
        public var id: String = ""
        public var password: String = ""
        public var passwordConfirm: String = ""
        public var email: String = ""
        public var nickname: String = ""
        
        // MARK: - 아이디
        public var idCheckResult: IDCheckResult? = nil
        public var isCheckingId: Bool = false
        
        // MARK: - 비밀번호
        public var isPasswordVisible: Bool = false
        public var isPasswordConfirmVisible: Bool = false
        
        // MARK: - 닉네임
        public var nicknameCheckResult: NicknameCheckResult? = nil
        public var isCheckingNickname: Bool = false
        
        
        // MARK: - 유효성 검사
        
        /// 아이디 형식 (6~15자, 영문 소문자/숫자)
        public var isIdValid: Bool {
            let regex = #"^[a-z0-9]{6,15}$"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
        }
      
        
        /// 비밀번호 길이 (8~20자)
        public var isPasswordLengthValid: Bool {
            (8...20).contains(password.count)
        }

        /// 비밀번호 특수문자 포함
        public var isPasswordContainsSpecialChar: Bool {
            let regex = #".*[!@#$%^&*].*"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        }
        
        /// 비밀번호 확인 불일치
        public var isPasswordConfirmMismatch: Bool {
            !passwordConfirm.isEmpty && password != passwordConfirm
        }
        
        
        // 이메일 형식
        public var isEmailValid: Bool {
            let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
        }
        
        /// 닉네임 형식 (1~10자, 한글/영문/숫자)
        public var isNicknameValid: Bool {
            let regex = #"^[가-힣a-zA-Z0-9]{1,10}$"#
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
        }
        

        
        
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
        BindingReducer()

        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
            case .backButtonTapped:
                return .none
            case .checkDuplicateIdTapped:
                return .none
            case .checkDuplicateIdResponse(_):
                return .none
            case .clearIdTapped:
                state.id = ""
                return .none
            case .togglePasswordVisibility:
                return .none
            case .togglePasswordConfirmVisibility:
                return .none
            case .clearPasswordTapped:
                state.password = ""
                return .none
            case .clearPasswordConfirmTapped:
                state.passwordConfirm = ""
                return .none
            case .clearEmailTapped:
                state.email = ""
                return .none
            case .checkDuplicateNicknameTapped:
                return .none
            case .checkDuplicateNicknameResponse(_):
                return .none
            case .clearNicknameTapped:
                state.nickname = ""
                return .none
            case .signUpTapped:
                return .none
            }
            
        }
        
        
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
