//
//  FeatureCode.swift
//  PageHub
//
//  Created by 노우영 on 12/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct FeatureCode: Identifiable, Equatable {
    let id = UUID()
    let code: String
}

extension FeatureCode {
    init(_ response: FeatureCodeResponse) {
        self.code = response.code
    }
}
