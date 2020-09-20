//
//  Post.swift
//  Roomies
//
//  Created by admin on 06/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation
import Firebase

class Post {
    var id: String = ""
    var text: String = ""
    var image: String = ""
    var owner: String = ""
    var ownerName: String = ""
    var timestamp: String = ""
    var lastUpdated: Int64 = 0
    var isDeleted: String = "false"

    init(owner: String, ownerName: String, text: String, timestamp: String) {
        self.owner = owner
        self.ownerName = ownerName;
        self.text = text
        self.timestamp = timestamp
    }
    
    init(json: [String: Any]) {
        self.id = json["id"] as! String
        self.text = json["text"] as! String
        self.image = json["image"] as! String
        self.owner = json["owner"] as! String
        self.ownerName = json["ownerName"] as! String
        self.timestamp = json["timestamp"] as! String
        let update = json["lastUpdated"] as! Timestamp
        self.lastUpdated = update.seconds
        self.isDeleted = json["isDeleted"] as! String
    }

    func toJson() -> [String: Any] {
        var json = [String: Any]();
        json["id"] = id
        json["text"] = text
        json["image"] = image
        json["owner"] = owner
        json["ownerName"] = ownerName
        json["timestamp"] = timestamp
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["isDeleted"] = isDeleted
       
        return json;
    }
}
