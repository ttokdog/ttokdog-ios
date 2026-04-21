import Foundation
import ComposableArchitecture

// MARK: - OnboardingFeature

/// 온보딩 플로우 coordinator
/// - enum State로 순차 플로우 관리 (한 번에 하나의 child만 활성)
/// - 튜토리얼 완료 시 delegate를 통해 AppFeature에 알림
@Reducer
public struct OnboardingFeature: Reducer {

    @ObservableState
    public enum State: Equatable {
        case tutorial(TutorialFeature.State)

        public init() {
            self = .tutorial(TutorialFeature.State())
        }
    }

    public init() {}

    public enum Action {
        case tutorial(TutorialFeature.Action)
        case delegate(Delegate)

        public enum Delegate {
            case onboardingCompleted
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tutorial(.delegate(.tutorialCompleted)):
                return .send(.delegate(.onboardingCompleted))

            case .tutorial, .delegate:
                return .none
            }
        }
        .ifCaseLet(\.tutorial, action: \.tutorial) {
            TutorialFeature()
        }
    }
}
