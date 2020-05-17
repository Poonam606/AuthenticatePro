//
//  ProjectManager.swift
//  AuthenticatePro
//
//  Created by Love Verma on 19/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol refreshProductDelegate {
    func refreshProducts()
}

var sellerStoryBoard = UIStoryboard(name:"Seller", bundle: nil)
var expertStoryBoard = UIStoryboard(name:"Expert", bundle: nil)
var mainStoryBoard = UIStoryboard(name:"Main", bundle: nil)
class ProjectManager: NSObject {
    static let sharedInstance = ProjectManager()
    var refreshProductDel:refreshProductDelegate?
    
    private override init() {
        
    }
    
    
    func showLoader(){
        let activityData = ActivityData()
       // let animation = fadeInAnimation()
      NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
//      NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = UIScreen.main.bounds.size
      
       NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,fadeInAnimation)
       
        
    }
    
    func stopLoader(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func getUserObject(dict:[String:Any] , roleStr:String) -> UserObject {
        
        let userObj = UserObject()
        
        userObj.id = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "ID")
        userObj.userName = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "display_name")
        userObj.userNicName = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "user_nicename")
        userObj.userStatus = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "user_status")
        userObj.userEmail  = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "user_email")
        userObj.phoneNo  = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "phone_no")
        if !ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "profile_pic").isEmpty  {
             userObj.userImage  = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "profile_pic_url") + ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "profile_pic")
            
        }
        
       
        userObj.userType = roleStr
        
      return userObj
        
    }
    
    func getBrands(completion:@escaping([BrandObject] , Bool)->Void) {
        var brandsArary = [BrandObject]()
       
        let urlStr = baseURL + ApiMethods.getBrandsAPI
        ProjectManager.sharedInstance.callApiWithParameters(urlStr:urlStr , params: ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ" ,"action":"get_brands"]) { (resposneDict, error) in
           
            
            if error != nil {
        
                DispatchQueue.main.async {
                    completion([BrandObject]() , false)
                    UIApplication.topViewController()!.showAlert(message:"Server Error")
                }
                
            }
            else {
                
                let status = ProjectManager.sharedInstance.getStringValueFromResponse(dict:resposneDict as! [String : Any], key: "code")
                if status == "200" {
                    
                    guard let arr = resposneDict?.value(forKey:"data") as? NSArray else {
                        completion([BrandObject]() , false)
                       
                        return}
                    
                    brandsArary = ProjectManager.sharedInstance.getBrandObjects(array: arr)
                    DispatchQueue.main.async {
                        completion(brandsArary , true)
                    }
                    
                    
                }
                else {
                    DispatchQueue.main.async {
                        UIApplication.topViewController()!.showAlert(message:"Something went wrong")
                    }
                }
                
                print(resposneDict)
                
                
            }
        }
    }
    func getCategories(completion:@escaping([BrandObject] , Bool)->Void) {
        var brandsArary = [BrandObject]()
        ProjectManager.sharedInstance.showLoader()
        let urlStr = baseURL + ApiMethods.getCategoriesAPI
        ProjectManager.sharedInstance.callApiWithParameters(urlStr:urlStr , params: ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ" ,"action":"get_product_category"]) { (resposneDict, error) in
//            DispatchQueue.main.async {
//                ProjectManager.sharedInstance.stopLoader()
//            }
            
            if error != nil {
                
                DispatchQueue.main.async {
                    completion([BrandObject]() , false)
                   
                    UIApplication.topViewController()!.showAlert(message: (error?.isConnectivityError)!)
                }
                
            }
            else {
                
                let status = ProjectManager.sharedInstance.getStringValueFromResponse(dict:resposneDict as! [String : Any], key: "code")
                if status == "200" {
                    
                    guard let arr = resposneDict?.value(forKey:"data") as? NSArray else {
                        completion([BrandObject]() , false)
                        
                        return}
                    
                    brandsArary = ProjectManager.sharedInstance.getBrandObjects(array: arr)
                    DispatchQueue.main.async {
                        completion(brandsArary , true)
                    }
                    
                    
                }
                else {
                    DispatchQueue.main.async {
 UIApplication.topViewController()!.showAlert(message:"Something went wrong")
                    }
                }
                
                print(resposneDict)
                
                
            }
        }
    }
    func getWebsite(completion:@escaping([String] , Bool)->Void) {
        var websiteArary = [websiteobject]()
        //ProjectManager.sharedInstance.showLoader()
        let urlStr = baseURL + ApiMethods.getWebsiteAPI
    
      
        ProjectManager.sharedInstance.callApiWithParameters(urlStr:urlStr , params: ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ" ,"action":"get_websites"]) { (resposneDict, error) in
            
            
            if error != nil {
                print("wesitedata", resposneDict)
                DispatchQueue.main.async {
                    completion([String]() , false)
                    UIApplication.topViewController()!.showAlert(message: (error?.isConnectivityError)!)
                }
                
            }
            else {
                
                let status = ProjectManager.sharedInstance.getStringValueFromResponse(dict:resposneDict as! [String : Any], key: "code")
                if status == "200" {
                    
                    guard let arr = resposneDict?.value(forKey:"data") as? [String] else {
                        completion([String]() , false)
                        
                        return}
                    
                    DispatchQueue.main.async {
                        completion(arr , true)
                    }
                    
                    
                }
                else {
                    DispatchQueue.main.async {
                        UIApplication.topViewController()!.showAlert(message:"Something went wrong")
                    }
                }
                
                print(resposneDict)
                
                
            }
        }
    }
