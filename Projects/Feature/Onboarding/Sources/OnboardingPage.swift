//
//  OnboardingPage.swift
//  FeatureOnboarding
//
//  Created by 유지완 on 4/15/26.
//  Copyright © 2026 ttokdog. All rights reserved.
//

import Foundation

struct OnboardingPage: Equatable {
    /// 온보딩 타이틀
    let title: String
    /// 온보딩 하위타이틀
    let subtitle: String
    /// 마지막 페이지 여부 (true일 때 '똑독 시작하기' 버튼 표시)
    let isLast: Bool
}
