//
//  SelectUserViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 21/08/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class SelectUserViewController: UIViewController {
    @IBOutlet weak var buttonSeller: UIButton!
    @IBOutlet weak var buttonBuyer: UIButton!
    @IBOutlet weak var buttonExpert: UIButton!
    var userType = String()
    var selectionAction:blockAction?
    var closeBtnClick:blockAction?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SeelectUserType(_ sender: Any) {
        
       // self.selectionAction!()
        if (sender as AnyObject).tag == 1
        {
           userType = "expert"
           buttonSeller.setImage(UIImage(named:"unselect"), for: .normal)
        
            buttonBuyer.setImage(UIImage(named:"unselect"), for: .normal)
            buttonExpert.setImage(UIImage(named:"select"), for: .normal)
        }
        else if (sender as AnyObject).tag == 2
        {
            userType = "buyer"
            buttonSeller.setImage(UIImage(named:"unselect"), for: .normal)
            buttonBuyer.setImage(UIImage(named:"select"), for: .normal)
            buttonExpert.setImage(UIImage(named:"unselect"), for: .normal)
        }
        else
        {
            userType = "seller"
            buttonSeller.setImage(UIImage(named:"select"), for: .normal)
            buttonBuyer.setImage(UIImage(named:"unselect"), for: .normal)
            buttonExpert.setImage(UIImage(named:"unselect"), for: .normal)
        }
    }
    //MARK: button close Clicked
    @IBAction func closeAction(_ sender: Any) {
        self.closeBtnClick!()
        
    }
    //MARK:button next clicked
    @IBAction func buttonNextClicked(_ sender: Any) {
        if userType == ""
        {
            self.showAlert(title:"Error", message: "Please select user type.")
        }
        else
        {
         self.selectionAction!()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
