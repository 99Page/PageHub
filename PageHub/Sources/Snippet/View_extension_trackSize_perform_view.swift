//
//  View + extensions.swift
//  PageHub
//
//  Created by 노우영 on 10/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension View {
    /// Tracks the `CGSize` of a view and passes it to the provided closure.
    /// - Parameter perform: A closure called whenever the size of the view changes.
    /// - Returns: A modified view that observes its size and triggers the given closure.
    func trackSize(_ perform: @MainActor @Sendable @escaping (CGSize) -> Void) -> some View {
        self
            .background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
                }
                
            )
            .onPreferenceChange(SizePreferenceKey.self) { size in
                Task { @MainActor in
                    perform(size)
                }
            }
    }
}
