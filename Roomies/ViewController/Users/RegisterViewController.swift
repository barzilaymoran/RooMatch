//
//  RegisterViewController.swift
//  Roomies
//
//  Created by Studio on 22/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//
// This is

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var frame: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        signUpBtn.layer.cornerRadius = 5
        backBtn.layer.cornerRadius = 5
        frame.layer.cornerRadius = 5
    }


    func createUser(email: String, password: String, user: User) {
        AuthManager.instance.createUser(email: email, andPassword: password) { error in
            if error == nil {
                print("User Created")
                Model.instance.addUser(email: email, user: user) { error in
                    if (error == nil) {
                        print("User Added to db")
                        self.signUpBtn.isEnabled = false
                        self.performSegue(withIdentifier: "registerSegue", sender: self);
                    } else {
                        self.errorLabel.text! = error!.localizedDescription;
                    }
                }
            } else {
                self.errorLabel.text! = error!.localizedDescription;
                self.signUpBtn.isEnabled = true
                self.activity.isHidden = true
            }
        }
    }


    @IBAction func signUp(_ sender: UIButton) {
        self.errorLabel.text = ""
        
       if validInputs(){
        activity.isHidden = false
        signUpBtn.isEnabled = false
       }

        let user = User(firstN: self.firstNameField.text!, lastN: self.lastNameField.text!, phone: self.phoneField.text!, mail: self.emailField.text!);

        self.createUser(email: self.emailField.text!, password: self.passwordField.text!, user: user)
    }
    
    func validInputs()->Bool{
      if firstNameField.text == ""{
          return false
      }
      else if lastNameField.text == ""{
          return false
      }
      else if phoneField.text == "" {
          return false
      }
      else if emailField.text == ""{
          return false
      }
      else if passwordField.text == ""{
          return false
      }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSegue" {
            if let navVC = segue.destination as? UINavigationController {
                if let firstVC = navVC.viewControllers.first as? FirstProfileViewController {
                    firstVC.strName = firstNameField.text
                }
            }
        }
    }
}
