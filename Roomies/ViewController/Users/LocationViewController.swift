//
//  LocationViewController.swift
//  Roomies
//
//  Created by admin on 27/02/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var citySelected = false
    var user: User?
    var matchArr: [User] = []
    var usersArr: [User] = []
    var searchCity = [String]()
    var searching = false
    var userEmail: String = ""
    
    let cityNameArr = ["Ashkelon", "Ashdod", "Yavne", "Rehovot", "Rishon Le Zion", "Holon", "Nataniya", "Tel Aviv", "Beer Sheva", "Bat Yam", "Ramat Gan", "Givatayim", "Raanana", "Kfar Saba", "Herzliya", "Jerusalem", "Haifa"]

    @IBOutlet weak var testLablel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var nextButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       activity.isHidden = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "CentabelBook", size: 17.0)
        self.setView()
        userEmail = AuthManager.instance.loggedInUserEmail!
        self.loadUser(email: userEmail)
    
        self.searchBar.text = self.user?.location
        if (self.searchBar.text != ""){
         self.nextButton.setTitleColor(UIColor.white, for: .normal)
         self.nextButton.isEnabled = true
        }
    }
    
     func setView() {
        nextButton.setTitleColor(UIColor.lightGray, for: .normal)
        nextButton.isEnabled = false
        nextButton.layer.cornerRadius = 5
    }

    @IBAction func saveAndContinue(_ sender: Any) {
        if validInputs(){
            activity.isHidden = false
        }
        
        let location = searchBar.text!
        self.updateLocation(location: location)
    }
    
    func loadUser(email:String){
        Model.instance.getUserByEmail(email: email) { user in
        if let user = user{
            self.user = user
            self.searchBar.text = self.user?.location
            if (self.searchBar.text != ""){
             self.nextButton.setTitleColor(UIColor.white, for: .normal)
             self.nextButton.isEnabled = true
            }
        } else {
                print("ERROR: could not find user")
            }
        }
    }
    
    func loadUserEnd(email:String){
        Model.instance.getUserByEmail(email: email) { user in
        if let user = user {
            self.user = user
            self.searchBar.text = self.user?.location
            self.performSegue(withIdentifier: "tabSegue", sender: self)
            } else {
                print("ERROR: Could not find user")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "tabSegue" {
            if let tabVC = segue.destination as? UITabBarController {
            //For Profile
               if let locationToProfileVC = tabVC.viewControllers![1] as? ProfileViewController {
                   locationToProfileVC.userFromLogin = self.user
               }
            //For matches
            if let tabVC = segue.destination as? UITabBarController {
                if let locationToMatchesVC = tabVC.viewControllers![0] as? UINavigationController {
                        if let vc = locationToMatchesVC.topViewController as? MatchesViewController{
                            vc.user = self.user
                        }
                    }
                }
            }
        }
    }
        
    func updateLocation(location: String) {
        Model.instance.updateUserLocation(email: AuthManager.instance.loggedInUserEmail!, location: location) { error in
            if error != nil {
                print("ERROR: Failed to update location \(error!)")
            }
            else{
                self.loadUserEnd(email: self.userEmail)
            }
        }
    }
    
    func validInputs()->Bool{
         if searchBar.text == ""{
             return false
         }
           return true
       }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCity.count
        } else {
            return cityNameArr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchCity[indexPath.row]
        } else {
            cell?.textLabel?.text = cityNameArr[indexPath.row]
        }
        return cell!
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.isEnabled = true
       
        tableView.deselectRow(at: indexPath, animated: true)
        if searching {
            searchBar.text = searchCity[indexPath.row]
        } else {
            searchBar.text = cityNameArr[indexPath.row]
        }
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text == ""){
            nextButton.setTitleColor(UIColor.gray, for: .normal)
            nextButton.isEnabled = false
        }
        searchCity = cityNameArr.filter({ $0.prefix(searchText.count) == searchText })
        searching = true
        tbView.reloadData()
    }
}
