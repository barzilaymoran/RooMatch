//
//  firstProfileViewController.swift
//  Roomies
//
//  Created by Studio on 18/02/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit
import CoreData

class FirstProfileViewController: UIViewController {

    var user: User?
    var strName: String?
    var imagePicker = UIImagePickerController()
     var selectedImage:UIImage?
    var profileParent: ProfileViewController?
    var registerParent: RegisterViewController?

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var budgetText: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var religiousSegmented: UISegmentedControl!
    @IBOutlet weak var musicianSegmented: UISegmentedControl!
    @IBOutlet weak var studentSegmented: UISegmentedControl!
    @IBOutlet weak var smokerSegmented: UISegmentedControl!
    @IBOutlet weak var petLoverSegmented: UISegmentedControl!
    @IBOutlet weak var foodSegmented: UISegmentedControl!
    @IBOutlet weak var userImage: UIImageView!
    
    let customFont = UIFont(name: "CentabelBook", size: 17.0)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.image = UIImage(named: "avatar")
        self.setView()
        
        let userEmail: String = AuthManager.instance.loggedInUserEmail!
        self.textFieldHasChanged()
        
        Model.instance.getUserByEmail(email: userEmail) { user in
            if let user = user {
                self.user = user
                
                //from edit profile btn
                if(self.profileParent != nil){
                    self.ageText.text = self.user?.age
                    self.budgetText.text = self.user?.budget
                    if(self.user?.img != ""){
                        self.userImage.kf.setImage(with: URL(string: user.img))
                    }
                    else{
                        self.userImage.image = UIImage(named: "avatar")
                    }
                    
                    if(self.user?.gender == "Female"){
                        self.genderSegmented.selectedSegmentIndex = 1
                    }
                    if(self.user?.religious == "Unreligious"){
                        self.religiousSegmented.selectedSegmentIndex = 1
                    }
                    if(self.user?.musician == "Not a musician"){
                        self.musicianSegmented.selectedSegmentIndex = 1
                    }
                    if(self.user?.student == "Not a student"){
                        self.studentSegmented.selectedSegmentIndex = 1
                    }
                    if(self.user?.smoker == "Non smoker"){
                        self.smokerSegmented.selectedSegmentIndex = 1
                    }
                    if(self.user?.petLover == "Doesn't love pet"){
                        self.petLoverSegmented.selectedSegmentIndex = 1
                    }
                    if(self.user?.foodType == "Vegetarian"){
                        self.foodSegmented.selectedSegmentIndex = 1
                    }
                    else if(self.user?.foodType == "Meat Eater"){
                        self.foodSegmented.selectedSegmentIndex = 2
                    }
                    self.textFieldHasChanged()
                }else{
                    self.name.text = "Hello " + (self.strName ?? " ")
                }
            } else {
                print("Error: could not find user")
            }
        }
        imagePicker.delegate = self
    }
    
     func setView() {
        nextButton.layer.cornerRadius = 5
        
        let attr = NSDictionary(object:UIFont(name: "CentabelBook", size:15.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        
        genderSegmented.setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject: AnyObject] as! [NSAttributedString.Key : Any], for: .normal)
        religiousSegmented.setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject: AnyObject] as! [NSAttributedString.Key : Any], for: .normal)
        musicianSegmented.setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject: AnyObject] as! [NSAttributedString.Key : Any], for: .normal)
        studentSegmented.setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject: AnyObject] as! [NSAttributedString.Key : Any], for: .normal)
        smokerSegmented.setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject: AnyObject] as! [NSAttributedString.Key : Any], for: .normal)
        petLoverSegmented.setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject: AnyObject] as! [NSAttributedString.Key : Any], for: .normal)
        foodSegmented.setTitleTextAttributes(attr as [NSObject : AnyObject] as [NSObject: AnyObject] as! [NSAttributedString.Key : Any], for: .normal)
    }


    @IBAction func saveAndContinue(_ sender: Any) {
        updatedDetail()
        performSegue(withIdentifier: "locationScreen", sender: nil)
    }

    @IBAction func uploadImg(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func textFieldHasChanged() {
        guard let age = ageText.text, !age.isEmpty,
              let budget = budgetText.text, !budget.isEmpty
                else {
                    nextButton.setTitleColor(UIColor.lightGray, for: .normal)
            nextButton.isEnabled = false
            return
        }
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.isEnabled = true
    }

    func updatedDetail() {
        user?.budget = budgetText.text!
        user?.age = ageText.text!
        user?.gender = genderSegmented.selectedSegmentIndex == 0 ? "Male" : "Female"
        user?.religious = religiousSegmented.selectedSegmentIndex == 0 ? "Religious" : "Unreligious"
        user?.musician = musicianSegmented.selectedSegmentIndex == 0 ? "Musician" : "Not a musician"
        user?.student = studentSegmented.selectedSegmentIndex == 0 ? "Student" : "Not a student"
        user?.petLover = petLoverSegmented.selectedSegmentIndex == 0 ? "Pet Lover" : "Doesn't love pet"
        user?.smoker = smokerSegmented.selectedSegmentIndex == 0 ? "Smoker" : "Non smoker"
        switch (foodSegmented.selectedSegmentIndex) {
        case 0:
            user?.foodType = "Vegan"
        case 1:
            user?.foodType = "Vegetarian"
        case 2:
            user?.foodType = "Meat Eater"
        default:
            break;
        }
        guard let selectedImage = selectedImage else {
            self.updateUser(user: self.user!)
            return;
        }
        
        let today = Date();
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let postTimestamp = formatter.string(from: today)
        
        Model.instance.saveImage(image: selectedImage, imageName: postTimestamp) { (url) in
            self.user?.img = url;
            self.updateUser(user: self.user!)
        }
    }

    func updateUser(user: User) {
        Model.instance.updateUser(email: AuthManager.instance.loggedInUserEmail!, user: user) { error in
            if error != nil {
                print("User was updated")
            }
        }
    }
}

extension FirstProfileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.userImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
}


