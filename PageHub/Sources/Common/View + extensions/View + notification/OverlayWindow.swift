//
//  OverlayWindow.swift
//  CaseStudies-SwiftUI
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI
import UIKit

class OverlayWindow {
    /// 오버레이용 UIWindow 인스턴스입니다. 알림 표시를 위한 별도의 윈도우를 생성합니다.
    private var window: UIWindow?
    
    /// 오버레이 윈도우의 표시 상태를 나타내는 Binding입니다.
    var isPresented: Binding<Bool>
    
    /// 숨겨야 할 알림의 식별자 목록입니다.
    var hideIds: Set<String> = []
    
    /// 오버레이 윈도우 객체를 생성합니다.
    /// - Parameter isPresented: 오버레이 윈도우의 표시 여부를 제어하는 Binding입니다.
    init(isPresented: Binding<Bool>) {
        self.isPresented = isPresented
    }
    
    @MainActor func setRootViewController<Content: View>(content: @escaping () -> Content) {
        UIView.transition(with: self.window!, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.window?.rootViewController = TransparentHostingController(rootView: content())
        }

    }
    
    /// 지정한 콘텐츠를 알림 형태로 화면에 표시합니다.
    /// - Parameters:
    ///   - content: 알림에 표시할 뷰 콘텐츠입니다.
    ///   - duration: 알림이 자동으로 사라지기까지의 시간(초)입니다. 기본값은 3초입니다.
    @MainActor func showNotification<Content: View>(@ViewBuilder content: () -> Content) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let window = PassthroughWindow(windowScene: scene)
        window.rootViewController = TransparentHostingController(rootView: content())
        window.windowLevel = .statusBar + 1
        window.makeKeyAndVisible()
        self.window = window
        
        let id = UUID().uuidString
        hideIds.insert(id)
    }
    
    /// 현재 표시된 모든 알림을 숨깁니다.
    @MainActor func hideAllNotifications() {
        hideIds.removeAll()
        window?.isHidden = true
        window = nil
        isPresented.wrappedValue = false
    }
    
    /// 지정한 식별자를 갖는 알림을 숨깁니다.
    /// - Parameter id: 숨길 알림의 고유 식별자입니다.
    @MainActor func hideNotification(id: String) {
        guard hideIds.contains(id) else { return }
        
        hideIds.remove(id)
        
        isPresented.wrappedValue = false
        window?.isHidden = true
        window = nil
    }
}
