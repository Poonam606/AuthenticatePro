//
//  ProfileTableViewCell.swift
//  AuthenticatePro
//
//  Created by Love Verma on 26/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonbags: RoundButton!
    
    @IBOutlet weak var textfieldValue: UITextField!
    @IBOutlet weak var butoonSunnglasses: RoundButton!
    @IBOutlet weak var labelTitleValue: UITextField!
   
    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
