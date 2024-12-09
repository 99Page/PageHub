//
//  SnippetService.swift
//  PageHub
//
//  Created by 노우영 on 11/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import Dependencies
import FirebaseFirestore

struct SnippetService {
    /// Fetches a collection associated with a specific feature.
    /// - Parameter feature: The feature to fetch the collection for.
    /// - Returns: A `SnippetResponse` containing the fetched collection data.
    /// - Throws: An error if fetching or decoding fails.
    var fetchSnippet: @Sendable (_ feature: Feature) async throws -> SnippetResponse
}

extension SnippetService: DependencyKey {
    static var liveValue: SnippetService {
        SnippetService { feature in
            let snippetMapPath = "testSnippetMappings/\(feature.rawValue)"
            let snippetMapResponse = try await DocFetcher.fetch(path: snippetMapPath, type: SnippetMapResponse.self)
            
            let snippetPath = "testSnippets/\(snippetMapResponse.id)"
            let snippetResponse = try await DocFetcher.fetch(path: snippetPath, type: SnippetResponse.self)
            
            throw FirestoreError.dataNotFound
            
//            return snippetResponse
        }
    }
    
    static var previewValue: SnippetService {
        SnippetService { _ in
            return SnippetResponse(versions: ["17.0", "18.0", "18.1"])
        }
    }
}

extension DependencyValues {
    var snippetService: SnippetService {
        get { self[SnippetService.self] }
        set { self[SnippetService.self] = newValue }
    }
}
