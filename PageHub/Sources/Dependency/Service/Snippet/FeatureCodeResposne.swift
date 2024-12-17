//
//  CodeResposne.swift
//  PageHub
//
//  Created by 노우영 on 12/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct FeatureCodeResponse: Decodable {
    let code: String
    let subsnippets: [String]
}
