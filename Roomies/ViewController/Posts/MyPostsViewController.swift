//
//  MyPostsViewController.swift
//  Roomies
//
//  Created by admin on 09/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit
import Kingfisher

class MyPostsViewController: UIViewController {
    
    var myPosts: [Post] = []
    var allPosts: [Post] = []
    var userEmail: String = ""
    var myPost: Post?
    var post: Post?

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail = AuthManager.instance.loggedInUserEmail!
        self.table.delegate = self
        self.table.dataSource = self
        
        ModelEvents.PostDataEvent.observe {
            self.loadMyPosts()
        }
         self.loadMyPosts()
    }
    
    func loadMyPosts(){
        Model.instance.getMyPosts(email: userEmail){(arr) in
            self.myPosts = arr
            self.table.reloadData()
        }
    }
    
    func deletePost(myPost: Post){
        Model.instance.deletePost(post: myPost) { error in
               if (error == nil) {
                   print("Post Deleted from db")
                    self.loadMyPosts()
               } else {
                   print("ERROR: Could not delete post from db")
               }
           }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "editPostSegue" {
                    if let navVC = segue.destination as? UINavigationController {
                        if let vc = navVC.viewControllers.first as? EditPostViewController {
                           vc.postToEdit = self.post
                        }
                    }
            }
    }
}

extension MyPostsViewController: UITableViewDelegate, UITableViewDataSource, PostCellDelegate {
    
    func didPressEditBtn(_ tag: Int) {
        self.post = myPosts[tag]
        self.performSegue(withIdentifier: "editPostSegue", sender: self)
    }
    
    func didPressDeleteBtn(_ tag: Int) {
        self.post = myPosts[tag]
        
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "CentabelBook", size: 20.0)!]
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "CentabelBook", size: 16.0)!]
              
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                     
        let titleAttrString = NSMutableAttributedString(string: "Delete Post", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: "Are you sure you want to delete this post?", attributes: messageFont)
                   
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
            self.post?.isDeleted = "true"
            self.deletePost(myPost: self.post!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 360
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPost", for: indexPath) as! MyPostsTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.postText.text = myPosts[indexPath.row].text
        cell.postImg.kf.setImage(with: URL(string:myPosts[indexPath.row].image))
  
        cell.cellDelegate = self
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        return cell
    }
}

