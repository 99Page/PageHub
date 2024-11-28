//
//  SymbolStyle.swift
//  PageHub
//
//  Created by 노우영 on 11/26/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SymbolStyle: Equatable, Identifiable {
    let id: UUID
    
    let symbol: SFSymbol
    let color: Color
    let animationEffect: AnimationEffect
    
    static func createStub(with id: UUID) -> SymbolStyle {
        SymbolStyle(id: id, symbol: .eraser, color: .black, animationEffect: .shake)
    }
    
    static var randomStyle: SymbolStyle {
        SymbolStyle(
            id: UUID(),
            symbol: .allCases.randomElement() ?? .eraser,
            color: Color.darkRandomColor,
            animationEffect: .allCases.randomElement() ?? .bounce
        )
    }
}
