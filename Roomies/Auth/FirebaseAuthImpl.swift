//
//  FirebaseAuthImpl.swift
//  Roomies
//
//  Created by Studio on 20/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthImpl: AuthProtocol {

    func logIn(email: String, password: String, completion: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result: AuthDataResult?, error: Error?) in
            completion(error == nil)
        }
    }

    func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }

    func register(email: String, password: String, completion: @escaping (_ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            completion(error)
        }
    }
}
