//
//  LoginViewController.swift
//  Roomies
//
//  Created by Studio on 22/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var matchArr: [User] = []
    var usersArr: [User] = []
    var allPostsArr: [Post] = []
    var myPostsArr: [Post] = []

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var frame: UIView!
    
    var user: User?
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        backBtn.layer.cornerRadius = 5
        connectBtn.layer.cornerRadius = 5
        frame.layer.cornerRadius = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
     
            if let tabVC = segue.destination as? UITabBarController {
                //Matches
                if let loginToMatchesVC = tabVC.viewControllers![0] as? UINavigationController {
                    if let vc = loginToMatchesVC.topViewController as? MatchesViewController{
                        vc.user = self.user
                    }
                }
                //Profile
                if let loginToProfileVC = tabVC.viewControllers![1] as? ProfileViewController {
                    loginToProfileVC.userFromLogin = self.user
                }
           }
       }
    }

    
    @IBAction func login(_ sender: UIButton) {
        self.errorLabel.text = ""
        self.signInUser(email: email.text!, password: password.text!)
       
        if validInputs(){
            activity.isHidden = false
            connectBtn.isEnabled = false
        }
    }
    
    func signInUser(email: String, password: String) {
        AuthManager.instance.signIn(email: email, password: password) { result in
            if result {
                print("User Signed In")
                self.loadUser(email: email)
            } else {
                self.errorLabel.text = "Email or password incorrect";
                self.activity.isHidden = true
                self.connectBtn.isEnabled = true
            }
        }
    }
    
   func loadAllPosts(){
        Model.instance.getAllPosts(){(arr) in
         self.allPostsArr = arr
           }
    }
        

    func loadUser(email: String){
        Model.instance.getUserByEmail(email: email) { user in
        if let user = user {
            self.user = user
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                print("Error: could not find user")
            }
        }
    }
    
    
    func next(){
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }

    
    func validInputs()->Bool {
        if email.text == "" {
            return false
        }
        else if password.text == "" {
            return false
        }
        return true
    }
}


