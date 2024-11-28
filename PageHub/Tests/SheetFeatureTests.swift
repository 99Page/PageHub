//
//  SheetFeatureTests.swift
//  PageHubTests
//
//  Created by 노우영 on 11/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import Testing
import ComposableArchitecture
@testable import PageHub

struct SheetFeatureTests {

    @Test
    func testShowSheetButtonTapped_ShouldPresentSymbolView() async {
        let store = await createTestStore()
        
        await store.send(.showSheetButtonTapped) {
            $0.symbol = SymbolFeature.State()
        }
    }
    
    @Test
    func testMinusButtonTapped_WhenSymbolIsEmpty_ShouldPresentSymbolView() async throws {
        let store = await createTestStore()
        
        await store.send(.minusToolbarTapped) {
            $0.symbol = SymbolFeature.State()
        }
    }
    
    @Test
    func testMinusButtonTapped_WhenSymbolIsAdded_ShouldRemoveLastSymbol() async throws {
        let symbolState = SymbolFeature.State(symbolStyles: [.randomStyle])
        let sheetState = SheetToolbarFeature.State(symbol: symbolState)
        let store = await createTestStore(initialState: sheetState)
        await store.send(.minusToolbarTapped) {
            $0.symbol?.symbolStyles = []
        }
    }
    
    func createTestStore(
        initialState: SheetToolbarFeature.State = SheetToolbarFeature.State(),
        withDependencies dependencies: (inout DependencyValues) -> Void = { _ in }
    ) async -> TestStore<SheetToolbarFeature.State, SheetToolbarFeature.Action> {
        await TestStore(initialState: initialState, reducer: {
            SheetToolbarFeature()
        }, withDependencies: dependencies)
    }
}

