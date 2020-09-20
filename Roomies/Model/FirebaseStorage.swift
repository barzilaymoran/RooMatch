//
//  FirebaseStorage.swift
//  Roomies
//
//  Created by admin on 01/06/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseStorage {
    static func saveImage(image:UIImage, imageName: String, complition:@escaping (String)->Void){
        let storageRef = Storage.storage().reference(forURL:
            "gs://ios-app-df61f.appspot.com/")
        let data = image.jpegData(compressionQuality: 0.5)
        let imageRef = storageRef.child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                complition(downloadURL.absoluteString)
            }
        }
    }
   
}
