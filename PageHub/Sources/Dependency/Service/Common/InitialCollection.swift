//
//  InitialCollectionManager.swift
//  PageHub
//
//  Created by 노우영 on 12/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

enum InitialCollection {
    case snippetMappings
    case snippets
    
    var path: String {
        switch self {
        case .snippetMappings:
            let infoDict = Bundle.main.infoDictionary
            let path = infoDict?["SnippetMappingsCollection"] as? String ?? ""
            return path
        case .snippets:
            let infoDict = Bundle.main.infoDictionary
            let path = infoDict?["SnippetsCollection"] as? String ?? ""
            return path
        }
    }
}
