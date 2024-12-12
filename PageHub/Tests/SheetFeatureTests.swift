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
    func showSheetButtonTapped_ShouldPresentSymbolView() async {
        let store = await createTestStore()
        
        await store.send(.showSheetButtonTapped) {
            $0.symbol = SymbolFeature.State()
        }
    }
    
    @Test
    func plusButtonTapped_ShouldPresentSymbolView() async throws {
        let store = await TestStore(initialState: SheetToolbarFeature.State()) {
            SheetToolbarFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        
        await store.send(.plusToolbarTapped) {
            $0.symbol = SymbolFeature.State(symbolStyles: [.createStub(with: UUID(0))])
        }
    }
    
    @Test
    func minusButtonTapped_WhenSymbolIsEmpty_ShouldPresentSymbolView() async throws {
        let store = await createTestStore()
        
        await store.send(.minusToolbarTapped) {
            $0.symbol = SymbolFeature.State()
        }
    }
    
    @Test
    func minusButtonTapped_WhenSymbolIsAdded_ShouldRemoveLastSymbol() async throws {
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

