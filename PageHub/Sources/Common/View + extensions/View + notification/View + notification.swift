//
//  View + notification.swift
//  PageHub
//
//  Created by 노우영 on 12/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension View {
    func notification<Content: View>(
        config: Binding<NotificationConfig>,
        content: @escaping () -> Content
    ) -> some View {
        self
            .modifier(
                NotificationViewModifier(
                    config: config,
                    view: content
                )
            )
    }
}

struct NotificationConfig: Equatable {
    var isPresented = false
    var alignment: Alignment
    
    /// bottom 이외에는 모두 top으로 처리합니다.
    var adjustiveAlignment: Alignment {
        switch alignment {
        case .bottom:
            return .bottom
        default:
            return .top
        }
    }
}

/// 알림(Notification)을 화면에 표시하기 위한 ViewModifier입니다.
struct NotificationViewModifier<T: View>: ViewModifier {
    /// 알림의 표시 여부를 제어하는 바인딩 값입니다.
    @Binding var config: NotificationConfig

    /// 알림에 표시될 뷰를 생성하는 클로저입니다.
    var view: () -> T
    
    /// 알림을 보여주고 숨기기 위한 OverlayWindow 입니다.
    let overlayWindow: OverlayWindow

    init(config: Binding<NotificationConfig>,
         view: @escaping () -> T) {
        
        self._config = config
        self.view = view
        self.overlayWindow = OverlayWindow(isPresented: config.isPresented)
    }

    /// 원본 콘텐츠에 알림 표시 기능을 적용합니다.
    /// - Parameter content: 수정 대상 View(원본 콘텐츠)입니다.
    /// - Returns: 알림 표시 기능이 적용된 View를 반환합니다.
    func body(content: Content) -> some View {
        content
            .onChange(of: config.isPresented) { oldValue, newValue in
                if newValue {
                    overlayWindow.showNotification(content: notificatonView)
                } else {
                    overlayWindow.hideAllNotifications()
                }
            }
    }
    
    private func notificatonView() -> some View {
        VStack(spacing: 0) {
            if config.adjustiveAlignment == .bottom {
                Spacer()
            }
            
            view()
            
            if config.adjustiveAlignment == .top {
                Spacer()
            }
        }
    }
}

#Preview {
    
    @Previewable @State var config = NotificationConfig(alignment: .bottom)
    
    ScrollView {
        Button("Show notification") {
            config.isPresented.toggle()
        }
        
        Color.blue
            .opacity(0.4)
            .frame(height: 1200)
    }
    .notification(config: $config) {
        Text("Custom notification!")
    }
}
