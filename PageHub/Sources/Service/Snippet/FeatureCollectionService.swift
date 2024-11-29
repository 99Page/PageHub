//
//  FeatureCollectionService.swift
//  PageHub
//
//  Created by 노우영 on 11/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import Dependencies
import FirebaseFirestore

struct FeatureCollectionService {
    var fetchCollection: @Sendable (_ feature: Feature) async throws -> SnippetResponse
}

extension FeatureCollectionService: DependencyKey {
    static var liveValue: FeatureCollectionService {
        FeatureCollectionService { feature in
            let db = Firestore.firestore()
            let path = "testSnippets/sheetToolbarGroup"
            let collectionRef = db.document(path)
            let snippetData = try await collectionRef.getDocument().data()
            
            guard let snippetData, !snippetData.isEmpty else { throw FirestoreError.dataNotFound }
            
            let jsonData = try JSONSerialization.data(withJSONObject: snippetData)
            let response = try JSONDecoder().decode(SnippetResponse.self, from: jsonData)
            
            return response
        }
    }
    
    static var previewValue: FeatureCollectionService {
        FeatureCollectionService { _ in
            return SnippetResponse(versions: ["17.0", "18.0", "18.1"])
        }
    }
}

extension DependencyValues {
    var featureCollectionService: FeatureCollectionService {
        get { self[FeatureCollectionService.self] }
        set { self[FeatureCollectionService.self] = newValue }
    }
}
