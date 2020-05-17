//
//  MenuCell.swift
//  AuthenticatePro
//
//  Created by Love Verma on 23/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
