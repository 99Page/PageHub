//
//  DurationView.swift
//  PageHub
//
//  Created by 노우영 on 12/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct DurationConfig: Equatable {
    var progress: CGFloat
    let text: String
    let duration: TimeInterval
    var isPresented: Bool
    
    init(text: String, duration: TimeInterval, isPresented: Bool = false) {
        self.progress = 1.0
        self.text = text
        self.duration = duration
        self.isPresented = isPresented
    }
}

struct DurationViewModifier: ViewModifier {

    @Binding var config: DurationConfig
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $config.isPresented) {
                VStack {
                    DurationView(config: $config)
                }
                .presentationBackground(Color.clear)
                .presentationBackgroundInteraction(.enabled)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .transaction {
                $0.disablesAnimations = true
            }
    }
}

struct DurationView: View {
    
    @Binding var config: DurationConfig
    
    @State var isAppeared = false
    @State var show = false
    
    var body: some View {
        if isAppeared {
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
            .onAppear {
                withAnimation(.linear(duration: config.duration)) {
                    config.progress = 0
                } completion: {
                    withAnimation {
                        isAppeared = false
                    } completion: {
                        config.isPresented = false
                    }
                }

            }
            .onDisappear {
                config.progress = 1
            }
        } else {
            Color.clear
                .onAppear {
                    if !show {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isAppeared = true
                            show = true
                        }
                    }
                }
        }
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
}

#Preview {
    @Previewable
    @State var config = DurationConfig(text: "DurationView", duration: 2.5, isPresented: true)
    
    return DurationView(config: $config)
        .padding(.horizontal, 20)
}

#Preview("ViewModifier") {
    @Previewable
    @State var config = DurationConfig(text: "DurationView", duration: 2.5)
    
    return ScrollView {
        Button("Show duration view") {
            config.isPresented = true
        }
        .padding(.bottom, 100)
        .modifier(DurationViewModifier(config: $config))
    }
}
