//
//  MatchesViewController.swift
//  Roomies
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit
import Kingfisher

class MatchesViewController: UIViewController {
    
   var usersArr: [User] = []
     var matches: [User] = []
    var user: User?
    var userEmail:String = ""
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         userEmail = AuthManager.instance.loggedInUserEmail!
        self.table.refreshControl = UIRefreshControl()
        self.table.refreshControl?.addTarget(self, action: #selector(matchCaller), for: .valueChanged)
        
        self.table.delegate = self
        self.table.dataSource = self
    
        ModelEvents.UserDataEvent.observe {
            self.table.refreshControl?.beginRefreshing()
            self.match(email: self.userEmail)
        }
        
        
        self.table.refreshControl?.beginRefreshing()
        self.match(email: self.userEmail)
    }
    
    @objc func matchCaller(){
        match(email: self.userEmail)
    }
    
    func match(email: String){
        var count = 0
        matches = []
        usersArr = []
        Model.instance.getAllUsers(){(arr,err) in
            if err != nil {
                print("Failed to get all users")
            } else {
                self.usersArr = arr
                for x in self.usersArr {
                    count = 0
               if(!(x.equals(compareTo: self.user!))
                && x.location == self.user?.location
                && Int(x.budget)! <= Int(self.user!.budget)! + 1000 && Int(x.budget)! >= Int(self.user!.budget)! - 1000){
                    if (x.religious == self.user?.religious){
                        count+=1
                    }
                    if (x.musician == self.user?.musician){
                        count+=1
                    }
                    if (x.student == self.user?.student){
                        count+=1
                    }
                    if (x.smoker == self.user?.smoker){
                        count+=1
                    }
                    if (x.petLover == self.user?.petLover){
                        count+=1
                    }
                    if (x.foodType == self.user?.foodType){
                        count+=1
                    }
                    if(count <= 6 && count>=4){
                        self.matches.append(x)
                    }
                }
            }
                self.table.reloadData()
                self.table.refreshControl?.endRefreshing()
            }
        }
    }
}

extension MatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MatchesTableViewCell
        let match = matches[indexPath.row]
        cell.matchUserName.text = match.firstName + " " + matches[indexPath.row].lastName
        cell.matchUserAge.text = match.age
        cell.matchUserPhone.text = match.phoneNumber
        cell.matchUserImg.image = UIImage(named: "avatar")
        if(match.img != ""){
            cell.matchUserImg.kf.setImage(with: URL(string: match.img))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MatchDetailsViewController") as! MatchDetailsViewController
        let match = matches[indexPath.row]
        vc.user = match

    self.navigationController?.pushViewController(vc, animated: true)
    }
}
