//
//  ContactUsViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 19/08/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController , UITextViewDelegate{

    @IBOutlet weak var textfiledPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var textviewEnterMessage: UITextView!
    @IBOutlet weak var textfiledEnterEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textfiledEnterName: SkyFloatingLabelTextField!
    var placeholderLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    
        textviewEnterMessage.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter message"
        placeholderLabel.font = UIFont(name: "Montserrat-Medium", size: 15)!
          //  UIFont.systemFont(ofSize: (textviewEnterMessage.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textviewEnterMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x:(UIScreen.main.bounds.size.width - placeholderLabel.frame.size.width - 60)/2 , y: (textviewEnterMessage.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.init(red: 143/255.0, green: 144/255.0, blue: 162/255.0, alpha: 1.0)
        placeholderLabel.isHidden = !textviewEnterMessage.text.isEmpty
         SetUI()
        setupSideMenu()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        self.title = "Contact Us"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    func textViewDidChange(_ textView: UITextView) {
        
       
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
   
    func setupSideMenu() {
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: (self.navigationController?.view)!)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width - 50
        SideMenuManager.default.menuFadeStatusBar = true
        SideMenuManager.default.menuAnimationBackgroundColor  = UIColor.clear
        SideMenuManager.default.menuShadowColor = UIColor.lightGray
        SideMenuManager.default.menuShadowOpacity = 0.3
        SideMenuManager.default.menuShadowRadius = 3
    }
    func SetUI(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
        self.title = "Contact Us"
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
        let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(menuAction))
        self.navigationItem.leftBarButtonItem = menuItem
        
    }
    //MARK:-
    //MARK:- Custom Methods
    @objc func menuAction()  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
        
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func butttonSendMessage(_ sender: Any) {
        self.view.endEditing(true)
        let enterName:String = (textfiledEnterName.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let enterEmail:String = (textfiledEnterEmail.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let enterPhoneNumer:String = (textfiledPhoneNumber.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
         let enterMessage:String = (textviewEnterMessage.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        if enterName.isEmpty
        {
            self.showAlert(title:"Error", message: "Please enter your name.")
        }
        else if enterEmail.isEmpty
        {
            self.showAlert(title:"Error", message: "Please enter your email.")
        }
        else if enterPhoneNumer.isEmpty
        {
           self.showAlert(title:"Error", message: "Please enter phone number.")
        }
        else if enterMessage.isEmpty
        {
            self.showAlert(title:"Error", message: "Please enter message.")
        }
        else{
            var urlStr = String()
            var action = String()
            urlStr = baseURL + ApiMethods.getContactUsAPI
            action = "contactus"
            
            let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "name":enterName , "email":enterEmail,
                 "phone":enterPhoneNumer,
                 "message":enterMessage]
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
                            guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {return}
                            
                            self.showAlert(message: msg)
                        }
                        else {
                            
                            self.textfiledEnterName.text = ""
                            self.textfiledEnterEmail.text = ""
                            self.textfiledPhoneNumber.text = ""
                            self.textviewEnterMessage.text = ""
                            guard let userInfo = responseDict?.value(forKey:"data") as? NSDictionary else {
                                return
                            }
                            guard let msg = userInfo.value(forKey:"message") as? String else {
                                return
                            }
                           self.showAlert(message: msg)
                        }
                    }
                        
                    else {
                        
                        guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {
                            self.showAlert(message:"Server Error")
                            return}
                        
                        self.showAlert(message: msg)
                        
                    }
                    
                }
                
            })
            
        }
        
        
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
