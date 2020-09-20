//
//  Model.swift
//  Roomies
//
//  Created by Studio on 15/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation
import UIKit

class Model {

    static let instance = Model()
    var modelImpl: ModelFirebase = ModelFirebase()
    var modelSql: ModelSql = ModelSql()
    
    private init(){}
    
    func saveImage(image:UIImage, imageName: String, complition:@escaping (String)->Void){
        FirebaseStorage.saveImage(image: image, imageName: imageName, complition:complition)
    }
    
    
    /****** USERS ******/

    func addUser(email: String, user: User, completion: @escaping (_ error: Error?) -> ()) {
        modelImpl.addUser(email: email, user: user, completion: completion)
    }

    func updateUser(email: String, user: User, completion: @escaping (_ error: Error?) -> ()) {
        modelImpl.updateUser(email: email, user: user, completion: completion)
    }

    func updateUserLocation(email: String, location: String, completion: @escaping (_ error: Error?) -> ()) {
        modelImpl.updateUserLocation(email: email, location: location, completion: completion)
    }

    func getUserByEmail(email: String, completion: @escaping (_ user: User?) -> ()) {
        modelImpl.getUserByEmail(email: email, completion: completion)
    }

    func getAllUsers(completion: @escaping (_ users: [User], _ error: Error?) -> ()) {
        let lud = modelSql.getLastUpdateDate(name: "USERS")
              
              modelImpl.getAllUsers(since: lud) { (users, err) in
                  var localLud: Int64 = lud

                  for user in users{
                    self.modelSql.addUser(email: user.email, user: user)
                      if (user.lastUpdated > localLud){
                          localLud = user.lastUpdated
                      }
                  }

                  self.modelSql.setLastUpdateDate(name: "USERS", lastUpdateDate: localLud)
             
                  var completeData: [User] = []
                  self.modelSql.getAllUsers() {(usersSql, err) in
                      if(err == nil){
                          completeData = usersSql
                      }
                  }
                  
                  //return the complete data to the caller
                  completeData.sort(by: {$0.lastUpdated > $1.lastUpdated})
                  completion(completeData, nil)
              }
    }
    
    /****** POSTS ******/
    
    func addPost(post: Post, completion: @escaping (_ error: Error?) -> ()){
        modelImpl.addPost(post: post, completion: completion)
    }
    
    func updatePost(post: Post, completion: @escaping (_ error: Error?) -> ()){
       modelSql.updatePost(post: post)
       modelImpl.updatePost(post: post, completion: completion)
    }
    
    func deletePost(post: Post, completion: @escaping (_ error: Error?) -> ()){
        modelSql.updatePost(post: post)
        modelImpl.updatePost(post: post, completion: completion)
    }
    
    func getAllPosts(completion: @escaping (_ posts: [Post]) -> ()){
        let lud = modelSql.getLastUpdateDate(name: "POSTS")
        
        modelImpl.getAllPosts(since: lud) { (posts, err) in
            var localLud: Int64 = lud

            for post in posts{
                self.modelSql.addPost(post: post)
                if (post.lastUpdated > localLud){
                    localLud = post.lastUpdated
                }
            }

            self.modelSql.setLastUpdateDate(name: "POSTS", lastUpdateDate: localLud)
       
            var completeData: [Post] = []
            self.modelSql.getAllPosts() {(postsSql, err) in
                if(err == nil){
                    completeData = postsSql
                }
            }
            
            //return the complete data to the caller
            completeData.sort(by: {$0.lastUpdated > $1.lastUpdated})
            completion(completeData)
        }
    }
    
    func getMyPosts(email: String, completion: @escaping (_ posts: [Post]) -> ()){
        //get the local last update date
        let lud = modelSql.getLastUpdateDate(name: "POSTS")
               
        //get the records from firebase since the local last update date
        modelImpl.getMyPosts(email: email, since: lud) { (posts, err) in
               
            //save the new records to the local db
            var localLud: Int64 = lud
           
            for post in posts{
                self.modelSql.addPost(post: post)
                if (post.lastUpdated > localLud){
                    localLud = post.lastUpdated
                }
            }
            
            //save the new local last update date
            self.modelSql.setLastUpdateDate(name: "POSTS", lastUpdateDate: localLud)
                            
            //get the complete data from local db
            var completeData: [Post] = []
            self.modelSql.getMyPosts(email: email) {(postsSql, err) in
                if(err == nil){
                    completeData = postsSql
                }
            }
            
            //return the complete data to the caller
            completeData.sort(by: {$0.lastUpdated > $1.lastUpdated})
            completion(completeData)
        }
        completion([])
    }
}

/****** NOTIFICATIONs ******/

class ModelEvents{
    static let PostDataEvent = EventNotificationBase(eventName: "com.moran.PostDataEvent")
    static let UserDataEvent = EventNotificationBase(eventName: "com.moran.UserDataEvent")
    
    private init(){}
    
}

class EventNotificationBase{
    let eventName: String
    
    init(eventName: String){
        self.eventName = eventName
    }
    
    func observe(completion: @escaping () -> ()){
           NotificationCenter.default.addObserver(forName: NSNotification.Name(eventName), object: nil, queue: nil){(data) in
               completion(); //apply function given in listening
           }
    }
       
    func notify(){
        NotificationCenter.default.post(name: NSNotification.Name(eventName), object: self, userInfo: nil)
    }
}
