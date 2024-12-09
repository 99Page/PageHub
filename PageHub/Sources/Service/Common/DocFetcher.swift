//
//  DocFetcher.swift
//  PageHub
//
//  Created by 노우영 on 12/2/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct DocFetcher {
    /// Fetches a document from Firestore and decodes it into the specified type.
    /// - Parameters:
    ///   - path: The Firestore document path.
    ///   - type: The type to decode the data into (`Decodable`).
    /// - Returns: A decoded object of the specified type.
    /// - Throws: An error if the document is not found, data is missing, or decoding fails.
    static func fetch<Response: Decodable>(path: String, type: Response.Type) async throws -> Response {
        let db = Firestore.firestore()
        let docRef = db.document(path)
        let document = try await docRef.getDocument()
        
        guard let data = document.data(), !data.isEmpty else { throw FirestoreError.dataNotFound }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let response = try JSONDecoder().decode(Response.self, from: jsonData)
            return response
        } catch {
            throw FirestoreError.decodingFailed(error)
        }
    }
}
