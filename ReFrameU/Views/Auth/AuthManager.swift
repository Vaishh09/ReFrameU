//
//  AuthManager.swift
//  ReFrameU
//
//  Created by Nysa Jain on 06/04/25.
//


import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()

    private init() {}

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func currentUserUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
