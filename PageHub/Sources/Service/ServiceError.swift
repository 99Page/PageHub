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
}
