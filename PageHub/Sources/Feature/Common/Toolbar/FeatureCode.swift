//
//  FeatureCode.swift
//  PageHub
//
//  Created by 노우영 on 12/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct FeatureCode: Equatable, Identifiable {
    let id: UUID
    let code: String
}

extension FeatureCode {
    init(_ responses: [FeatureCodeResponse], uuid: UUID) {
        // Step 1: 모든 response를 라인 단위로 나누고 import와 나머지 분리
        var importLines: Set<String> = [] // 중복 제거를 위해 Set 사용
        var otherLines: [String] = []
        
        for response in responses {
            let lines = response.code.components(separatedBy: "\n") // 라인별 분리
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)
                if trimmedLine.hasPrefix("import") {
                    importLines.insert(trimmedLine) // 중복 제거
                } else {
                    otherLines.append(line) // 나머지 라인은 그대로 추가
                }
            }
        }
        
        // Step 2: import 라인을 정렬(선택 사항)하고 다른 라인과 결합
        let sortedImportLines = importLines.sorted() // 중복 제거 후 정렬
        
        self.code = (sortedImportLines + otherLines).joined(separator: "\n")
        self.id = uuid
    }
}
