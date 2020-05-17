//
//  ExpertSignUpViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 24/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ExpertSignUpViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource , UITextFieldDelegate{
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var passwordTxtfld: SkyFloatingLabelTextField!
    @IBOutlet weak var brandsBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var phoneTxtFld: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailTxtFld: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameTxtFld: SkyFloatingLabelTextField!
    
    @IBOutlet weak var pickerviw: UIPickerView!
    @IBOutlet weak var pickerContainerViw: UIView!
    
    var brandsArray = [BrandObject]()
    var categoryArray = [BrandObject]()
    var pickerArray = [BrandObject]()
    var selectedBtnTag = Int()
    //MARK:-
    //MARK:- View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

         userType = "expert"
        self.pickerContainerViw.isHidden = true
        pickerContainerViw.animHide()
        ProjectManager.sharedInstance.showLoader()
        ProjectManager.sharedInstance.getBrands { (array, status) in
            if status {
                self.brandsArray = array
                ProjectManager.sharedInstance.getCategories(completion: { (categories, success) in
                    
                    
                    DispatchQueue.main.async {
                        ProjectManager.sharedInstance.stopLoader()
                    }
                    
                    if success {
                        self.categoryArray = categories
                        
                    }
                })
            }
            else {
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.stopLoader()
                }
                
            }
        }
        // Do any additional setup after loading the view.
    }
    //MARK:-
    //MARK:-  UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerContainerViw.animHide()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK:-
    //MARK:-  UIPickerView Datasource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row].Name
    }
    
    //MARK:-
    //MARK:-  IBAction Methods
    
    @IBAction func toolBarActions(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.pickerContainerViw.animHide()
        }
        if sender.tag == 1 {
            let row = pickerviw.selectedRow(inComponent: 0)
            if selectedBtnTag == 1 {
            self.brandsBtn.setTitle(self.pickerArray[row].Name, for: .normal)
                
                
            }
            else {
           self.categoryBtn.setTitle(self.pickerArray[row].Name, for: .normal)
            
            }

       }
       
        
    }
    
    @IBAction func selectBrandAction(_ sender: Any) {
        self.pickerContainerViw.isHidden = false
        selectedBtnTag = 1
        pickerArray = brandsArray
        pickerviw.reloadAllComponents()
        pickerContainerViw.animShow()

        
    }
    @IBAction func selectCategoryAction(_ sender: Any) {
        self.pickerContainerViw.isHidden = false
        selectedBtnTag = 2
        pickerArray = categoryArray
        pickerviw.reloadAllComponents()
        pickerContainerViw.animShow()
        
        
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        pickerContainerViw.animHide()
        let usernameStr:String = (usernameTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespaces))!
        let emailStr:String = (emailTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespaces))!
        let phoneStr:String = (phoneTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespaces))!
        let passwordStr:String = (passwordTxtfld.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        if usernameStr.isEmpty
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
        else if categoryBtn.currentTitle == "Select Category" {
              self.showAlert(title:"Error", message: "Please select category.")
        }
        else if brandsBtn.currentTitle == "Select Brand" {
              self.showAlert(title:"Error", message: "Please select brand.")
        }
        else if passwordStr.isEmpty
        {
            self.showAlert(title:"Error", message: "Please enter password.")
        }
        
        else
        {
            let urlStr = baseURL + ApiMethods.expertSignUpAPI
            let action = "register_expert"
           
            let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action ,"email":emailStr , "username":usernameStr ,"phone_no":phoneStr , "password":passwordStr , "product_brand":brandsBtn.currentTitle! ,"product_cat":categoryBtn.currentTitle!]
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithParameters(urlStr: urlStr, params: params as [String:Any] , completion: { (responseDict, error) in
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
                            
                            let vc = expertStoryBoard.instantiateViewController(withIdentifier:"ExpertProductViewController") as? ExpertProductViewController
                            
                            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinAction(_ sender: Any) {
        
        for vc in  (self.navigationController?.viewControllers)! {
            
            if vc is LoginViewController {
                
                self.navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        
        let vc = mainStoryBoard.instantiateViewController(withIdentifier:"LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
