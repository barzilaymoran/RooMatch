//
//  EditPostViewController.swift
//  Roomies
//
//  Created by admin on 10/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit
import Kingfisher

class EditPostViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postOwnerName: UILabel!
    
    var postToEdit: Post? //from my posts
    var updatedPost:Post?
    
    var imagePicker = UIImagePickerController()
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        postText.layer.cornerRadius = 5
        postText.layer.borderColor = UIColor.lightGray.cgColor
        postText.layer.borderWidth = 1.0;
        
        self.postText.text = postToEdit?.text
        self.postImg.kf.setImage(with: URL(string: postToEdit!.image))
    }
    
    @IBAction func onCancel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDone(_ sender: Any) {
        activity.isHidden = false
        let today = Date();
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let postTimestamp = formatter.string(from: today)
        
        let post = Post(owner:postToEdit!.owner, ownerName: postToEdit!.ownerName, text: postText.text!, timestamp: postToEdit!.timestamp);
           post.id = postToEdit!.id
        
        guard let selectedImage = selectedImage else {
            post.image = postToEdit!.image
            self.updatePost(post: post)
            return;
        }
        doneBtn.isEnabled = false;

        Model.instance.saveImage(image: selectedImage, imageName: postTimestamp) { (url) in
            post.image = url;
            self.updatedPost = post
            self.updatePost(post: post)
        }
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func updatePost(post: Post){
           Model.instance.updatePost(post: post) { error in
               if (error == nil) {
                   print("Post Updated in db")
                 self.dismiss(animated: true, completion: nil)
               } else {
                   print("ERROR: Could not update post from db")
               }
           }
    }
}

extension EditPostViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
               self.postImg.image = selectedImage
               self.dismiss(animated: true, completion: nil)
    }
}

