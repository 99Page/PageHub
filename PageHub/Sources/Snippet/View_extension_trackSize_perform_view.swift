//
//  View + extensions.swift
//  PageHub
//
//  Created by 노우영 on 10/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension View {
    /// 뷰의 `CGSize`를 추적하여 클로저로 전달하는 메서드
    /// - Parameter perform: 뷰의 사이즈가 변경될 때 호출되는 클로저
    /// - Returns: 뷰의 사이즈 추적 기능이 추가된 뷰
    func trackSize(_ perform: @escaping (CGSize) -> Void) -> some View {
        self
            .background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self, perform: perform)
    }
}
