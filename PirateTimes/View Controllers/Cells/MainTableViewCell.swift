//
//  MainTableViewCell.swift
//  PirateTimes
//
//  Created by Edmund Trujillo on 11/19/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var snippetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbNail.dropShadow()
    }
}

// add a nice drop shadow on the thumbnail
extension UIImageView {
    func dropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 3.0
    }
}
