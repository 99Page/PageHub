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
        
        var durationConfig = DurationConfig(text: "코드가 복사되었습니다", duration: 2.5)
        var notificationConfig = NotificationConfig(alignment: .bottom)
    }
    
    @Dependency(\.snippetService) var snippetService
    @Dependency(\.clipboardManager) var clipBoardManager
    @Dependency(\.uuid) var uuid
    
    enum Action: BindableAction, Equatable {
        case alert(PresentationAction<AlertAction>)
        case versionTapped(version: Version)
        case binding(BindingAction<State>)
        case xButtonTapped
        case logic(Logic)
        case codeTextViewAppear
    }
    
    enum Logic: Equatable {
        case updateCode(code: FeatureCode)
        case showServiceErrorAlert
        case dismissNotification
    }
    
    @CasePathable
    enum AlertAction {
        case ok
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.durationConfig.isPresented) { _, newValue in
                Reduce { state, action in
                    guard !state.durationConfig.isPresented else { return .none }
                    return .send(.logic(.dismissNotification))
                }
            }
        
        Reduce { state, action in
            switch action {
            case let .versionTapped(version):
                let feature = state.feature
                return .run { send in
                    do {
                        var visited: Set<String> = []
                        visited.insert(feature.rawValue)
                        let codeResponse = try await snippetService.fetchCode(feature.rawValue, version, &visited)
                        let code = FeatureCode(codeResponse, uuid: uuid())
                        await send(.logic(.updateCode(code: code)))
                    } catch {
                        await send(.logic(.showServiceErrorAlert))
                    }
                }
            case .binding(_):
                return .none
            case .xButtonTapped:
                /// If current view is dismissed, the code view will also be dismissed.
                state.isPresented = false
                
                state.notificationConfig.isPresented = false
                state.durationConfig.isPresented = false
                
                
                #if DEBUG
                state.showCode = nil
                #endif
                return .none
            case .alert(_):
                return .none
            case let .logic(logic):
                switch logic {
                case .updateCode(let code):
                    clipBoardManager.copyToClipboard(code.code)
                    state.showCode = code
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
                case .dismissNotification:
                    state.notificationConfig.isPresented = false
                }
                return .none
            case .codeTextViewAppear:
                state.durationConfig.isPresented = true
                state.notificationConfig.isPresented = true
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
