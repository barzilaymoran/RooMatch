//
//  PostsTableViewCell.swift
//  Roomies
//
//  Created by admin on 12/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postOwnerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
