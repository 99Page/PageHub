//
//  DurationView.swift
//  PageHub
//
//  Created by 노우영 on 12/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct DurationConfig: Equatable {
    var progress: CGFloat = 1
    let text: String
    let duration: TimeInterval
    var isPresented: Bool = false
    
    private let initialProgress: CGFloat = 1
    
    init(text: String, duration: TimeInterval) {
        self.text = text
        self.duration = duration
        
        let initialProgress = self.initialProgress
        self.progress = initialProgress
    }
    
    
    mutating func resetProgress() {
        self.progress = initialProgress
    }
}

struct DurationView: View {
    
    @Binding var config: DurationConfig
    
    @State var isAppeared = false
    @State var show = false
    
    var body: some View {
        if isAppeared {
            activatedDurationView()
        } else {
            Color.clear
                .onAppear(perform: handleInitialAppearance)
        }
    }
    
    private func activatedDurationView() -> some View {
        VStack(spacing: 0) {
            Text(config.text)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.bottom, 6)
            
            remainTimeView()
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .padding(.horizontal, 10)
        .background(Color.blue)
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        .padding(.horizontal, 14)
        .transition(.scale)
        .onAppear(perform: startAnimation)
        .onDisappear { config.resetProgress() }
    }
    
    private func remainTimeView() -> some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.white)
                .frame(width: geometry.size.width * config.progress, height: 5) // 진행률 기반으로 너비 변경
                .offset(y: -6)
        }
        .frame(height: 5) // GeometryReader의 높이 설정
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: config.duration)) {
            config.progress = 0
        } completion: {
            hideView()
        }
    }
    
    private func hideView() {
        withAnimation {
            isAppeared = false
        } completion: {
            config.isPresented = false
        }
    }
    
    private func handleInitialAppearance() {
        guard !show else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isAppeared = true
            show = true
        }
    }
}

#Preview {
    @Previewable
    @State var config = DurationConfig(text: "DurationView", duration: 2.5)
    
    return DurationView(config: $config)
}
