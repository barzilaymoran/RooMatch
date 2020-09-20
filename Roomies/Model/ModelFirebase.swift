//
//  ModelFireBase.swift
//  Roomies
//
//  Created by Studio on 20/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase {

    static private let USERS_COLLECTION = "users"
    static private let POSTS_COLLECTION = "posts"
    
    /* USERS */
    
    func addUser(email: String, user: User, completion: @escaping (Error?) -> ()) {
        let db = Firestore.firestore()
        let data: [String: Any] = user.toJson()

        db.collection(ModelFirebase.USERS_COLLECTION).document(email).setData(data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                print("User added Successfully!")
                //Notify
                ModelEvents.UserDataEvent.notify()
            }
            completion(err)
        }
    }

    func updateUser(email: String, user: User, completion: @escaping (Error?) -> ()) {
        let db = Firestore.firestore()
        let data: [String: Any] = user.toJson()

        db.collection(ModelFirebase.USERS_COLLECTION).document(email).updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }else{
                print("User updated Successfully!")
                //Notify
                ModelEvents.UserDataEvent.notify()
            }
            completion(err)
        }
    }

    func updateUserLocation(email: String, location: String, completion: @escaping (_ error: Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(ModelFirebase.USERS_COLLECTION).document(email).updateData(["location": location]) { err in
            if let err = err {
                print("Error updating location: \(err)")
            }else{
                print("Location updated Successfully!")
                //Notify
                ModelEvents.UserDataEvent.notify()
            }
            completion(err)
        }
    }

    func getUserByEmail(email: String, completion: @escaping (User?) -> ()) {
        let db = Firestore.firestore()
        db.collection(ModelFirebase.USERS_COLLECTION).document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                completion(User(json: document.data()!))
            } else {
                completion(nil)
            }
        }
    }

    func getAllUsers(since: Int64, completion: @escaping ([User], Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(ModelFirebase.USERS_COLLECTION).order(by: "lastUpdated").start(at: [Timestamp(seconds: since+1, nanoseconds: 0)]).getDocuments() {
            (querySnapshot, err) in
            if err != nil {
                completion([], err)
            } else {
                var users: [User] = []
                for document in querySnapshot!.documents {
                    users.append(User(json: document.data()))
                }
                completion(users, nil)
            }
        }
    }
    
    /* POSTS */
    
    func addPost(post: Post, completion: @escaping (_ error: Error?) -> ()){
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        let data: [String: Any] = post.toJson()
        
        ref = db.collection(ModelFirebase.POSTS_COLLECTION).addDocument(data: data, completion: { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        
                    ModelEvents.PostDataEvent.notify()
                       
                   }
            completion(err)
        });
       
         
    }
    
    func updatePost(post: Post, completion: @escaping (_ error: Error?) -> ()){
        let db = Firestore.firestore()
        let data: [String: Any] = post.toJson()

        db.collection(ModelFirebase.POSTS_COLLECTION).document(post.id).updateData(data) { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                 print("Document successfully updated!")
                ModelEvents.PostDataEvent.notify()
           
            }
            completion(err)
              
        }
    }
    
    func deletePost(post: Post, completion: @escaping (_ error: Error?) -> ()){
        let db = Firestore.firestore()
                        
        db.collection(ModelFirebase.POSTS_COLLECTION).document(post.id).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                ModelEvents.PostDataEvent.notify()
            }
            completion(error)
        }
                
    }
  
     func getAllPosts(since: Int64, completion: @escaping ([Post], Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(ModelFirebase.POSTS_COLLECTION).order(by: "lastUpdated").start(at: [Timestamp(seconds: since+1, nanoseconds: 0)]).getDocuments(){ (querySnapshot, err) in
               if err != nil {
                   completion([], err)
               } else {
                    var posts: [Post] = []
                    var post:Post
                    for document in querySnapshot!.documents {
                        post = Post(json: document.data())
                        post.id = document.documentID
                        posts.append(post)
                   }
                   posts.sort(by: {$0.lastUpdated > $1.lastUpdated})
                   completion(posts, nil)
               }
           }
    }
    
    func getMyPosts(email: String, since: Int64, completion: @escaping ([Post], Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(ModelFirebase.POSTS_COLLECTION).whereField("owner", isEqualTo:email).order(by: "lastUpdated").start(at: [Timestamp(seconds: since+1, nanoseconds: 0)]).getDocuments(){ (querySnapshot, err) in
                if err != nil {
                    completion([], err)
                } else {
                    var posts: [Post] = []
                    var post:Post
                    for document in querySnapshot!.documents {
                        post = Post(json: document.data())
                        post.id = document.documentID
                        posts.append(post)
                    }
                    posts.sort(by: {$0.lastUpdated > $1.lastUpdated})
                    completion(posts, nil)
                }
            }
    }
}
