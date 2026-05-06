import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - TutorialView

/// 튜토리얼 3페이지 스와이프 UI
/// - 1~2페이지: 인디케이터(중앙) + 건너뛰기(우측)
/// - 3페이지: 시작 버튼 + 인디케이터(중앙)
public struct TutorialView: View {
    @Bindable public var store: StoreOf<TutorialFeature>

    public init(store: StoreOf<TutorialFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $store.currentPage.sending(\.pageChanged)) {
                ForEach(store.pages) { page in
                    TutorialPageView(page: page)
                        .tag(page.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            bottomSection
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
        }
        .background(Color.gray50)
    }

    private var bottomSection: some View {
        VStack(spacing: 20) {
            startButton
                .opacity(store.isLastPage ? 1 : 0)

            ZStack {
                pageIndicator

                HStack {
                    Spacer()
                    skipButton
                        .opacity(store.isLastPage ? 0 : 1)
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: store.isLastPage)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<store.pages.count, id: \.self) { index in
                Circle()
                    .fill(index == store.currentPage ? Color.primary500 : Color.gray200)
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.25), value: store.currentPage)
            }
        }
    }

    // TODO: 똑독 시작하기 탭 시 튜토리얼 완료 후 이동할 화면 연결
    private var startButton: some View {
        PrimaryButton(title: "똑독 시작하기", height: 70) {
            store.send(.startTapped)
        }
    }

    // TODO: 건너뛰기 탭 시 튜토리얼 완료 후 이동할 화면 연결
    private var skipButton: some View {
        HStack {
            Spacer()
            Button {
                store.send(.skipTapped)
            } label: {
                Text("건너뛰기")
                    .typography(.body10)
                    .foregroundStyle(Color.gray400)
            }
        }
    }
}

// MARK: - TutorialPageView

/// 튜토리얼 개별 페이지 콘텐츠
struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: 12) {
            Text(page.title)
                .typography(.title1)
                .foregroundStyle(Color.gray900)
                .multilineTextAlignment(.center)

            Text(page.subtitle)
                .typography(.body4)
                .foregroundStyle(Color.gray600)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 81)
    }
}

#Preview {
    TutorialView(
        store: .init(
            initialState: TutorialFeature.State(),
            reducer: { TutorialFeature() }
        )
    )
}
