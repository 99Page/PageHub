//
//  SizePreferenceKey.swift
//  PageHub
//
//  Created by 노우영 on 11/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        
    }
}
