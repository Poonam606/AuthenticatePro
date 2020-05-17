//
//  Constants.swift
//  AuthenticatePro
//
//  Created by Love Verma on 12/08/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import Foundation

let baseURL = "https://authenticatepro.com/api/v1/"
let fakeImageURL = "Products - AuthenticateProyes AuthenticatePro"
struct ApiMethods {
 
    static let buyerSignUpAPI = "buyer_register.php"
    static let sellerSignUpAPI = "seller_register.php"
    static let expertSignUpAPI = "expert_register.php"
    static let getBrandsAPI = "brands.php"
    static let getCategoriesAPI = "product-categories.php"
    static let loginAPI = "login.php"
    static let getProfileAPI = "profile.php"
    static let addProductAPI = "product_add.php"
    static let getAuthenticProducts = "authentic_product.php"
    static let getPendingProducts = "pending_products.php"
    static let getProductDetail = "product_details.php"
    static let getSellerAuthenicatedProduct = "authentic_product_seller.php"
    static let getRequestByExpert = "requested_product_by_expert.php"
    static let getPendingProductByExpert = "applied_job_expert.php"
    static let updateProfileAPI = "profile_update.php"
    static let addBuyerRequest = "product_request_by_expert.php"
    static let  getWebsiteAPI = "get_websites.php"
    static let  getProductPriceAPI = "get_product_prices.php"
    static let  getContactUsAPI = "contactus.php"
    static let  getSocialLogin = "social_login.php"
    static let  forgotPassword = "forgot-password.php"
    static let  searchAuthenticateAPI = "search_authentic_products.php"
    static let searchUnAuthenticateAPI = "search_unauthentic_products.php"
    static let applyToJobByExpert = "apply_request_to_job_by_expert.php"
    static let updateStatusAPI = "expert_status_update.php"
}
struct DefaultsIdentifier {
    
    static let userID = "id"
    static let username = "Username"
    static let profileImage = "ProfilePic"
    static let Role = "Role"
    static let isLogin = "isLogin"
    
}
