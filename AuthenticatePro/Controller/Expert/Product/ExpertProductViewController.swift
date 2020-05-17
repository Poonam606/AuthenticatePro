//
//  ExpertProductViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 24/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import  SDWebImage
class ExpertProductViewController: UIViewController {
    @IBOutlet weak var tableProduct: UITableView!
    var productType = String()
     var productsArray = [ProductObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.SetUI()
    }
    
    
    //MARK:- Set UI
    func SetUI(){
    self.navigationController?.navigationBar.tintColor = UIColor.white
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
    self.title = "Find Jobs"
    DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
        let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(menuAction))
        self.navigationItem.leftBarButtonItem = menuItem
        let searchItem = UIBarButtonItem(image:#imageLiteral(resourceName: "searchIcon"), style: .plain, target: self, action: #selector(searchAction))
       // self.navigationItem.rightBarButtonItem = searchItem
        getProductsFromServerByExpert()
    }
    //MARK:-
    //MARK:- Custom Methods
    @objc func searchAction(){
    }
    @objc func menuAction()  {
        let story = UIStoryboard(name:"Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
         userType = "expert"
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonApplyClicked(_ sender: Any) {
        let obj = self.productsArray[(sender as AnyObject).tag]
        let userDefaults = UserDefaults.standard
        let id = userDefaults.value(forKey: "userId") as! String
        var urlStr = String()
        var action = String()
        var params = [String:Any]()
       
            urlStr = baseURL + ApiMethods.applyToJobByExpert
            action = "apply_request_to_job_by_expert"
        params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "expert_id":id,"product_id":obj.ProductID]
        DispatchQueue.main.async {
            ProjectManager.sharedInstance.showLoader()
        }
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
                        self.tableProduct.isHidden = true
                        guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {return}
                        
                        self.showAlert(message: msg)
                    }
                    else {
                        
                        
                        guard let productData = responseDict?.value(forKey:"data") as? String else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "", message: "Job Applied Successfully.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in
                                let vc:ExpertYourJobsViewController = expertStoryBoard.instantiateViewController(withIdentifier:"ExpertYourJobsViewController") as! ExpertYourJobsViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                           
                        }
                        
                         // self.showAlert(message:productData)
                        print("productdata",productData)
                        // self.getProductsFromServerByExpert()
                        }
                }
                else {
                    self.tableProduct.isHidden = true
                    guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {
                        self.showAlert(message:"Server Error")
                        return}
                    
                    self.showAlert(message: msg)
                    
                }
                
            }
            
        })
        
    }
    //MARK:-
    //MARK:- Get Products by Expert Webservice
   
   func getProductsFromServerByExpert()  {
        print("expertdata")
        let userDefaults = UserDefaults.standard
        if let id = userDefaults.value(forKey: "userId") as? String {
            var urlStr = String()
            var action = String()
            var params = [String:Any]()
            
                urlStr = baseURL + ApiMethods.getPendingProducts
                action = "pending_products"
                params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id":id]
            
    
    

            DispatchQueue.main.async {
                ProjectManager.sharedInstance.showLoader()
            }
            
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
                            self.tableProduct.isHidden = true
                            guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {return}
                            
                            self.showAlert(message: msg)
                        }
                        else {
                            
                            
                            guard let productData = responseDict?.value(forKey:"data") as? NSArray else {
                                return
                            }
                            
                            self.productsArray = ProjectManager.sharedInstance.getProductObjects(array: productData)
                            DispatchQueue.main.async {
                                if self.productsArray.count > 0
                                {
                                    self.tableProduct.isHidden = false
                                }
                                else
                                {
                                    self.tableProduct.isHidden = true
                                }
                                self.tableProduct.reloadData()
                            }
                            
                            
                        }
                    }
                    else {
                        self.tableProduct.isHidden = true
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
}
extension ExpertProductViewController : UITableViewDelegate,UITableViewDataSource
{
    //MARK:- TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExpertProductTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ExpertProductTableViewCell", for: indexPath) as!
        ExpertProductTableViewCell
        cell.selectionStyle = .none
       
      //  let obj = self.productsArray[indexPath.row]
        let obj = self.productsArray[indexPath.row]
        cell.nameLbl.text = obj.ProductName
        if obj.ZipTieNo.isEmpty {
            cell.labelCategory.text = ""
            
        }
        else {
            cell.labelCategory.text = "Zip Tie: #\(obj.ZipTieNo)"
            
        }
        cell.labelWebSite.text = "Website: \(obj.WebsiteName)"
        
        if obj.ApSealNo.isEmpty {
            cell.BrandName.text = ""
            
        }
        else {
            cell.BrandName.text = "AP Seal: #\(obj.ApSealNo)"
            
        }
        if obj.ProductImages.count > 0 { cell.productImg.sd_setImage(with:URL(string:obj.ProductImages[0].ImageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage:#imageLiteral(resourceName: "placeholder"), options: SDWebImageOptions.cacheMemoryOnly) { (img, error,cache, url) in
            }
        }
        else{
            cell.productImg.image = #imageLiteral(resourceName: "placeholder")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = productsArray[indexPath.row]
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "productDetailViewController") as! productDetailViewController
        vc.obj = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

