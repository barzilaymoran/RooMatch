//
//  MatchesTableViewCell.swift
//  Roomies
//
//  Created by admin on 07/03/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var matchUserPhone: UILabel!
    @IBOutlet weak var matchUserAge: UILabel!
    @IBOutlet weak var matchUserName: UILabel!
    @IBOutlet weak var matchUserImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
