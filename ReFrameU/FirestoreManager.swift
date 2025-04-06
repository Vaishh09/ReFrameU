//
//  FirestoreManager.swift
//  ReFrameU
//
//  Created by Nysa Jain on 06/04/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: Save Reframe
    func saveReframe(text: String, completion: ((Error?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        let data: [String: Any] = [
            "text": text,
            "timestamp": Timestamp(),
            "userId": uid
        ]

        db.collection("reframes").addDocument(data: data) { error in
            completion?(error)
        }
    }

    // MARK: Save Mood
    func saveMood(name: String, emoji: String, completion: ((Error?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        let data: [String: Any] = [
            "name": name,
            "emoji": emoji,
            "timestamp": Timestamp(),
            "userId": uid
        ]

        db.collection("moods").addDocument(data: data) { error in
            completion?(error)
        }
    }

    // (Optional) Load all saved reframes for a user
    func fetchReframes(completion: @escaping ([String]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("reframes")
            .whereField("userId", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let docs = snapshot?.documents {
                    let texts = docs.compactMap { $0.data()["text"] as? String }
                    completion(texts)
                } else {
                    completion([])
                }
            }
    }
}
