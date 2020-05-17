//
//  ProductObject.swift
//  AuthenticatePro
//
//  Created by Love Verma on 15/08/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ProductObject: NSObject {
    var ProductStatus = String()
    var brandName = String()
    var AdminStatus = String()
    var ProductURL = String()
    var ZipTieNo = String()
    var WebsiteName = String()
    var ApSealNo = String()
    var ProductPrice = String()
    var ProductName = String()
    var AuthenticateComments = String()
    var Date = String()
    var CreatedDate = String()
    var ExpertComments = String()
    var RequestID = String()
    var ProductBrandID = String()
    var ProductCategoryID = String()
    var CreditPrice = String()
    var ProductCredit = String()
    var ProductID = String()
    var ProductDescription = String()
    var ExpertName = String()
    var haveMultipleProducts = String()
    var isOnlineRetailOrSeller = String()
    var haveZiptie = String()
    
    
    var ProductImages = [ImageObject]()
    
}

class ImageObject :NSObject {
    var ID = String()
    var ImageStr = String()
    var image :UIImage?
    
}
