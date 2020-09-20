//
//  MatchDetailsViewController.swift
//  Roomies
//
//  Created by admin on 08/03/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit
import Kingfisher

class MatchDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var ageLable: UILabel!
    @IBOutlet weak var phoneLable: UILabel!
    @IBOutlet weak var smokerLable: UILabel!
    @IBOutlet weak var studentLable: UILabel!
    @IBOutlet weak var religiousLable: UILabel!
    @IBOutlet weak var musicianLable: UILabel!
    @IBOutlet weak var petLoverLable: UILabel!
    @IBOutlet weak var foodLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var budgetLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var name: String?
    var age: String?
    var phone: String?
    var location: String?
    var budget: String?
    var student: String?
    var smoker: String?
    var musician: String?
    var religious: String?
    var food: String?
    var petLover: String?
    var image: UIImageView!
    var user: User?
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.nameLable.text = user!.firstName + " " + user!.lastName
        self.ageLable.text = user?.age
        self.phoneLable.text = user?.phoneNumber
        self.locationLable.text = user?.location
        self.budgetLable.text = user?.budget
        self.studentLable.text = user?.student
        self.smokerLable.text = user?.smoker
        self.musicianLable.text = user?.musician
        self.religiousLable.text = user?.religious
        self.foodLable.text = user?.foodType
        self.petLoverLable.text = user?.petLover
        if(user?.img != ""){
            self.imageView.kf.setImage(with: URL(string: user!.img))
        }
        else{
            self.imageView.image = UIImage(named: "avatar")
        }
    }
}
