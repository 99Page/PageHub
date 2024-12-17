//
//  SnippetCodeReducer.swift
//  PageHub
//
//  Created by 노우영 on 12/17/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct FeatureVersionReducer {
    typealias Version = String
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<AlertAction>?
        
        let feature: Feature
        var snippetVersion: SnippetVersion?
        var isPresented: Bool = false
        
        var showCode: FeatureCode?
    }
    
    @Dependency(\.snippetService) var snippetService
    @Dependency(\.clipboardManager) var clipBoardManager
    
    enum Action: BindableAction, Equatable {
        case alert(PresentationAction<AlertAction>)
        case fetchCode(version: Version)
        case updateCode(code: FeatureCode)
        case binding(BindingAction<State>)
        case dismissCodeView
        case showServiceErrorAlert
    }
    
    @CasePathable
    enum AlertAction {
        case ok
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .fetchCode(version):
                let feature = state.feature
                return .run { send in
                    do {
                        var visited: Set<String> = []
                        visited.insert(feature.rawValue)
                        let codeResponse = try await snippetService.fetchCode(feature.rawValue, version, &visited)
                        let code = FeatureCode(codeResponse)
                        await send(.updateCode(code: code))
                    } catch {
                        await send(.showServiceErrorAlert)
                    }
                }
            case let .updateCode(code):
                state.showCode = code
                clipBoardManager.copyToClipboard(code.code)
                return .none
            case .binding(_):
                return .none
            case .dismissCodeView:
                state.isPresented = false
                return .none
            case .alert(_):
                return .none
            case .showServiceErrorAlert:
                state.alert = AlertState {
                    TextState("코드를 불러오지 못했습니다.")
                } actions: {
                    ButtonState(action: .ok) {
                        TextState("확인")
                    }
                } message: {
                    TextState("개발자의 실수가 있습니다ㅠㅠ")
                }
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
