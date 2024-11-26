//
//  Color + lightRandomColor.swift
//  PageHub
//
//  Created by 노우영 on 11/26/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension Color {
    static var lightRandomColor: Color {
        Color(
            red: Double.random(in: 0.7...1),
            green: Double.random(in: 0.7...1),
            blue: Double.random(in: 0.7...1)
        )
    }
    
    static var darkRandomColor: Color {
        let lowRange = Double.random(in: 0...0.3) // 낮은 값
        let highRange = Double.random(in: 0.4...0.8) // 중간 값
        
        // 랜덤으로 채널 선택
        return Color(
            red: Bool.random() ? lowRange : highRange,
            green: Bool.random() ? lowRange : highRange,
            blue: Bool.random() ? lowRange : highRange
        )
    }
}
