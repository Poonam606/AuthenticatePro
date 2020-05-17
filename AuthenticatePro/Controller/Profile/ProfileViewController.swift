//
//  ProfileViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 21/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , UITextFieldDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    //MARK:-
    
    
    //MARK:- IBOutlets
    var profieChk = Bool()
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var userImgViw: UIImageView!
    @IBOutlet weak var profileTable: UITableView!
    
    //MARK:-
    //MARK:- Variables
    var arrayTitle = ["Username","Email","Phone"]
    var arrayProfile = ["" ,"", "" , "" , ""]
    var arrayTitleEdit = ["Username","Email","Phone","New Password","Confirm Password"]
    var arrayTextfiled = ["Username","Email","Phone","New Password","Confirm Password"]
    var isEdit = Bool()
    var userObj = UserObject()
    var imagePicker = UIImagePickerController()
    //MARK:-
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageAction))
        //self.userImgViw.isUserInteractionEnabled = true
        self.userImgViw.addGestureRecognizer(tapGesture)

    }
   @objc func selectImageAction()  {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.userImgViw
            alert.popoverPresentationController?.sourceRect = self.userImgViw.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:-
    //MARK:- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            self.userImgViw.image = pickedImage
        }
        else if  let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            self.userImgViw.image = pickedImage
        }
        profieChk =  true
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
              self.navigationController?.isNavigationBarHidden = false
        }
      
    }
    func SetUI() {
        self.saveBtn.isHidden = true; self.navigationController?.navigationBar.isHidden = true
        self.saveBtn.setCornerRadius(radius: 25)
        self.userImgViw.layer.borderWidth = 1.5
        self.userImgViw.layer.borderColor = UIColor.white.cgColor
        getProfileDetail()
    }
    
    
    func showProfileData(obj:UserObject){
        
        arrayProfile = [obj.userName , obj.userEmail , obj.phoneNo , "" , ""]
        if !obj.userImage.isEmpty {
            self.userImgViw.sd_setImage(with: URL(string:obj.userImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage:#imageLiteral(resourceName: "Screen Shot 2018-05-21 at 11.56.59 PM") , options: .refreshCached, completed: { (img, error, cache, url) in
                
            })
        }
        
        self.profileTable.reloadData()
    }
    
    //MARK:-
    //MARK:- TextField Delegate Methods
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            arrayProfile[textField.tag] = updatedText.trimmingCharacters(in: CharacterSet.whitespaces)
            
        }
        return true
    }
    
    //MARK:-
    //MARK:- IBAction Methods
    @IBAction func buttonEditClicked(_ sender: Any) {
        if !isEdit
        {
            isEdit = true
            self.userImgViw.isUserInteractionEnabled = true
        }
        else{
            isEdit = false
            self.userImgViw.isUserInteractionEnabled = false
        }
        profileTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
            self.present(vc!, animated: true, completion: nil)
    }
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
                                self.showProfileData(obj: self.userObj)
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
  @IBAction  func updateProfileDetail(){
        
        if arrayProfile[0].isEmpty {
            self.showAlert(message:"Please enter username.")
        }
        else if arrayProfile[2].isEmpty {
             self.showAlert(message:"Please enter phone number.")
        }
        else if !arrayProfile[3].isEmpty && !arrayProfile[4].isEmpty && arrayProfile[3] != arrayProfile[4] {
             self.showAlert(message:"Confirm password does not match.")
        }
        else {
        var urlStr = String()
        var action = String()
        urlStr = baseURL + ApiMethods.updateProfileAPI
        action = "profile_update"
        let userDefaults = UserDefaults.standard
        if let id = userDefaults.value(forKey: "userId") as? String {
            // let user = UserInfo
            
            if profieChk {
            
                let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id": id , "password":arrayProfile[3] , "phone_no":arrayProfile[2] ,"profile_pic":[userImgViw.image], "username":arrayProfile[0]] as [String : Any]
            ProjectManager.sharedInstance.showLoader()
            ProjectManager.sharedInstance.callApiWihUploadImages(urlStr:urlStr , params: params, completion: { (responseDict, error) in
                ProjectManager.sharedInstance.stopLoader()
                
                print(responseDict  , error)
                if error == nil {
                    guard let status = responseDict?.value(forKey:"status") as? String else{
                        
                        self.showAlert(message:"Server Error")
                        return
                    }
                    if status == "success" {
                        guard let code = responseDict?.value(forKey:"success")  as? String  else {return}
                        
                        if code != "200" {
                            guard let msg = (responseDict?.value(forKey:"data") as? NSDictionary)?.value(forKey:"message") as? String  else {return}
                            
                            self.showAlert(message: msg)
                        }
                        else {
                           
                           guard let msg = (responseDict?.value(forKey:"data") as? NSDictionary)?.value(forKey:"message") as? String  else {return}
                            
                            self.showAlert(message: msg)
                           
                           
                            
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
            else {
                let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id": id , "password":arrayProfile[3] , "phone_no":arrayProfile[2] ,"username":arrayProfile[0] ] as [String : Any]
                ProjectManager.sharedInstance.showLoader()
                ProjectManager.sharedInstance.callApiWithParameters(urlStr:urlStr , params: params, completion: { (responseDict, error) in
                    ProjectManager.sharedInstance.stopLoader()
                    
                    print(responseDict  , error)
                    if error == nil {
                        guard let status = responseDict?.value(forKey:"status") as? String else{
                            
                            self.showAlert(message:"Server Error")
                            return
                        }
                        if status == "success" {
                            guard let code = responseDict?.value(forKey:"success")  as? String  else {return}
                            
                            if code != "200" {
                              guard let msg = (responseDict?.value(forKey:"data") as? NSDictionary)?.value(forKey:"message") as? String  else {return}
                                
                                self.showAlert(message: msg)
                            }
                            else {
                                
                                guard let msg = responseDict?.value(forKey:"message") as? String  else {return}
                                
                                self.showAlert(message: msg)
                                
                                
                                
                            }
                        }
                            
                        else {
                            
                           guard let msg = (responseDict?.value(forKey:"data") as? NSDictionary)?.value(forKey:"message") as? String  else {return}
                            
                            self.showAlert(message: msg)
                            
                        }
                        
                    }
                    
                })
                
                
                
            }
        }
        }
    }
    
}

extension ProfileViewController : UITableViewDataSource,UITableViewDelegate{
    
    //MARK:-
    //MARK:- TablView Delegate And Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEdit == true{
            
            return arrayTitleEdit.count
        }
        else{
            
            return arrayTitle.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ProfileCell", for: indexPath) as? ProfileCell
        cell?.selectionStyle = .none
        cell?.textfieldTitle.tag = indexPath.row
        if  isEdit {
             self.saveBtn.isHidden = false
            if indexPath.row == 1 {
                   cell?.textfieldTitle.isUserInteractionEnabled = false
            }
            else {
                   cell?.textfieldTitle.isUserInteractionEnabled = true
            }
        cell?.labelTitle.text = arrayTitleEdit[indexPath.row]
        cell?.textfieldTitle.placeholder = arrayTitleEdit[indexPath.row]
       // cell?.textfieldTitle.text = arrayTextfiled[indexPath.row]
            if indexPath.row > arrayTitleEdit.count - 3{
                cell?.textfieldTitle.isSecureTextEntry = true
            }
        }
        else{
            self.saveBtn.isHidden = true; cell?.textfieldTitle.isUserInteractionEnabled = false
            cell?.labelTitle.text = arrayTitle[indexPath.row]
            cell?.textfieldTitle.placeholder = arrayTitle[indexPath.row]
            cell?.textfieldTitle.text = arrayProfile[indexPath.row]
        //    cell?.textfieldTitle.text = arrayTextfiled[indexPath.row]
        }
        
        return cell!
    }
    
    
}
