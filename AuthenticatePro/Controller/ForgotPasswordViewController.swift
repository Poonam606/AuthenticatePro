//
//  ForgotPasswordViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 27/08/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var textfiledEmail: UITextField!
    var submitAction:blockAction?
    var closeBtnClick:blockAction?
    var userEmail = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: button close Clicked
    @IBAction func closeAction(_ sender: Any)
    {
        self.closeBtnClick!()
        
    }
    @IBAction func buttonSubmitClicked(_ sender: Any) {
       userEmail = (textfiledEmail.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))!
        if userEmail.isEmpty
        {
             self.showAlert(title:"Error", message: "Please enter email.")
        }
        else
        {
          self.submitAction!()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
