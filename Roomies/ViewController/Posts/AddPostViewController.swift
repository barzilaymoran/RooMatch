//
//  AddPostViewController.swift
//  Roomies
//
//  Created by admin on 09/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController, UITextViewDelegate{
    var userEmail: String = ""
    var allPostsArr: [Post] = []
    var post: Post?

    @IBOutlet weak var errorLabel: UILabel!
    var imagePicker = UIImagePickerController()
    var url:URL?
    var selectedImage:UIImage?
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postText: UITextView!
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
         activity.isHidden = true
        
        userEmail = AuthManager.instance.loggedInUserEmail!
        
        postText.text = "Write caption..."
        postText.textColor = UIColor.lightGray
        postText.delegate = self
        postText.layer.cornerRadius = 5
        postText.layer.borderColor = UIColor.lightGray.cgColor
        postText.layer.borderWidth = 1.0;
        postImg.layer.borderColor = UIColor.lightGray.cgColor
        postImg.layer.borderWidth = 1.0;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Write caption..."){
            textView.text = ""
            postText.textColor = UIColor.darkGray
        }
    }
    
    func textView(_ textView:UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)-> Bool{
        if(text=="\n"){
            textView.resignFirstResponder()
        }
        return true
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func onShare(_ sender: Any) {
        activity.isHidden = false;
       
        if(postText.text == "Write caption..." || postText.text == ""){
            activity.isHidden = true;
            
            let titleFont = [NSAttributedString.Key.font: UIFont(name: "CentabelBook", size: 20.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: "CentabelBook", size: 16.0)!]
                         
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                                
            let titleAttrString = NSMutableAttributedString(string: "Error", attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: "No caption was written", attributes: messageFont)
                              
            alert.setValue(titleAttrString, forKey: "attributedTitle")
            alert.setValue(messageAttrString, forKey: "attributedMessage")

            // add the action
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        let today = Date();
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let postTimestamp = formatter.string(from: today)
        
        
        Model.instance.getUserByEmail(email: userEmail) { user in
        if let user = user {
            let ownerName = user.firstName + " " + user.lastName;
            self.post = Post(owner:self.userEmail, ownerName: ownerName, text: self.postText.text!, timestamp: postTimestamp);
            } else {
                print("Error: could not find user")
            }
        }
      
        guard let selectedImage = selectedImage else {
            activity.isHidden = true;
            let titleFont = [NSAttributedString.Key.font: UIFont(name: "CentabelBook", size: 20.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: "CentabelBook", size: 16.0)!]
                         
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                                
            let titleAttrString = NSMutableAttributedString(string: "Error", attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: "No photo was selected", attributes: messageFont)
                              
            alert.setValue(titleAttrString, forKey: "attributedTitle")
            alert.setValue(messageAttrString, forKey: "attributedMessage")

            // add the action
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            return;
        }
         shareBtn.isEnabled = false;

        Model.instance.saveImage(image: selectedImage, imageName: postTimestamp) { (url) in
            self.post?.image = url;
            self.addPost(post: self.post!)
        }
    }

    func addPost(post: Post) {
        Model.instance.addPost(post: post) { error in
            if (error == nil) {
                print("Controller: Post Added to db")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("ERROR: Could not add post to db")
            }
        }
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}


extension AddPostViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.postImg.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
}

