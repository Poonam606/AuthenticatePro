///
//  SignUpViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 20/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
class SignUpViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var textfiledPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var textfiledPhone: SkyFloatingLabelTextField!
    @IBOutlet weak var textfiledEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var textfiledUsername: SkyFloatingLabelTextField!
    //MARK:-
    //MARK:- IBOutlets
    @IBOutlet weak var submitBtn: UIButton!
    
    var brandsArray = [BrandObject]()
     var websiteArray = [websiteobject]()
    //MARK:-
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupAction(_ sender: Any) {
    let username:String = (textfiledUsername.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
         let emailStr:String = (textfiledEmail.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let phoneStr:String = (textfiledPhone.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
         let passStr:String = (textfiledPassword.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        
        if username.isEmpty
        {
          self.showAlert(title:"Error", message: "Please enter username.")
        }
        else if emailStr.isEmpty
        {
            self.showAlert(title:"Error", message: "Please enter email address.")
        }
        else if !emailStr.isValidEmail()
        {
         self.showAlert(title:"Error", message: "Invalid email address.")

        }
        else if phoneStr.isEmpty
        {
             self.showAlert(title:"Error", message: "Please enter phone number.")
        }
        else if passStr.isEmpty
        {
          self.showAlert(title:"Error", message: "Please enter password.")
        }
        else
        {
            var urlStr = String()
            var action = String()
            if userType == "Seller" {
                urlStr = baseURL + ApiMethods.sellerSignUpAPI
                 action = "register_seller"
            }
            else {
                urlStr = baseURL + ApiMethods.buyerSignUpAPI
                action = "register_buyer"

            }
           
            let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action ,"email":emailStr , "username":username ,"phone_no":phoneStr , "password":passStr]
           ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithParameters(urlStr: urlStr, params: params, completion: { (responseDict, error) in
                ProjectManager.sharedInstance.stopLoader()
    
                print(responseDict  , error)
                
                if error == nil {
                    
                    guard let status = responseDict?.value(forKey:"status") as? String else{
                        
                        self.showAlert(message:"Server Error")
                        return
                    }
                    if status == "success" {
                        guard let code = responseDict?.value(forKey:"code")  as? String  else {return}
                        
                        if code != "200" {
                            guard let msg = (responseDict?.value(forKey:"data") as! [String:Any])["message"] as? String  else {return}
                            
                            self.showAlert(message: msg)
                        }
                        else {
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ProductViewController") as? ProductViewController
                            
                            
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                        }
                    }
                    
                    else {
                          self.showAlert(message:"Server Error")
                    }
                    
                    
                    
                    
                }
                
                
            })
            
      
       }
    }
   
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func SetUI(){
      submitBtn.setCornerRadius(radius: 26)
    }

    //MARK:-
    //MARK:- IBAction Methods
    @IBAction func signAction(_ sender: Any) {
        for vc in (self.navigationController?.viewControllers)! {
            if vc is LoginViewController {
                self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK:- Call SignUp Webservice Method
    
    func callSignUpWebservice() {
        
        
        
        
    }
    
    
    
    
    //MARK:-
    //MARK:- Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
