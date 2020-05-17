//
//  ProductViewCell.swift
//  AuthenticatePro
//
//  Created by Love Verma on 21/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ProductViewCell: UITableViewCell {
    @IBOutlet weak var zipTieNoLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var websiteNameLbl: UILabel!
    @IBOutlet weak var apSealLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
