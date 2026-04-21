import Foundation
import ComposableArchitecture

// MARK: - TutorialFeature

/// 온보딩 튜토리얼 (3페이지 스와이프) child reducer
/// - OnboardingFeature의 첫 번째 단계로 동작
/// - 완료 시 delegate를 통해 OnboardingFeature에 알림
@Reducer
public struct TutorialFeature: Reducer {

    @ObservableState
    public struct State: Equatable {
        public var currentPage: Int = 0

        public var pages: [TutorialPage] = TutorialPage.allPages

        public var isLastPage: Bool {
            currentPage == pages.count - 1
        }

        public init() {}
    }

    public init() {}

    public enum Action {
        case pageChanged(Int)
        case skipTapped
        case startTapped
        case delegate(Delegate)

        public enum Delegate {
            case tutorialCompleted
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .pageChanged(page):
                state.currentPage = page
                return .none

            case .skipTapped, .startTapped:
                // TODO: 튜토리얼 완료 여부를 UserDefaults/KeyChain에 저장하여 재노출 방지
                return .send(.delegate(.tutorialCompleted))

            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - TutorialPage

public struct TutorialPage: Equatable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let subtitle: String

    public static let allPages: [TutorialPage] = [
        TutorialPage(
            id: 0,
            title: "우리 아이를 위한 생애 지출 계획,\n이제 똑독하게 준비해요",
            subtitle: "앞으로 들어갈 비용을 미리 확인하고 관리하여\n우리 아이와의 미래를 든든하게 대비해요."
        ),
        TutorialPage(
            id: 1,
            title: "잊기 쉬운 데일리 케어,\n놓치지 않고 꼼꼼하게",
            subtitle: "꼭 필요한 매일의 건강 기록과 일정을\n알림으로 놓치지 않게 챙겨드려요."
        ),
        TutorialPage(
            id: 2,
            title: "우리 아이에게 꼭 필요한 정보,\n내 주변에서 빠르게",
            subtitle: "내 주변 동물병원과 애견 동반 장소를 한눈에!\n동네 이웃 보호자와의 발자국 메모로\n생생한 동네 소식을 실시간으로 나눠요."
        ),
    ]
}