func getProductPrices(completion:@escaping([String] , Bool)->Void) {
        var priceArary = [String]()
      //  ProjectManager.sharedInstance.showLoader()
        let urlStr = baseURL + ApiMethods.getProductPriceAPI
        
        
        ProjectManager.sharedInstance.callApiWithParameters(urlStr:urlStr , params: ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ" ,"action":"get_product_prices"]) { (resposneDict, error) in
            DispatchQueue.main.async {
                ProjectManager.sharedInstance.stopLoader()
            }
            
            if error != nil {
                print("wesitedata", resposneDict)
                DispatchQueue.main.async {
                    completion([String]() , false)
                    UIApplication.topViewController()!.showAlert(message: (error?.isConnectivityError)!)
                }
                
            }
            else {
                
                let status = ProjectManager.sharedInstance.getStringValueFromResponse(dict:resposneDict as! [String : Any], key: "code")
                if status == "200" {
                    
                    guard let arr = resposneDict?.value(forKey:"data") as? [String] else {
                        completion([String]() , false)
                        
                        return}
//                    websiteArary = ProjectManager.sharedInstance.getWebsiteObjects(array: arr)
                    DispatchQueue.main.async {
                        completion(arr , true)
                   }
                    
                    
                }
                else {
                    DispatchQueue.main.async {
                        UIApplication.topViewController()!.showAlert(message:"Something went wrong")
                    }
                }
                
                print(resposneDict)
                
                
            }
        }
    }
    

    
    func getStringValueFromResponse(dict:[String:Any] , key :String) ->String {
        
        if let str = dict[key] as? String {
            return str
        }
        else if let num = dict[key] as? NSNumber {
            return num.stringValue
        }
        else if let number = dict[key] as? Int {
            return String(number)
        }
        else {
            return String()
        }
    }
    func getWebsiteObjects(array :NSArray) -> [String] {
        var websiteArray = [String]()
        for i in array {
           
            
            
        }
        return websiteArray
    }
    func getBrandObjects(array :NSArray) -> [BrandObject] {
        var brandsArray = [BrandObject]()
        for i in array {
            let obj = BrandObject()
            let dict = i  as! [String : Any]
            obj.Name = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "name").html2String
            obj.TermID = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "term_id")
            obj.Slug = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "slug")
            obj.Taxonomy = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "taxonomy")
            obj.TxonomyID = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "term_taxonomy_id")
            obj.Filter = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "filter")
            brandsArray.append(obj)

            
        }
        return brandsArray
    }

    func getProductObjects(array :NSArray) -> [ProductObject] {
        var productsArray = [ProductObject]()
        for i in array {
            let obj = ProductObject()
            let dict = i  as! [String : Any]
            obj.ProductName = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_name").html2String
            obj.ProductPrice = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_price")
            obj.ProductStatus = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_status")
            obj.ProductURL = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_url")
            obj.WebsiteName = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "website_name")
            obj.ZipTieNo = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "zip_tie_no")
            obj.AdminStatus = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "admin_status")
            
             obj.AuthenticateComments = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "authenticate_comments")
            obj.Date = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "authenticate_date")
             obj.CreatedDate = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "creation_date")
            obj.ExpertComments = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "expert_comments")
            obj.CreditPrice = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "credit_price")
            
              obj.RequestID = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "expert_request_id")
            obj.ProductBrandID = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_brand")
                obj.ProductCategoryID = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_category")
             obj.ProductCredit = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_credit")
             obj.ProductDescription = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_description")
             obj.ProductID = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "product_id")
             obj.ApSealNo = ProjectManager.sharedInstance.getStringValueFromResponse(dict: dict, key: "token_number")
            
            
            if let newdict = dict["product_images"] as? [String:Any] {
                var imgObjectArr = [ImageObject]()
              
                    let uploadUrl =  ProjectManager.sharedInstance.getStringValueFromResponse(dict:dict , key: "upload_url")
                    let imgObj = ImageObject()
                    imgObj.ID = ProjectManager.sharedInstance.getStringValueFromResponse(dict:newdict, key: "auto_id")
                    imgObj.ImageStr = uploadUrl + ProjectManager.sharedInstance.getStringValueFromResponse(dict:newdict, key: "product_image")
                    imgObjectArr.append(imgObj)
                
                obj.ProductImages = imgObjectArr
                
            }
            
            if let imgArr = dict["product_images"] as? NSArray {
                var imgObjectArr = [ImageObject]()
                for i in imgArr {
                    let uploadUrl =  ProjectManager.sharedInstance.getStringValueFromResponse(dict:dict , key: "upload_url")
                    let imgObj = ImageObject()
                    imgObj.ID = ProjectManager.sharedInstance.getStringValueFromResponse(dict:i as! [String : Any], key: "auto_id")
                    imgObj.ImageStr = uploadUrl + ProjectManager.sharedInstance.getStringValueFromResponse(dict:i as! [String : Any], key: "product_image")
                    imgObjectArr.append(imgObj)
                }
                obj.ProductImages = imgObjectArr
            }
            productsArray.append(obj)
        }
        
            
        
        return productsArray
    }
    
   
    
    func callApiWithParameters(urlStr:String , params:[String: Any] , completion:@escaping(NSDictionary? , Error?)->Void)  {

        
        print(urlStr , params)
       
        
        var paramStr = String()
        
        for items in params {
            
            paramStr = paramStr + "\(items.key)=\(items.value)&"
            
            
        }
        
        paramStr = paramStr.substring(to: paramStr.index(before: paramStr.endIndex))
        
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

       
            urlRequest.httpBody = paramStr.data(using: .utf8)
     
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.stopLoader()
                    UIApplication.topViewController()!.showAlert(message: (error?.isConnectivityError)!)
                    
                }
                return
            }
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                print(receivedTodo)
                DispatchQueue.main.async {
                    completion(receivedTodo as NSDictionary , nil)
                }
                
                
              
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
   
        
        
    }
    func callApiWihUploadImages(urlStr:String , params:[String: Any] , completion:@escaping(NSDictionary? , Error?)->Void)  {
        
        
        print(urlStr , params)
      
    
        let urlRequest = createRequest(param:params , strURL: urlStr)
        
        let session1 = URLSession.shared
        
        let task = session1.dataTask(with: urlRequest) {
            
            (data, response, error) in
            
            
            
            if error != nil {
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.stopLoader()
                    UIApplication.topViewController()!.showAlert(message: (error?.isConnectivityError)!)
                    
                }
              return
            }
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                print(receivedTodo)
                DispatchQueue.main.async {
                    completion(receivedTodo as NSDictionary , nil)
                }
                
                
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
        
        
    }
    func createRequest (param : [String:Any] , strURL : String) -> URLRequest {
    
    let boundary = generateBoundaryString()
    
    let url = URL(string: strURL)
        var request = URLRequest(url: url!)
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary) as Data
    
    return request
    }
    func createBodyWithParameters(parameters:[String:Any],boundary: String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters {
                
                if(value is String || value is NSString){
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
                else if(value is [UIImage]){
                    var i = 0;
                    for image in value as! [UIImage]{
                        let filename = "\(String(Date().millisecondsSince1970))image\(i).jpg"
                        let data = UIImageJPEGRepresentation(image,0.5);
                        let mimetype = "application/octet-stream"
                        
                        body.appendString(string: "--\(boundary)\r\n")
                        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data!)
                        body.appendString(string: "\r\n")
                        i = i + 1
                    }
                    
                    
                }
            }
        }
        body.appendString(string: "--\(boundary)--\r\n")
        //        NSLog("data %@",NSString(data: body, encoding: NSUTF8StringEncoding)!);
        return body as Data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
    }
    
   
}

extension UIView {
    
    func setCornerRadius(radius:CGFloat)  {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
