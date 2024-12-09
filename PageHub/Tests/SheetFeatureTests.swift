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
    
    @Test(arguments: [["18.0"], ["18.0", "18.1"]])
    func onAppear_ShouldSetFeatureToolbarVersions(versions: [String]) async throws {
        let snippetVersion = SnippetVersion(versions: versions)
        
        let store = await TestStore(initialState: SheetToolbarFeature.State()) {
            SheetToolbarFeature()
        } withDependencies: {
            $0.snippetService.fetchSnippet = { _ in
                SnippetResponse(versions: versions)
            }
        }
        
        await store.send(.onAppear)
        
        await store.receive(.setSnippetVersion(snippetVersion)) {
            $0.featureToolbar.snippetVersion = snippetVersion
        }
    }
    
    @Test
    func onApper_WhenFetchSnippetVersionFailed_ShouldShowAlert() async throws {
        let store = await TestStore(initialState: SheetToolbarFeature.State()) {
            SheetToolbarFeature()
        } withDependencies: {
            $0.snippetService.fetchSnippet = { _ in
                throw FirestoreError.dataNotFound
            }
        }
        
        await store.send(.onAppear)
        await store.receive(.showAlert(.snippetFetchError))
        
        #expect(store.state.alert != nil)
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

