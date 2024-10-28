//
//  CodeService.swift
//  PageHub
//
//  Created by 노우영 on 10/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Dependencies
import FirebaseFirestore

struct CodeService {
    var saveCode: @Sendable () async -> Void
    
    var googleSignIn: @Sendable () async -> Void
}

extension CodeService: DependencyKey {
    static var liveValue: CodeService {
        CodeService {
            let db = Firestore.firestore()
            let docRef = db.collection("FeatureCode").document("code1")
            let data = ["code": "Hello, world"]
            docRef.setData(data)
        }
    }
}

extension DependencyValues {
    var codeService: CodeService {
        get { self[CodeService.self] }
        set { self[CodeService.self] = newValue }
    }
}
