//
//  ProfileViewController.swift
//  Roomies
//
//  Created by admin on 21/02/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
     
    var userFromLogin: User?
    var userToLoad: User?
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var signoutBtn: UIButton!
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var ageLable: UILabel!
    @IBOutlet weak var phoneNumberLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var budgetLable: UILabel!
    @IBOutlet weak var smokerLable: UILabel!
    @IBOutlet weak var studentLable: UILabel!
    @IBOutlet weak var musicianLable: UILabel!
    @IBOutlet weak var petLable: UILabel!
    @IBOutlet weak var religiousLable: UILabel!
    @IBOutlet weak var foodLable: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    activity.isHidden = false
    editBtn.layer.cornerRadius = 5
    signoutBtn.layer.cornerRadius = 5
        
    self.userToLoad = userFromLogin
   
    if(self.userToLoad!.img != ""){
           self.image.kf.setImage(with: URL(string: userToLoad!.img))
    }
    else{
           self.image.image = UIImage(named: "avatar")
    }
        
    self.nameLable.text = userToLoad!.firstName + " " + userToLoad!.lastName
    self.ageLable.text = userToLoad?.age
    self.phoneNumberLable.text = userToLoad?.phoneNumber
    self.locationLable.text = userToLoad?.location
    self.budgetLable.text = userToLoad?.budget
    self.studentLable.text = userToLoad?.student
    self.smokerLable.text = userToLoad?.smoker
    self.petLable.text = userToLoad?.petLover
    self.religiousLable.text = userToLoad?.religious
    self.foodLable.text = userToLoad?.foodType
    self.musicianLable.text = userToLoad?.musician
        
    activity.isHidden = true
    }
    
    @IBAction func logOut(_ sender: Any) {
       AuthManager.instance.logOut() { result in
                  if result {
                      print("User Signed Out")
                       self.performSegue(withIdentifier: "signOutSegue", sender: self)
                      
                  } else {
                      print("User Cannot Sign Out")
                  }
              }
    }
    
    
    @IBAction func editProfile(_ sender: UIButton) {
        activity.isHidden = false
        self.performSegue(withIdentifier: "backToFirstSegue", sender: nil)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "backToFirstSegue" {
               if let firstProfileVC = segue.destination as? UINavigationController {
                   if let editVC = firstProfileVC.viewControllers.first as? FirstProfileViewController {
                    editVC.profileParent = self
                   }
               }
           }
       }
    }
