//
//  TransparentHostringController.swift
//  PageHub
//
//  Created by 노우영 on 12/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

class TransparentHostingController<Content: View>: UIHostingController<Content> {
    
    /// rootView: Generic 타입의 View
    /// view: UIHostingController가 갖는 뷰. view 내부에 rootView가 포함된다. 따라서 이후에 SwiftUI 뷰를 찾고 싶다면 view에 있는 subview를 뒤져야한다.
    override init(rootView: Content) {
        super.init(rootView: rootView)
        view.backgroundColor = .clear
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
