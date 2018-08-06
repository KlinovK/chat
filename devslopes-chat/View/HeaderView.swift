//
//  HeaderView.swift
//  devslopes-chat
//
//  Created by Константин Клинов on 8/6/18.
//  Copyright © 2018 Константин Клинов. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    override func awakeFromNib() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0.2
    }

}
