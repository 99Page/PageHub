//
//  SymbolStyle.swift
//  PageHub
//
//  Created by 노우영 on 11/26/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SymbolStyle: Equatable, Identifiable {
    static func == (lhs: SymbolStyle, rhs: SymbolStyle) -> Bool {
        lhs.id == rhs.id
        && lhs.symbol == rhs.symbol
        && lhs.color == rhs.color
    }
    
    let id: UUID
    
    let symbol: SFSymbol
    let color: Color
    var effectValue = 0
    
    static func createStub(with id: UUID) -> SymbolStyle {
        SymbolStyle(id: id, symbol: .eraser, color: .black)
    }
    
    static var randomStyle: SymbolStyle {
        SymbolStyle(
            id: UUID(),
            symbol: .allCases.randomElement() ?? .eraser,
            color: Color.darkRandomColor
        )
    }
}
