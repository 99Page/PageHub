//
//  ServiceError.swift
//  PageHub
//
//  Created by 노우영 on 11/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

enum FirestoreError: Error {
    /// The case where the return value is nil after calling `.data()`.
    /// or The data returned after calling `.data()` is Empty.
    case dataNotFound
    
    /// This error occurs when decoding the data into the specified type fails.
    /// The associated `Error` provides additional context about the failure.
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "No data was found or the returned data is empty."
        case .decodingFailed(let error):
            return "Failed to decode Firestore data: \(error.localizedDescription)"
        }
    }
}
