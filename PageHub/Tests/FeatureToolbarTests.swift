//
//  FeatureToolbarTests.swift
//  PageHubTests
//
//  Created by 노우영 on 12/18/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import Testing
@testable import PageHub

struct FeatureToolbarTests {
    
    let versionMock: [String] = ["18.0"]
    typealias StoreType = TestStore<FeatureToolbarReducer.State, FeatureToolbarReducer.Action>
    
    @Test
    func onAppear_fetchSuccess_setsSnippetVersion () async throws {
        let store: StoreType = await TestStore(
            initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)
        ) {
            FeatureToolbarReducer()
        } withDependencies: {
            $0.snippetService = SnippetService { feature in
                return SnippetResponse(versions: versionMock)
            } fetchCode: { _, _, _ in
                return [FeatureCodeResponse(code: "Hello", subsnippets: [])]
            }
        }
        
        let snippetVersion = SnippetVersion(versions: versionMock)
        
        await store.send(.onAppear)
        await store.receive(.setSnippetVersion(snippetVersion)) {
            $0.featureVersion.snippetVersion = snippetVersion
        }
    }

    @Test func onAppear_fetchFailure_setsFailedState() async throws {
        let store: StoreType = await TestStore(
            initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)
        ) {
            FeatureToolbarReducer()
        } withDependencies: {
            $0.snippetService = SnippetService { feature in
                throw FirestoreError.dataNotFound
            } fetchCode: { _, _, _ in
                throw FirestoreError.dataNotFound
            }
        }
        
        await store.send(.onAppear)
        await store.receive(.snippetFetchFail) {
            $0.isFailedToFetch = true
        }
    }
    
    @MainActor @Test
    func fetchVersionTapped_whenFetchFailed_showsAlert() async throws {
        let store: StoreType = await TestStore(
            initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)
        ) {
            FeatureToolbarReducer()
        } withDependencies: {
            $0.snippetService = SnippetService { feature in
                throw FirestoreError.dataNotFound
            } fetchCode: { _, _, _ in
                throw FirestoreError.dataNotFound
            }
        }
        
        store.exhaustivity = .off
        
        
        await store.send(.onAppear)
        await store.skipReceivedActions()
        await store.send(.fetchVersionTapped)
        
        #expect(store.state.alert != nil)
    }
    
    @MainActor @Test
    func fetchVersionTapped_whenFetchSuccess_presentsFeatureVersion() async throws {
        let store: StoreType = await TestStore(
            initialState: FeatureToolbarReducer.State(feature: .sheetToolbar)
        ) {
            FeatureToolbarReducer()
        } withDependencies: {
            $0.snippetService = SnippetService { feature in
                return SnippetResponse(versions: versionMock)
            } fetchCode: { _, _, _ in
                return [FeatureCodeResponse(code: "Hello", subsnippets: [])]
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.skipReceivedActions()
        await store.send(.fetchVersionTapped) {
            $0.featureVersion.isPresented = true
        }
    }
}
