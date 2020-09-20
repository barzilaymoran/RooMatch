//
//  UserModelProtocol.swift
//  Roomies
//
//  Created by Studio on 20/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//


import Foundation
import Kingfisher

protocol UserModelProtocol {
    
    /* USERS */
    func addUser(email: String, user: User, completion: @escaping (_ error: Error?) -> ())
    func updateUser(email: String, user: User, completion: @escaping (_ error: Error?) -> ())
    func updateUserLocation(email: String, location: String, completion: @escaping (_ error: Error?) -> ())
    func getUserByEmail(email: String, completion: @escaping (_ user: User?) -> ())
    func getAllUsers(completion: @escaping (_ users: [User], _ error: Error?) -> ())
    
    /* POSTS */
    func addPost(post: Post, completion: @escaping (_ error: Error?) -> ())
    func updatePost(post: Post, completion: @escaping (_ error: Error?) -> ())
    func deletePost(post: Post, completion: @escaping (_ error: Error?) -> ())
    func getAllPosts(completion: @escaping (_ posts: [Post], _ error: Error?) -> ())
    func getMyPosts(email: String, completion: @escaping (_ posts: [Post], _ error: Error?) -> ())
    
}
