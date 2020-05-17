
//
//  AuthenticateSecondVC.swift
//  AuthenticatePro
//
//  Created by Love Verma on 13/12/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class AuthenticateSecondVC: UIViewController {
    @IBOutlet weak var yesBtn: UIButton!
    
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var zipTieDropdownTxtFld: UITextField!
    @IBOutlet weak var zipTieTxtFld: UITextField!
    var productObj = ProductObject()
    var isZipTieAvailable = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.navigationItem.title = "Authenticate Now"
          self.zipTieTxtFld.isHidden = true
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
    
    @IBAction func ziptieAction(_ sender: UIButton                                  ) {
        if sender.tag == 0 {
            isZipTieAvailable = "No"
            self.zipTieTxtFld.isHidden = true
            noBtn.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            yesBtn.setImage(#imageLiteral(resourceName: "unselect"), for:.normal)
            
        } else {
            isZipTieAvailable = "Yes"
            self.zipTieTxtFld.isHidden = false
            yesBtn.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            noBtn.setImage(#imageLiteral(resourceName: "unselect"), for:.normal)
            
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let ziptie = (zipTieTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        if isZipTieAvailable.isEmpty {
            self.showAlert(message:"Please select any option")
        } else if isZipTieAvailable == "Yes" && ziptie.isEmpty {
            self.showAlert(message:"Please enter zip tie")
        } else {
         self.productObj.haveZiptie = isZipTieAvailable
         self.productObj.ZipTieNo = ziptie
         let vc = sellerStoryBoard.instantiateViewController(withIdentifier:"AuthenticateThirdVC") as! AuthenticateThirdVC
         self.navigationController?.pushViewController(vc, animated: true)
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
