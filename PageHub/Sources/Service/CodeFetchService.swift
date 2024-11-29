//
//  CodeFetchService.swift
//  PageHub
//
//  Created by 노우영 on 11/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import Dependencies
import FirebaseFirestore

struct CodeFetchService {
    static let db = Firestore.firestore()
    var fetchCode: @Sendable (_ feature: String, _ version: String) async throws -> String
}

extension CodeFetchService: DependencyKey {
    enum Error1: Error {
        case first
    }
    
    static var liveValue: CodeFetchService {
        CodeFetchService { feature, version in
            let snapshot = try await
            db.collection("snippets").document(feature).collection(version).document("codeDetails").getDocument()
            
            if let code = snapshot.get("code") as? String {
                return code
            } else {
                throw Error1.first
            }
        }
    }
    
    static var previewValue: CodeFetchService {
        CodeFetchService { _, _ in
            return "Code from Firestore!"
        }
    }
}
