//
//  PostsViewController.swift
//  Roomies
//
//  Created by admin on 09/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController{
    
    var allPosts: [Post] = [] //from login
    var myPostsArr: [Post] = []
    var userEmail: String = ""
    var spinner = UIActivityIndicatorView()

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.refreshControl = UIRefreshControl()
        self.table.refreshControl?.addTarget(self, action: #selector(loadAllPosts), for: .valueChanged)

        userEmail = AuthManager.instance.loggedInUserEmail!

        self.table.delegate = self
        self.table.dataSource = self 
        self.table.allowsSelection = false

       ModelEvents.PostDataEvent.observe {
        self.table.refreshControl?.beginRefreshing()
            self.loadAllPosts()
        }
       self.table.refreshControl?.beginRefreshing()
       self.loadAllPosts()
    }
    
    @IBAction func onMyPosts(_ sender: Any) {
      self.performSegue(withIdentifier: "myPostsSegue", sender: self)
    }
    
    @objc func loadAllPosts(){
        Model.instance.getAllPosts(){(arr) in
            self.allPosts = arr
            self.table.reloadData()
            self.table.refreshControl?.endRefreshing()
            //self.spinner.stopAnimating()
        }
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPost", for: indexPath) as! PostsTableViewCell
        cell.postOwnerName.text = allPosts[indexPath.row].ownerName;
        cell.postText.text = allPosts[indexPath.row].text
        cell.postImg.kf.setImage(with: URL(string:allPosts[indexPath.row].image))
        return cell
    }
}
