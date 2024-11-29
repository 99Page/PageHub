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
    init(snippetResponse: SnippetResponse) {
        self.versions = snippetResponse.versions
    }
}
