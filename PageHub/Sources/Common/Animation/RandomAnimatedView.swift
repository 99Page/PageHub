//
//  RandomAnimatedView.swift
//  PageHub
//
//  Created by 노우영 on 11/26/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

enum AnimationEffect: CaseIterable {
    case expand
    case bounce
    case shake
    
    func perform(in state: Bool) -> Animation {
        switch self {
        case .expand:
            return .easeOut(duration: 0.5)
        case .bounce:
            return .spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)
                .repeatCount(4, autoreverses: true)
        case .shake:
            return .easeIn(duration: 0.3).repeatCount(3, autoreverses: true)
        }
    }
}

struct AnimatedView<Content: View> : View {
    
    @State private var isAnimating = false
    @State private var isAtRest: Bool = false
    
    let effect: AnimationEffect
    let content: () -> Content
    
    var body: some View {
        content()
            .rotationEffect(.degrees(isAtRest ? -10 : 0))
            .rotationEffect(.degrees(isAnimating ? 10 : -10))
            .animation(.linear(duration: 0.2), value: isAtRest)
            .animation(
                .easeInOut(duration: 0.2).repeatCount(3, autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                startBouncing()
            }
    }
    
    private func startBouncing() {
        isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isAtRest = true
        }
    }
}
