//
//  FeatureVersionTests.swift
//  PageHubTests
//
//  Created by 노우영 on 12/18/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import Testing
import Foundation
@testable import PageHub

struct FeatureVersionTests {

    typealias StoreType = TestStore<FeatureVersionReducer.State, FeatureVersionReducer.Action>
    
    @Test
    func versionTapped_whenFetchSuccess_showsCode() async throws {
        let store: StoreType = await TestStore(initialState: FeatureVersionReducer.State(feature: .sheetToolbar)) {
            FeatureVersionReducer()
        } withDependencies: {
            $0.snippetService = .testValue
            $0.uuid = .incrementing
        }
        
        let featureCode = FeatureCode(id: UUID(0), code: "Hello, world!")
        await store.send(.versionTapped(version: "18.0"))
        await store.receive(.logic(.updateCode(code: featureCode))) {
            $0.showCode = featureCode
        }
    }
    
    @MainActor @Test
    func versionTapped_whenfetchFail_showsAlert() async throws {
        let store: StoreType = TestStore(initialState: FeatureVersionReducer.State(feature: .sheetToolbar)) {
            FeatureVersionReducer()
        } withDependencies: {
            $0.snippetService = .failValue
        }
        
        // To simplify alert state test by ignoring other unexpected actions
        store.exhaustivity = .off
        
        await store.send(.versionTapped(version: "18.0"))
        await store.receive(.logic(.showServiceErrorAlert))
        
        #expect(store.state.alert != nil)
    }

    @Test
    func xButtonTapped_dismissesView() async throws {
        let state = FeatureVersionReducer.State(feature: .sheetToolbar, isPresented: true)
        let store: StoreType = await TestStore(initialState: state) {
            FeatureVersionReducer()
        }
        
        await store.send(.xButtonTapped) {
            $0.isPresented = false 
        }
    }
}
