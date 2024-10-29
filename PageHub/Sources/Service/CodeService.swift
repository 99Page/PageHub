//
//  CodeService.swift
//  PageHub
//
//  Created by 노우영 on 10/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Dependencies
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct CodeService {
    var saveCode: @Sendable () async -> Void
    
    var googleSignIn: @Sendable () async throws -> Void
}

extension CodeService: DependencyKey {
    static var liveValue: CodeService {
        CodeService {
            guard Auth.auth().currentUser != nil else { return }
            
            let db = Firestore.firestore()
            
            db.collection("FeatureCode").document("code31312").setData(["code": "Hello, world!"])
        } googleSignIn: {
            guard let clientID = FirebaseApp.app()?.options.clientID
            else { return }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let rootViewController = await scene?.windows.first?.rootViewController
            else { return }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            try await Auth.auth().signIn(with: credential)
        }
    }
}

extension DependencyValues {
    var codeService: CodeService {
        get { self[CodeService.self] }
        set { self[CodeService.self] = newValue }
    }
}
