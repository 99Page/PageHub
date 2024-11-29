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
    var fetchCollection: @Sendable (_ feature: Feature) async throws -> [String]
}

extension FeatureCollectionService: DependencyKey {
    static var liveValue: FeatureCollectionService {
        FeatureCollectionService { feature in
            let db = Firestore.firestore()
//            let collectionRef = db.collection("testSnippets").document("sheetToolbarGroup").collection("18.0.0")
//            let data = try await collectionRef.getDocuments()
//            
//            for document in data.documents {
//                debugPrint("data: \(document.data())")
//            }
            
            let collectionRef = db.collection("testSnippets").document("sheetToolbarGroup")
            debugPrint("data: \(try await collectionRef.getDocument().data())")
            
            return []
        }
    }
    
    static var previewValue: FeatureCollectionService {
        FeatureCollectionService { _ in
            return ["18.0", "18.1"]
        }
    }
}

extension DependencyValues {
    var featureCollectionService: FeatureCollectionService {
        get { self[FeatureCollectionService.self] }
        set { self[FeatureCollectionService.self] = newValue }
    }
}
