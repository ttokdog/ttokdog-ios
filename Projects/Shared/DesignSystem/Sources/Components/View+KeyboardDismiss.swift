import SwiftUI
import UIKit

public extension View {
    /// 빈 영역 탭 시 first responder를 resign하여 키보드를 내린다.
    ///
    /// 온보딩/입력 화면 등 텍스트 입력이 있는 화면에서 일관된 키보드 dismiss 동작을 보장하기 위해 사용한다.
    /// 입력 필드/버튼 등의 자체 gesture는 그대로 동작하며 빈 영역 탭에만 반응한다.
    ///
    /// ## 사용법
    /// ```swift
    /// VStack { ... }
    ///     .background(Color.gray50)
    ///     .dismissKeyboardOnTap()
    /// ```
    func dismissKeyboardOnTap() -> some View {
        onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }
}
