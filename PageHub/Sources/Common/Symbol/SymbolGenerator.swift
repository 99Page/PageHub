//
//  SymbolGenerator.swift
//  PageHub
//
//  Created by 노우영 on 11/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Dependencies
import Foundation

struct SymbolGenerator {
    var createSymbol: @Sendable (_ id: UUID) -> SymbolStyle
}

extension SymbolGenerator: DependencyKey {
    static var liveValue: SymbolGenerator {
        SymbolGenerator { _ in
                .randomStyle
        }
    }
    
    static var testValue: SymbolGenerator {
        SymbolGenerator { id in
                .createStub(with: id)
        }
    }
}

extension DependencyValues {
    var symbolGenerator: SymbolGenerator {
        get { self[SymbolGenerator.self] }
        set { self[SymbolGenerator.self] = newValue }
    }
}
