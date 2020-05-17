//
//  productDetailTableViewCell.swift
//  AuthenticatePro
//
//  Created by Love Verma on 22/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class productDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonLiveProductUrl: UIButton!
    @IBOutlet weak var labelProductTitle: UILabel!
    @IBOutlet weak var apSeal: UILabel!
    @IBOutlet weak var labelProductDescription: UILabel!
    @IBOutlet weak var zipTieLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var expertLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
