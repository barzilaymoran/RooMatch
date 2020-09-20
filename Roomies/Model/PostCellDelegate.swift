//
//  PostCellDelegate.swift
//  Roomies
//
//  Created by admin on 23/05/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation

protocol PostCellDelegate : class {
    func didPressEditBtn(_ tag: Int)
    func didPressDeleteBtn(_ tag: Int)
}
