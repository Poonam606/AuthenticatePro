//
//  RegisterViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 20/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

var userType = String()
class RegisterViewController: UIViewController {

    //MARK:-
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:-
    //MARK:- IBAction Methods
    @IBAction func signinAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sellerAction(_ sender: Any) {
        
        userType = "Seller"
        let signUpExpert = mainStoryBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpExpert, animated: true)
        
    }
    @IBAction func buyerAction(_ sender: Any) {
        
        userType = "Buyer"
      
        let signUpExpert = mainStoryBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpExpert, animated: true)
    }
    
    @IBAction func buttonResgisterAsExpertClicked(_ sender: Any) {
       
        userType = "Expert"
        let storyboardExpert = UIStoryboard(name: "Expert", bundle: nil)
       let signUpExpert = storyboardExpert.instantiateViewController(withIdentifier: "ExpertSignUpViewController") as! ExpertSignUpViewController
        self.navigationController?.pushViewController(signUpExpert, animated: true)
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
