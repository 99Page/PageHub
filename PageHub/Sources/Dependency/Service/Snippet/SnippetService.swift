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
    
    var fetchCode: @Sendable (_ feature: Feature, _ version: String) async throws -> FeatureCodeResponse
}

extension SnippetService: DependencyKey {
    static var liveValue: SnippetService {
        SnippetService { feature in
            let snippetMapPath = "testSnippetMappings/\(feature.rawValue)"
            let snippetMapResponse = try await DocFetcher.fetch(path: snippetMapPath, type: SnippetMapResponse.self)
            
            let snippetPath = "testSnippets/\(snippetMapResponse.id)"
            let snippetResponse = try await DocFetcher.fetch(path: snippetPath, type: SnippetResponse.self)
            
            return snippetResponse
        } fetchCode: { feature, version in
//            let snippetMapPath = "testSnippetMappings/\(feature.rawValue)"
//            let snippetMapResponse = try await DocFetcher.fetch(path: snippetMapPath, type: SnippetMapResponse.self)
//            
//            let codePath = "testSnippets/\(snippetMapResponse.id)/versions/\(version)"
            let codePath = "testSnippets/containerValues_extension_alignment/18.0.0/codeDetails"
            let codeResponse = try await DocFetcher.fetch(path: codePath, type: FeatureCodeResponse.self)
            
            return codeResponse
        }
    }
    
    static var previewValue: SnippetService {
        SnippetService { _ in
            return SnippetResponse(versions: ["17.0", "18.0", "18.1"])
        } fetchCode: { _, _ in
            return FeatureCodeResponse(code: "Hello, world!")
        }
    }
}

extension DependencyValues {
    var snippetService: SnippetService {
        get { self[SnippetService.self] }
        set { self[SnippetService.self] = newValue }
    }
}
