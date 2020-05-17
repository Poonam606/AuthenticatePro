//
//  ExpertProfileViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 26/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ExpertProfileViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var butoonMyProfile: RoundButton!
    @IBOutlet weak var buttonDashboard: RoundButton!
    @IBOutlet weak var viewBootom: UIView!
    @IBOutlet weak var tableProfile: UITableView!
    var isDashboard = Bool()
    var arrayProfile = ["Username","Email","Phone","Category","Brands","Experience","My Bio"]
    var arrayProfilePlaceHolder = ["john","johnDuo@gmail.com","111-111-111-111","","","9 years","khjkhjhjkhjhjk"]
    var arrayDashboard = ["Open Jobs","Pending Jobs","Pending Earning","Total Earning"]
    var arrayDashboardPlaceholder = ["9","20","$50","$60"]
    
    var userObj = UserObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBootom.isHidden = true
        isDashboard = false
        buttonEdit.isHidden = false
        buttonMenu.isHidden = false
        viewTop.isHidden = true
        heightConstraintTopView.constant = 0
        self.navigationController?.isNavigationBarHidden = true
        getProfileDetail()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        
    }
    @IBAction func buttonDashBoardClicked(_ sender: Any) {
        buttonEdit.isHidden = true
        buttonMenu.isHidden = true
        viewTop.isHidden = false
        isDashboard = true
        heightConstraintTopView.constant = 60
        buttonDashboard.backgroundColor = UIColor.init(red: 136/255, green: 165/255, blue: 80/255, alpha: 1.0)
        butoonMyProfile.backgroundColor = UIColor.init(red: 206/255.0, green: 206/255, blue: 206/255, alpha: 1.0)
        viewBootom.isHidden = false
        tableProfile.reloadData()
        
    }
    @IBAction func buttonProfileClicked(_ sender: Any) {
        buttonEdit.isHidden = false
        buttonMenu.isHidden = false
        viewBootom.isHidden = true
        viewTop.isHidden = true
        isDashboard = false
        heightConstraintTopView.constant = 0
        butoonMyProfile.backgroundColor = UIColor.init(red: 239/255, green: 150/255, blue: 59/255, alpha: 1.0)
        buttonDashboard.backgroundColor = UIColor.init(red: 206/255.0, green: 206/255, blue: 206/255, alpha: 1.0)
        tableProfile.reloadData()
    }
    
    
    //MARK:-
    //MARK:- Get Profile Detail API
    
    //MARK:- Get Profile
    func getProfileDetail(){
        
        var urlStr = String()
        var action = String()
        urlStr = baseURL + ApiMethods.getProfileAPI
        action = "profile_detail"
        let userDefaults = UserDefaults.standard
        if let id = userDefaults.value(forKey: "userId") as? String {
            // let user = UserInfo
            let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id": id ]
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWithParameters(urlStr: urlStr, params: params as [String:Any], completion: { (responseDict, error) in
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
                            guard let userInfo = responseDict?.value(forKey:"data") as? NSDictionary else {
                                return
                            }
                            guard let userInfoget = userInfo.value(forKey:"data") as? [String : Any] else {
                                return
                            }
                            
                            if let roleArray = userInfo.value(forKey:"roles") as? [String]{
                                if roleArray.count > 0 {
                                    let roleStr = roleArray[0]
                                    
                                    userDefaults.set(roleStr, forKey: "userType")
                                    
                                    userType = roleStr
                                }
                                
                            }
                            self.userObj = ProjectManager.sharedInstance.getUserObject(dict: userInfoget as! [String : Any], roleStr: userType)
                            
                            
                            DispatchQueue.main.async {
//                                self.showProfileData(obj: self.userObj)
                            }
                            
                        }
                    }
                        
                    else {
                        
                        guard let msg = (responseDict?.value(forKey:"data") as! [String:Any])["message"] as? String  else {
                            self.showAlert(message:"Server Error")
                            return}
                        
                        self.showAlert(message: msg)
                        
                    }
                    
                }
                
            })
        }
        
    }
    
    
    //MARK:-
    //MARK:- Custom Methods
    
    @IBAction func buttonMenuClicked(_ sender: Any) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
        
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
extension ExpertProfileViewController : UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDashboard == true{
          return 4
         }
        else
        {
         return 7
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ProfileCell", for: indexPath) as? ProfileTableViewCell
        cell?.selectionStyle = .none
        if isDashboard == true
        {
          cell?.labelTitle.text = arrayDashboard[indexPath.row]
          cell?.buttonbags.isHidden = true
          cell?.butoonSunnglasses.isHidden = true
          cell?.textfieldValue.isHidden = false
          cell?.labelTitleValue.placeholder = arrayDashboardPlaceholder[indexPath.row]
        }
        else
        {
            cell?.labelTitle.text = arrayProfile[indexPath.row]
            if indexPath.row == 3
            {
            cell?.butoonSunnglasses.setTitle("SUNGLASSES".uppercased(), for: .normal)
                cell?.buttonbags.setTitle("BAGS".uppercased(), for: .normal)
                cell?.buttonbags.isHidden = false
                cell?.butoonSunnglasses.isHidden = false
                cell?.textfieldValue.isHidden = true
            }
            else if indexPath.row == 4{
            cell?.butoonSunnglasses.setTitle("Louis".uppercased(), for: .normal)
                cell?.buttonbags.setTitle("OAKLEY".uppercased(), for: .normal)
                cell?.buttonbags.isHidden = false
                cell?.butoonSunnglasses.isHidden = false
                cell?.textfieldValue.isHidden = true
            }
            else
            {
                cell?.buttonbags.isHidden = true
                cell?.butoonSunnglasses.isHidden = true
                cell?.textfieldValue.isHidden = false
                cell?.labelTitleValue.placeholder = arrayProfilePlaceHolder[indexPath.row]
            }
        }
        
        return cell!
    }
    
}
