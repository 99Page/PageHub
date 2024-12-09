//
//  SnippetVersion.swift
//  PageHub
//
//  Created by 노우영 on 11/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct SnippetVersion: Equatable {
    let versions: [String]
}

extension SnippetVersion {
    /// Initializes an object with a sorted list of versions from the given snippet response.
    /// - Parameters:
    ///   - snippetResponse: The response containing the versions to sort.
    ///   - comparator: A closure that defines the sorting criteria. Defaults to ascending order.
    init(snippetResponse: SnippetResponse, comparator: (String, String) -> Bool = { $0 < $1 }) {
        self.versions = snippetResponse.versions.sorted(by: comparator)
    }}
