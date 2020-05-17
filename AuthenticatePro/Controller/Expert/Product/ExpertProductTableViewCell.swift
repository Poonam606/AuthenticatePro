//
//  ExpertProductTableViewCell.swift
//  AuthenticatePro
//
//  Created by Love Verma on 24/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ExpertProductTableViewCell: UITableViewCell {
    @IBOutlet weak var BrandName: UILabel!
   

    @IBOutlet weak var labelWebSite: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var productImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
