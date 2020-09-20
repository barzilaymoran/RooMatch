//
//  AuthManager.swift
//  Roomies
//
//  Created by Studio on 20/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation

class AuthManager {

    static let instance = AuthManager()
    private var authImpl: AuthProtocol
    private(set) var loggedInUserEmail: String?

    private init() {
        authImpl = FirebaseAuthImpl()
    }

    func createUser(email: String, andPassword password: String, completion: @escaping (_ error: Error?) -> ()) {
        authImpl.register(email: email, password: password) { error in
            self.loggedInUserEmail = email
            completion(error)
        }
    }

    func isLoggedIn() -> Bool {
        self.loggedInUserEmail != nil
    }

    func signIn(email: String, password: String, completion: @escaping (Bool) -> ()) {
        authImpl.logIn(email: email, password: password) { result in
            if result {
                self.loggedInUserEmail = email
            }
            completion(result)
        }
    }

    func logOut(completion: (Bool) -> ()) {
        authImpl.logOut { result in
            self.loggedInUserEmail = nil
            completion(result)
        }
    }
}
