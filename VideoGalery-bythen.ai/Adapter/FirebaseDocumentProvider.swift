//
//  FirebaseDocumentProvider.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/13/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct FirebaseDocumentProvider {
    static func getDocument<T: Decodable>(collectionOf: String) async throws -> T {
        let db = Firestore.firestore()
        let docRef = db.collection("auth_keys").document(String(describing: T.self))
        return try await docRef.getDocument(as: T.self)
    }
}
