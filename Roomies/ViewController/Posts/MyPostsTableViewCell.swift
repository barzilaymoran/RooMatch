//
//  MyPostsTableViewCell.swift
//  Roomies
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    
    var cellDelegate: PostCellDelegate?
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func editBtnPressed1(_ sender: UIButton) {
        cellDelegate!.didPressEditBtn(sender.tag)
    }
    
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        cellDelegate!.didPressDeleteBtn(sender.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
