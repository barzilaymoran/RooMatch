//
//  ModelSql.swift
//  Roomies
//
//  Created by Studio on 15/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation

class ModelSql {
   
    var database: OpaquePointer? = nil
    private var statement: OpaquePointer? = nil
    
    init(){
        connect()
    }
    
    deinit {
        sqlite3_close_v2(database);
    }
    
    func connect() {
           let dbFileName = "database2.db"
           if let dir = FileManager.default.urls(for: .documentDirectory, in:
               .userDomainMask).first{
               let path = dir.appendingPathComponent(dbFileName)
               if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                   print("Failed to open db file: \(path.absoluteString)")
                   return
               }
               else{
                print("DB is connected")
               }
           }
        
       //create tables
       createPostsTable()
       createUsersTable()
    }
    
     /**************************  USERS  ***************************/
    
    func createUsersTable(){
        var createTableStatement: OpaquePointer? = nil
        let createTableString = "CREATE TABLE IF NOT EXISTS USERS (EMAIL TEXT PRIMARY KEY, FIRSTNAME TEXT, LASTNAME TEXT, PHONENUMBER TEXT, IMG TEXT, AGE TEXT, BUDGET TEXT, GENDER TEXT, LOCATION TEXT, STUDENT TEXT, RELIGIOUS TEXT, MUSICIAN TEXT, SMOKER TEXT, PETLOVER TEXT, FOODTYPE TEXT);"
        
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Users table created succefully")
            } else {
                print("Users table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
   
  func addUser(email: String, user: User) {
        var sqlite3_stmt: OpaquePointer? = nil
        let insertStatementString = "INSERT OR REPLACE INTO USERS (EMAIL, FIRSTNAME, LASTNAME, PHONENUMBER, IMG, AGE, BUDGET, GENDER, LOCATION, STUDENT, RELIGIOUS, MUSICIAN, SMOKER, PETLOVER, FOODTYPE) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);"
        
        if (sqlite3_prepare_v2(database,insertStatementString,-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let email = email.cString(using: .utf8)
            let firstName = user.firstName.cString(using: .utf8)
            let lastName = user.lastName.cString(using: .utf8)
            let phoneNumber = user.phoneNumber.cString(using: .utf8)
            let img = user.img.cString(using: .utf8)
            let age = user.age.cString(using: .utf8)
            let budget = user.budget.cString(using: .utf8)
            let gender = user.gender.cString(using: .utf8)
            let location = user.location.cString(using: .utf8)
            let student = user.student.cString(using: .utf8)
            let religious = user.religious.cString(using: .utf8)
            let musician = user.musician.cString(using: .utf8)
            let smoker = user.smoker.cString(using: .utf8)
            let petLover = user.petLover.cString(using: .utf8)
            let foodType = user.foodType.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, email, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 2, firstName, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 3, lastName, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 4, phoneNumber, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 5, img, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 6, age, -1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, budget, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 8, gender, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 9, location, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 10, student, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 11, religious, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 12, musician, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 13, smoker, -1,nil);
            sqlite3_bind_text(sqlite3_stmt, 14, petLover, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 15, foodType, -1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
               // print("Users: New row added succefully")
               
            }
         
        }
    }
    
    

    func updateUser(email: String, user: User) {
        var result = false
        
        let Data_stmt = "UPDATE USERS SET IMG = \'\(user.img)\', AGE = \'\(user.age)\', BUDGET = \'\(user.budget)\', GENDER = \'\(user.gender)\', LOCATION = \'\(user.location)\', STUDENT = \'\(user.student)\', RELIGIOUS = \'\(user.religious)\', MUSICIAN = \'\(user.musician)\', SMOKER = \'\(user.smoker)\', PETLOVER = \'\(user.petLover)\', FOODTYPE = \'\(user.foodType)\' WHERE EMAIL = \'\(email)\'"
            
        sqlite3_prepare_v2(database, Data_stmt, -1, &statement, nil)

        if sqlite3_step(statement) == SQLITE_DONE {
            print("User Updated Succefully")
           
            result = true
        } else {
            print("User Not Updated. Error \(String(describing: sqlite3_errmsg(database)))")
            result = false
        }
        
        sqlite3_reset(statement)
    }
    
    
    func updateUserLocation(email: String, location: String, completion: @escaping (Error?) -> ()) {
        var result = false
        let Data_stmt = "UPDATE USERS SET LOCATION = \'\(location)\' WHERE EMAIL = \'\(email)\'"
        
        sqlite3_prepare_v2(database, Data_stmt, -1, &statement, nil)

        if sqlite3_step(statement) == SQLITE_DONE {
            print("Location Updated Succefully")
            //Notify
            ModelEvents.UserDataEvent.notify()
            result = true
        } else {
            print("Location Not Updated. Error \(String(describing: sqlite3_errmsg(database)))")
            result = false
        }
        
        sqlite3_reset(statement)
        if(result){
            completion(nil)
        }
        else{
            completion(SqlError.runTimeError("UPDATE LOCATION statement could not be prepared"))
        }
    }
    
    func getUserByEmail(email: String, completion: @escaping (User?) -> ()) {
        var sqlite3_stmt: OpaquePointer? = nil
        var user = User(firstN:"", lastN:"",phone:"",mail:"")

        if (sqlite3_prepare_v2(database,"SELECT * FROM USERS WHERE EMAIL = \'\(email)\';", -1, &sqlite3_stmt, nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let email = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let firstName = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let lastName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let phoneNumber = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let img = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let age = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let budget = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                let gender = String(cString:sqlite3_column_text(sqlite3_stmt,7)!)
                let location = String(cString:sqlite3_column_text(sqlite3_stmt,8)!)
                let student = String(cString:sqlite3_column_text(sqlite3_stmt,9)!)
                let religious = String(cString:sqlite3_column_text(sqlite3_stmt,10)!)
                let musician = String(cString:sqlite3_column_text(sqlite3_stmt,11)!)
                let smoker = String(cString:sqlite3_column_text(sqlite3_stmt,12)!)
                let petLover = String(cString:sqlite3_column_text(sqlite3_stmt,13)!)
                let foodType = String(cString:sqlite3_column_text(sqlite3_stmt,14)!)
                       
                user = User(firstN:firstName, lastN:lastName,phone:phoneNumber,mail:email)
                user.img = img
                user.age = age
                user.budget = budget
                user.gender = gender
                user.location = location
                user.student = student
                user.religious = religious
                user.musician = musician
                user.smoker = smoker
                user.petLover = petLover
                user.foodType = foodType
                }
            }
      
        sqlite3_finalize(sqlite3_stmt)
        completion(user)
    }
    
    
    func getAllUsers(completion: @escaping ([User], Error?) -> ()){
        var sqlite3_stmt: OpaquePointer? = nil
        var users = [User]()
        var user: User
        
        if (sqlite3_prepare_v2(database,"SELECT * FROM USERS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let email = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let firstName = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let lastName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let phoneNumber = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let img = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let age = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let budget = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                let gender = String(cString:sqlite3_column_text(sqlite3_stmt,7)!)
                let location = String(cString:sqlite3_column_text(sqlite3_stmt,8)!)
                let student = String(cString:sqlite3_column_text(sqlite3_stmt,9)!)
                let religious = String(cString:sqlite3_column_text(sqlite3_stmt,10)!)
                let musician = String(cString:sqlite3_column_text(sqlite3_stmt,11)!)
                let smoker = String(cString:sqlite3_column_text(sqlite3_stmt,12)!)
                let petLover = String(cString:sqlite3_column_text(sqlite3_stmt,13)!)
                let foodType = String(cString:sqlite3_column_text(sqlite3_stmt,14)!)
                
                user = User(firstN:firstName, lastN:lastName,phone:phoneNumber,mail:email)
                user.img = img
                user.age = age
                user.budget = budget
                user.gender = gender
                user.location = location
                user.student = student
                user.religious = religious
                user.musician = musician
                user.smoker = smoker
                user.petLover = petLover
                user.foodType = foodType
                users.append(user)
            }
        }
        else{
            completion(users,SqlError.runTimeError("GET ALL USERS statement could not be prepared"))
        }
        
        sqlite3_finalize(sqlite3_stmt)
        completion(users, nil)
    }
    
    
    /**************************  POSTS  **************************/
    
    func createPostsTable(){
           var createTableStatement_posts: OpaquePointer? = nil
           
        let createTableString_posts = "CREATE TABLE IF NOT EXISTS POSTS (ID TEXT PRIMARY KEY, OWNER TEXT, OWNER_NAME TEXT, IMG TEXT, CAPTION TEXT, TIMESTAMP TEXT, IS_DELETED TEXT);"
           
           if sqlite3_prepare_v2(database, createTableString_posts, -1, &createTableStatement_posts, nil) == SQLITE_OK{
               if sqlite3_step(createTableStatement_posts) == SQLITE_DONE{
                   print("Posts table created succefully")
               } else {
                   print("Posts table could not be created")
               }
           } else {
               print("CREATE TABLE statement could not be prepared")
           }
        
        
         var createTableStatement_cache: OpaquePointer? = nil
        let createTableString_cache = "CREATE TABLE IF NOT EXISTS LAST_UPDATE_DATE (NAME TEXT PRIMARY KEY, DATE NUMBER);"
        
        if sqlite3_prepare_v2(database, createTableString_cache, -1, &createTableStatement_cache, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement_cache) == SQLITE_DONE{
                print("LAST_UPDATE_DATE table created succefully")
            } else {
                print("LAST_UPDATE_DATE table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        
        sqlite3_finalize(createTableStatement_posts)
        sqlite3_finalize(createTableStatement_cache)
    }
    
    
    func addPost(post: Post){
        var sqlite3_stmt: OpaquePointer? = nil
        let insertStatementString = "INSERT OR REPLACE INTO POSTS (ID, OWNER, OWNER_NAME, IMG, CAPTION, TIMESTAMP, IS_DELETED) VALUES (?,?,?,?,?,?,?);"
 
        if (sqlite3_prepare_v2(database,insertStatementString,-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = post.id.cString(using: .utf8)
            let owner = post.owner.cString(using: .utf8)
            let ownerName = post.ownerName.cString(using: .utf8)
            let img = post.image.cString(using: .utf8)
            let text = post.text.cString(using: .utf8)
            let timestamp = post.timestamp.cString(using: .utf8)
            let isDeleted = post.isDeleted.cString(using: .utf8)
                
            sqlite3_bind_text(sqlite3_stmt, 1, id, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 2, owner, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 3, ownerName, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 4, img, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 5, text, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 6, timestamp, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 7, isDeleted, -1, nil);
              
            if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
              //  print("SQL: Post Added Succefully")
            }
            
        }
    }
    
    func addMyPost(post: Post, completion: @escaping (_ error: Error?) -> ()){
           
           var sqlite3_stmt: OpaquePointer? = nil
           let insertStatementString = "INSERT OR REPLACE INTO MY_POSTS (OWNER, IMG, CAPTION, TIMESTAMP, IS_DELETED) VALUES (?,?,?,?,?);"
    
           if (sqlite3_prepare_v2(database,insertStatementString,-1, &sqlite3_stmt,nil) == SQLITE_OK){
               let owner = post.owner.cString(using: .utf8)
               let img = post.image.cString(using: .utf8)
               let text = post.text.cString(using: .utf8)
               let timestamp = post.timestamp.cString(using: .utf8)
               let isDeleted = post.isDeleted.cString(using: .utf8)
                   
               sqlite3_bind_text(sqlite3_stmt, 1, owner, -1, nil);
               sqlite3_bind_text(sqlite3_stmt, 2, img, -1, nil);
               sqlite3_bind_text(sqlite3_stmt, 3, text, -1, nil);
               sqlite3_bind_text(sqlite3_stmt, 4, timestamp, -1, nil);
               sqlite3_bind_text(sqlite3_stmt, 4, isDeleted, -1, nil);
                 
               if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
                   print("SQL: My Post Added Succefully")
                   completion(nil)
               }
               else{
                  completion(SqlError.runTimeError("Could not add row"))
               }
           }
           else{
               completion(SqlError.runTimeError("INSERT statement could not be prepared"))
           }
    }
    
    func updatePost(post: Post){
        var result = false
        let Data_stmt = "UPDATE POSTS SET IMG = \'\(post.image)\', CAPTION = \'\(post.text)\' WHERE ID = \'\(post.id)\'"
        sqlite3_prepare_v2(database, Data_stmt, -1, &statement, nil)

        if sqlite3_step(statement) == SQLITE_DONE {
            print("Post Updated Succefully")
            result = true
        } else {
            print("Post Not Updated. Error \(String(describing: sqlite3_errmsg(database)))")
            result = false
        }
               
        sqlite3_reset(statement)
    }
    
    
    func deletePost(post: Post){
        var sqlite3_stmt: OpaquePointer? = nil
        let deleteStatementString = "DELETE FROM POSTS WHERE ID = \'\(post.id)\';"
        if (sqlite3_prepare_v2(database,deleteStatementString,-1, &sqlite3_stmt,nil) == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, post.id,-1,nil)
            
            if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
                    print("SQL: Post Deleted Succefully")
            }
        sqlite3_finalize(sqlite3_stmt)
        }
    }
    
    func getAllPosts(completion: @escaping (_ posts: [Post], _ error: Error?) -> ()){
        var sqlite3_stmt: OpaquePointer? = nil
        var posts = [Post]()
        var post: Post
        
        if (sqlite3_prepare_v2(database,"SELECT * FROM POSTS WHERE IS_DELETED = \'\("false")\';", -1, &sqlite3_stmt, nil) == SQLITE_OK){
              while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                  let id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                  let owner = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                  let ownerName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                  let img = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                  let text = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                  let timestamp = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                  let isDeleted = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                  
                post = Post(owner: owner, ownerName: ownerName, text: text, timestamp: timestamp)
                post.id = id
                post.image = img
                post.isDeleted = isDeleted
                posts.append(post)
              }
        }
        else{
            completion(posts,SqlError.runTimeError("GET ALL POSTS statement could not be prepared"))
        }
        
        sqlite3_finalize(sqlite3_stmt)
        posts.sort(by: {$0.timestamp > $1.timestamp})
        completion(posts, nil)
    }
    
    func getMyPosts(email: String, completion: @escaping (_ posts: [Post], _ error: Error?) -> ()){
        var sqlite3_stmt: OpaquePointer? = nil
               var posts = [Post]()
               var post: Post
                 
               if (sqlite3_prepare_v2(database,"SELECT * FROM POSTS WHERE OWNER = \'\(email)\' AND IS_DELETED = \'\("false")\';",-1,&sqlite3_stmt,nil) == SQLITE_OK){
                     while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                         let id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                         let owner = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                         let ownerName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                         let img = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                         let text = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                         let timestamp = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                         let isDeleted = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                        
                        post = Post(owner: owner, ownerName: ownerName, text: text, timestamp: timestamp)
                        post.id = id
                        post.image = img
                        post.isDeleted = isDeleted
                        posts.append(post)
                     }
                 }
                 else{
                     completion(posts,SqlError.runTimeError("GET MY POSTS statement could not be prepared"))
                 }
                 
                 sqlite3_finalize(sqlite3_stmt)
                 posts.sort(by: {$0.timestamp > $1.timestamp})
                 completion(posts, nil)
    }
    
    func setLastUpdateDate(name: String, lastUpdateDate: Int64){
         var sqlite3_stmt: OpaquePointer? = nil
         if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO LAST_UPDATE_DATE (NAME, DATE) VALUES (?,?);", -1, &sqlite3_stmt, nil) == SQLITE_OK){

            sqlite3_bind_text(sqlite3_stmt, 1, name, -1, nil);
             sqlite3_bind_int64(sqlite3_stmt, 2, lastUpdateDate);
             if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                // print("LAST_UPDATE_DATE: New row added succefully")
             }
         }
         sqlite3_finalize(sqlite3_stmt)
     }
    
     func getLastUpdateDate(name: String)->Int64{
         var date:Int64 = 0;
         var sqlite3_stmt: OpaquePointer? = nil
         if (sqlite3_prepare_v2(database,"SELECT * FROM LAST_UPDATE_DATE WHERE NAME = ?;", -1, &sqlite3_stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
            
             if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                date = Int64(sqlite3_column_int64(sqlite3_stmt,1))
             }
         }
         sqlite3_finalize(sqlite3_stmt)
         return date
     }
}
  

