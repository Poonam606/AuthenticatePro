//
//  LoginViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 19/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import LinkedinSwift
import IOSLinkedInAPIFix
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion
import PopupDialog
import GoogleSignIn
public typealias  blockAction = () -> Void
class LoginViewController: UIViewController , UITextFieldDelegate {
    
    //MARK:-
    //MARK:- IBOutlets
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var topLogoViw: UIView!
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var signgoogleInButton: GIDSignInButton!
    var socialLoginType : String = ""
    var userRole : String = ""
    var SocialDict = NSDictionary()
   // static let shared = GoogleLogin()
    
    var completionBlock: ((GIDGoogleUser?) -> Void)?
    //MARK:-
    //MARK:- View Life Cycle Methods
     var linkedinHelper = LinkedinSwiftHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        GIDSignIn.sharedInstance().delegate = self
        linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "81u207wqgw2gx3", clientSecret: "a5a4JDf29DcBUlyS", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://authenticatepro.com"))
            SetUI()

        // Do any additional setup after loading the view.
    }
    
    func SetUI()  {
      self.navigationController?.isNavigationBarHidden = true
        signInBtn.setCornerRadius(radius:26)
        searchBtn.layer.borderWidth = 1.0
        searchBtn.layer.borderColor = UIColor.white.cgColor
        searchBtn.contentHorizontalAlignment = .center
    }
    
    
    //MARK:-
    //MARK:- IBAction Methods
    
    @IBAction func searchAction(_ sender: Any) {
        
       let product = mainStoryBoard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        product.isHiddenMenu = true
        self.navigationController?.pushViewController(product, animated: true)
    }
    
    @IBAction func signinAction(_ sender: Any) {
       let username:String = (usernameTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let password:String = (passwordTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        if username.isEmpty
        {
            self.showAlert(title:"Error", message: "Please enter username.")
        }
        else if password.isEmpty
        {
         self.showAlert(title:"Error", message: "Please enter password.")
        }
        else if !username.isValidEmail()
        {
         self.showAlert(title:"Error", message: "Please enter valid email.")
        }
        else{
        var urlStr = String()
        var action = String()
        urlStr = baseURL + ApiMethods.loginAPI
        action = "login"
        
    let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "username":username , "password":password,"device_token":deviceTokenGet ?? "sdfsf321sd3f213sd1f364sdaf64a6s4fas6f4asf65f4sd"]
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

                        guard let userInfo = responseDict?.value(forKey:"data") as? NSDictionary else {
                            return
                             }
                        guard let userInfoget = userInfo.value(forKey:"data") as? NSDictionary else {
                            return
                        }
                       guard let id = userInfoget["ID"] as? String
                        else
                       {
                        return
                        }
                        
                        let userDefaults = UserDefaults.standard
//                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userInfoget)
                        userDefaults.set(String(id), forKey: "userId")
                        
                        if let roleArray = userInfo.value(forKey:"roles") as? [String]{
                            if roleArray.count > 0 {
                            let roleStr = roleArray[0]
                                
                                userDefaults.set(roleStr, forKey: "userType")
                                
                                userType = roleStr
                            }
                            
                        }
                        
                        let userObj = ProjectManager.sharedInstance.getUserObject(dict: userInfoget as! [String : Any], roleStr: userType)
                         userDefaults.set(userObj.userImage, forKey: DefaultsIdentifier.profileImage)
                        userDefaults.set(userObj.userName, forKey: DefaultsIdentifier.username)
                        userDefaults.set(userType, forKey: DefaultsIdentifier.Role)
                        userDefaults.set(true, forKey: DefaultsIdentifier.isLogin)
                       
                        userDefaults.synchronize()
                        if userType == "expert"
                        {
                            
                            
                            let addProduct = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
                            self.navigationController?.pushViewController(addProduct, animated: true)
                           /* let addProduct = expertStoryBoard.instantiateViewController(withIdentifier: "ExpertProductViewController") as! ExpertProductViewController
                            self.navigationController?.pushViewController(addProduct, animated: true)*/
                        }
                        else
                        {
                userDefaults.set(true, forKey: DefaultsIdentifier.isLogin)
                userDefaults.synchronize()
                let addProduct = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController

             self.navigationController?.pushViewController(addProduct, animated: true)
                     /*  let vc = self.storyboard?.instantiateViewController(withIdentifier:"ProductViewController") as? ProductViewController
                     self.navigationController?.pushViewController(vc!, animated: true)*/
                        }
                        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = true
        }
      
    }
    
    @IBAction func ButtonForgotPassword(_ sender: Any) {
       self.forgotPasswordPopup()
    }
    func forgotPasswordAPI(email: String)
    {
        var urlStr = String()
        var action = String()
        urlStr = baseURL + ApiMethods.forgotPassword
        action = "forgot_password"
        
        let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "email":email]
        ProjectManager.sharedInstance.showLoader()
        ProjectManager.sharedInstance.callApiWithParameters(urlStr: urlStr, params: params, completion: { (responseDict, error) in
            ProjectManager.sharedInstance.stopLoader()
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
                        guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {return}
                        
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
    @IBAction func buttonfacebookClicked(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self, handler: { (result, error) -> Void in
            if error != nil {
               
                FBSDKLoginManager().logOut()
                if let error = error as NSError? {
                    let errorDetails = [NSLocalizedDescriptionKey : "Processing Error. Please try again!"]
                    let customError = NSError(domain: "Error!", code: error.code, userInfo: errorDetails)
                } else {
                    
                }
                
            } else if (result?.isCancelled)! {
                
                FBSDKLoginManager().logOut()
                let errorDetails = [NSLocalizedDescriptionKey : "Request cancelled!"]
                let customError = NSError(domain: "Request cancelled!", code: 1001, userInfo: errorDetails)
                
            }
            else
            {
                let permissionDictionary = [
                    "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
                let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: permissionDictionary)
                let _ = pictureRequest?.start(completionHandler: {
                    (connection, result, error) -> Void in
                    print("result",result)
                    if error == nil {
                        guard let userinfo = result as? NSDictionary
                        else
                        {
                            return
                        }
                        self.socialLoginType = "Facebook"
                        self.SocialDict = result as! NSDictionary
                  /*
                    let userfirstName = userinfo["first_name"] as? String
                        let userLastname = userinfo["last_name"] as? String
                        let userEmail = userinfo["email"] as? String
                        let picture = userinfo["picture"] as! NSDictionary
                        let data = picture["data"] as! NSDictionary
                        let profileUrl = data["url"] as? String
                        let userId = userinfo["id"] as! String*/
                      //  self.LoginwithSocial(SocialLoginType:  self.socialLoginType, userinfoDict: result as! NSDictionary)
                       DispatchQueue.main.async {
                        self.userSelectionPopup()
                    }
                      
                      /*  result Optional({
                            email = "poonamyadav464@gmail.com";
                            "first_name" = Poonam;
                            id = 1742754652509720;
                            "last_name" = Yadav;
                            name = "Poonam Yadav";
                            picture =     {
                                data =         {
                                    height = 200;
                                    "is_silhouette" = 0;
                                    url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=1742754652509720&height=200&width=200&ext=1537555017&hash=AeSeQD8ShrSSoHz8";
                                    width = 200;
                                };
                            };
                        })*/
                        
                        
                     /*   let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                        self.navigationController?.pushViewController(vc, animated: true)*/
                       
                    } else {
                        
                    }
                })
            }
        })
    
     }
    //MARK: linkd in login
    @IBAction func LinkedInlogin() {
        linkedinHelper.authorizeSuccess({ (token) in
            print("token",token)
            self.fetchLinkedInUserInfo()
                          //This token is useful for fetching profile info from LinkedIn server
        }, error: { (error) in
            
            print(error.localizedDescription)
            //show respective error
        }) {
                print("requestCancel")
            //show sign in cancelled event
        }

    }
    func fetchLinkedInUserInfo()  {
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
            print(response)
            self.SocialDict = response.jsonObject as! NSDictionary
            self.socialLoginType = "LinkedIn"
            print("responsenew",response)
            //  self.SocialDict = result as! NSDictionary
            DispatchQueue.main.async {
                self.userSelectionPopup()
            }
          /*  let userFirstName = responsenew ["firstName"] as? String
            let userlastName = responsenew["lastName"] as? String
            let userId = responsenew["id"] as? String
            let userEmail = responsenew["emailAddress"] as? String*/
            
            
//            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
//            self.navigationController?.pushViewController(vc, animated: true)
            //parse this response which is in the JSON format
        }) {(error) -> Void in
            
            print(error.localizedDescription)
            //handle the error
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:-
    //MARK:- google sign in
    
    
@IBAction func GooglePlusSignin(){

    GIDSignIn.sharedInstance().clientID = "16686680101-l1gv5dlv0k85jllb5orglluub56434pp.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().delegate = self
   

    }
    
   
    @IBAction func nextClicked(sender : UIButton){
        if sender.tag == 1
        {
          userRole = "expert"
        }
            
        else if sender.tag == 2
        {
            userRole = "buyer"
        }
        else{
           userRole = "seller"
        }
        self.LoginwithSocial(SocialLoginType: self.socialLoginType, userinfoDict: self.SocialDict, userRole:userRole )
    }
    
    //MARK: Forhot password Pop up
    func forgotPasswordPopup()  {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier:"ForgotPasswordViewController") as! ForgotPasswordViewController
        let popup = PopupDialog(viewController:vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth:UIScreen.main.bounds.size.width - 80, tapGestureDismissal: true, hideStatusBar: true) {
            
        }
        
        vc.closeBtnClick = {
            popup.dismiss({
                
            })
        }
        vc.submitAction = {
            popup.dismiss({
                self.forgotPasswordAPI(email: vc.userEmail)
            })
        }
        // self.navigationController?.pushViewController(vc, animated: true)
        self.present(popup, animated: true, completion: nil)
        
    }
    func userSelectionPopup()  {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier:"SelectUserViewController") as! SelectUserViewController
        let popup = PopupDialog(viewController:vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth:UIScreen.main.bounds.size.width - 80, tapGestureDismissal: true, hideStatusBar: true) {
            
        }
        
        vc.closeBtnClick = {
            popup.dismiss({
                
            })
        }
        vc.selectionAction = {
            popup.dismiss({
                
                print("hgjhghj")
            self.LoginwithSocial(SocialLoginType: self.socialLoginType, userinfoDict: self.SocialDict, userRole:vc.userType)
            
           })
        }
       // self.navigationController?.pushViewController(vc, animated: true)
       self.present(popup, animated: true, completion: nil)
        
    }
    //MARK: Social Login
    func LoginwithSocial (SocialLoginType: String,userinfoDict: NSDictionary , userRole:String)  {
     var userFirstName : String = ""
     var userlastname : String = ""
     var username : String = ""
     var userEmail : String = ""
     var userphoneNumber : String = ""
     var userSocialId : String = ""
     var UserImage : String = ""
    
      if socialLoginType == "Facebook"
     {
        
        username = (userinfoDict["name"] as? String)!
        userFirstName = (userinfoDict["first_name"] as? String)!
        userlastname = (userinfoDict["last_name"] as? String)!
        userEmail = (userinfoDict["email"] as? String)!
        let picture = userinfoDict["picture"] as! NSDictionary
        let data = picture["data"] as! NSDictionary
        UserImage = (data["url"] as? String)!
        userSocialId = userinfoDict["id"] as! String
     }
     else  if socialLoginType == "LinkedIn"
     {
        userlastname = (userinfoDict ["firstName"] as? String)!
        userlastname = (userinfoDict["lastName"] as? String)!
        userSocialId = (userinfoDict["id"] as? String)!
        userEmail = (userinfoDict["emailAddress"] as? String)!
        username = (userinfoDict["lastName"] as? String)!
     
     }
     else
     {
     
     }
        var urlStr = String()
        var action = String()
        urlStr = baseURL + ApiMethods.getSocialLogin
        action = "social_login"
        
      /*  let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action ,
            "firstname":userFirstName ,
            "lastname":userlastname,
            "username":username       ,
            "email":userEmail,
            "socialType":SocialLoginType,
            "socailId":userSocialId,
            "profileImageLink":UserImage,
            "phonenumber":userphoneNumber,
            "user_role":userRole]*/
      //  var urlStr = String()
       // var action = String()
        urlStr = baseURL + ApiMethods.getSocialLogin
        action = "social_login"
        let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action ,
                      "firstname":userFirstName ,
                      "lastname":userlastname,
                      "username":username       ,
                      "email":userEmail,
                      "socialType":SocialLoginType,
                      "socailId":userSocialId,
                      "profileImageLink":"http://",
                      "phonenumber":userphoneNumber,
                      "user_role":userRole]
        
   /* let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action ,
                  "firstname":"test" ,
                  "lastname":"test",
                  "username":"testing"       ,
                  "email":"test@mail.com",
                  "socialType":"fb",
                  "socailId":"asd3dasdasd33re3dw",
                  "profileImageLink":"http://",
                  "phonenumber":"132456897",
                  "user_role":userRole]*/
        ProjectManager.sharedInstance.showLoader()
        ProjectManager.sharedInstance.callApiWithParameters(urlStr: urlStr, params: params, completion: { (responseDict, error) in
            ProjectManager.sharedInstance.stopLoader()
            
            print("responseDict",responseDict  , error)
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
                        
                        
                        guard let userInfo = responseDict?.value(forKey:"data") as? NSDictionary else {
                            return
                        }
                        guard let userInfoget = userInfo.value(forKey:"data") as? NSDictionary else {
                            return
                        }
                        guard let id = userInfoget["ID"] as? String
                        else
                        {
                            return
                        }
                        
                        var userDefaults = UserDefaults.standard
                        //                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userInfoget)
                        userDefaults.set(String(id), forKey: "userId")
                        userDefaults.set(true, forKey: DefaultsIdentifier.isLogin)
                        userDefaults.synchronize()
                        if let roleArray = userInfo.value(forKey:"roles") as? [String]{
                            if roleArray.count > 0 {
                                let roleStr = roleArray[0]
                                
                                userDefaults.set(roleStr, forKey: "userType")
                                
                                userType = roleStr
                            }
                            
                        }
                        
                
                        let userObj = ProjectManager.sharedInstance.getUserObject(dict: userInfoget as! [String : Any], roleStr: userType)
                        userDefaults.set(userObj.userImage, forKey: DefaultsIdentifier.profileImage)
                        
                        userDefaults.set(userType, forKey: DefaultsIdentifier.Role)
                        userDefaults.set(userObj.userName, forKey:DefaultsIdentifier.username)
                        userDefaults.synchronize()
                        if userType == "expert"
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ProductViewController") as? ProductViewController
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        else
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"ProductViewController") as? ProductViewController
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        
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
    //MARK:-
    //MARK:- Textfield Delegate Methods
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}

extension LoginViewController: GIDSignInDelegate {
    
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("givenName", userId,fullName,givenName)
            // ...
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
         print("will dispatch4")
        print("In didDisconnectWith: \(error.localizedDescription)")
        self.completionBlock?(nil)
    }
    
}

extension LoginViewController: GIDSignInUIDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //stop your loader here
        print("will dispatch")
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
         print("will dispatch1")
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
         print("will dispatch2")
        self.dismiss(animated: true, completion: nil)
    }
    
}
