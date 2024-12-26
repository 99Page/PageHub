//
//  PassthroughWindow.swift
//  PageHub
//
//  Created by 노우영 on 12/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI


class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // rootView: ``TransparentHostingController`` 에서 초기화한 `rootView`와 동일한 뷰.
        guard let view = rootViewController?.view,
              let rootView = view.subviews.first else {
            return nil
        }
        
        
        // 상호작용이 가능한 영역
        let hitPoint = convert(point, to: rootView)
        
        if view.bounds.contains(hitPoint) {
            return view.hitTest(hitPoint, with: event)
        } else {
            // NotificationView를 제외한 나머지 영역은 상호작용 불가능.
            // 아래 있는 윈도우로 상호작용을 넘김
            return nil
        }
    }
}
