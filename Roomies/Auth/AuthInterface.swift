//
//  AuthProtocol.swift
//  Roomies
//
//  Created by Studio on 20/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation

protocol AuthProtocol {

    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void)

    func logOut(completion: (Bool) -> Void)

    func register(email: String, password: String, completion: @escaping (_ error: Error?) -> ())
}
