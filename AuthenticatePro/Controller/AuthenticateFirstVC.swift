//
//  AuthenticateFirstVC.swift
//  AuthenticatePro
//
//  Created by Love Verma on 13/12/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AuthenticateFirstVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource{
    @IBOutlet weak var pickerViw: UIPickerView!
    
    @IBOutlet weak var storeNoBtn: UIButton!
    @IBOutlet weak var storeYesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet var pickerContainerView: UIView!
    @IBOutlet weak var onlineRetailTxtFld: UITextField!
    @IBOutlet weak var brandnameTxtFld: UITextField!
    @IBOutlet weak var productDescriptionTxtViw: IQTextView!
    @IBOutlet weak var productNameTxtFld: UITextField!
    @IBOutlet weak var multipleItemTxtFld: UITextField!
    var productObj = ProductObject()
    var brandArray = [BrandObject]()
    var onlineRetail = String()
    var multipleItem = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Authenticate Now"
        SetUI()
        ProjectManager.sharedInstance.showLoader()
        ProjectManager.sharedInstance.getBrands { (arr, status) in
            ProjectManager.sharedInstance.stopLoader()
            if status {
                self.brandArray = arr
                self.pickerViw.reloadAllComponents()
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Authenticate Now"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    func SetUI(){
        
        self.productDescriptionTxtViw.placeholderTextColor = #colorLiteral(red: 0.3529411765, green: 0.3529411765, blue: 0.3529411765, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
        
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
        let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(menuAction))
        self.navigationItem.leftBarButtonItem = menuItem
        self.brandnameTxtFld.inputView = pickerContainerView
        
    }
    //MARK:-
    //MARK:- Custom Methods
    @IBAction func cancelAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func multipleAction(_ sender: UIButton) {
        if sender.tag == 0 {
            multipleItem = "No"
            noBtn.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            yesBtn.setImage(#imageLiteral(resourceName: "unselect"), for:.normal)
            
        } else {
             multipleItem = "Yes"
            yesBtn.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            noBtn.setImage(#imageLiteral(resourceName: "unselect"), for:.normal)
            
        }
    }
    
    @IBAction func onlineRetailAction(_ sender: UIButton) {
        if sender.tag == 0 {
            onlineRetail = "No"
            storeNoBtn.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            storeYesBtn.setImage(#imageLiteral(resourceName: "unselect"), for:.normal)
            
        } else {
            onlineRetail = "Yes"
            storeYesBtn.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            storeNoBtn.setImage(#imageLiteral(resourceName: "unselect"), for:.normal)
           
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.view.endEditing(true)
        let row = pickerViw.selectedRow(inComponent: 0)
        self.brandnameTxtFld.text =  brandArray[row].Name
    }
    
    @objc func menuAction()  {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
        
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func nextAction(_ sender: Any) {
        
         let productName:String = (productNameTxtFld.text?.trimmingCharacters(in:.whitespacesAndNewlines))!
         let productDescription:String = (productDescriptionTxtViw.text?.trimmingCharacters(in:.whitespacesAndNewlines))!
         let brandName:String = (brandnameTxtFld.text?.trimmingCharacters(in:.whitespacesAndNewlines))!
        
        
        if onlineRetail.isEmpty {
            self.showAlert(message:"Please select option")
        } else if productName.isEmpty {
            self.showAlert(message:"Please enter product name")
        } else if productDescription.isEmpty {
            self.showAlert(message:"Please enter product description")
        } else if brandName.isEmpty {
            self.showAlert(message: "Please select brand name")
        } else if multipleItem.isEmpty {
            self.showAlert(message:"Please select any option for Do you have multiple items ?")
        }
        else {
        self.productObj.haveMultipleProducts = multipleItem
        self.productObj.isOnlineRetailOrSeller = onlineRetail
        self.productObj.ProductName = productName
        self.productObj.ProductDescription = productDescription
        self.productObj.brandName = brandName
        self.productObj.ProductBrandID = ""
            
        let vc = sellerStoryBoard.instantiateViewController(withIdentifier:"AuthenticateSecondVC") as! AuthenticateSecondVC
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brandArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brandArray[row].Name
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
