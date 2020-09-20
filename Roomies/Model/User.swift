//
//  User.swift
//  Roomies
//
//  Created by Studio on 15/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation
import Firebase

class User {
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var img: String = ""
    var age: String = ""
    var budget: String = ""
    var gender: String = ""
    var location: String = ""
    var student: String = ""
    var religious: String = ""
    var musician: String = ""
    var smoker: String = ""
    var petLover: String = ""
    var foodType: String = ""
    var lastUpdated: Int64 = 0
    

    init(firstN: String, lastN: String, phone: String, mail: String) {
        self.firstName = firstN
        self.lastName = lastN
        self.phoneNumber = phone
        self.email = mail
    }

    init(json: [String: Any]) {
        self.email = json["email"] as! String
        self.firstName = json["firstName"] as! String
        self.lastName = json["lastName"] as! String
        self.phoneNumber = json["phoneNumber"] as! String
        self.img = json["img"] as! String
        self.age = json["age"] as! String
        self.budget = json["budget"] as! String
        self.gender = json["gender"] as! String
        self.location = json["location"] as! String
        self.student = json["student"] as! String
        self.religious = json["religious"] as! String
        self.musician = json["musician"] as! String
        self.smoker = json["smoker"] as! String
        self.petLover = json["petLover"] as! String
        self.foodType = json["foodType"] as! String
        if let update = json["lastUpdated"] as? Timestamp{
        self.lastUpdated = update.seconds
        }
    }

    func toJson() -> [String: Any] {
        var json = [String: Any]();
        json["email"] = email;
        json["firstName"] = firstName;
        json["lastName"] = lastName;
        json["phoneNumber"] = phoneNumber;
        json["img"] = img;
        json["age"] = age;
        json["budget"] = budget;
        json["location"] = location;
        json["student"] = student;
        json["gender"] = gender;
        json["religious"] = religious;
        json["musician"] = musician;
        json["smoker"] = smoker;
        json["petLover"] = petLover;
        json["foodType"] = foodType;
        json["lastUpdated"] = FieldValue.serverTimestamp()
      
        return json;
    }
    
    func equals (compareTo:User) -> Bool {
        return self.email == compareTo.email
    }
}
