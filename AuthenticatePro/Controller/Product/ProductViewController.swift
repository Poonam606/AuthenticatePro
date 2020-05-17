//
//  ProductViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 21/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import SideMenu
import SDWebImage

class ProductViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var searchBarr: UISearchBar!
    //MARK:-
    //MARK:- IBOutlets
    @IBOutlet weak var productTable: UITableView!
    var productsArray = [ProductObject]()
    var isHiddenMenu = Bool()
    var productType = String()
    var timer: Timer?
    //MARK:-
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
        setupSideMenu()
      
        getProductsFromServer()
        // Do any additional setup after loading the view.
    }
    func SetUI(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
        self.title = "Products"
        DispatchQueue.main.async {
        self.navigationController?.isNavigationBarHidden = false
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
        
        if isHiddenMenu {
            let backItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backAction))
            self.navigationItem.leftBarButtonItem = backItem
        }
        else {
            let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(menuAction))
            self.navigationItem.leftBarButtonItem = menuItem
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        self.title = "Products"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.title = ""
    }
   @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
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
    //MARK:-
    //MARK:- Get Search Products
    func getSearchProductsFromServer(searchtext: String)  {
        
        let userDefaults = UserDefaults.standard
        if let id = userDefaults.value(forKey: "userId") as? String {
            var urlStr = String()
            var action = String()
            var params = [String:Any]()
          
                urlStr = baseURL + ApiMethods.searchAuthenticateAPI
                action = "search_authentic_products"
                params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "search_keyword":searchtext]
           // }
          /*  else if self.productType == "SellerAuthenticated"
            {
                urlStr = baseURL + ApiMethods.searchUnAuthenticateAPI
                action = "search_unauthentic_products"
                params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id":id,"search_keyword":searchtext]
                
          }*/
           
            DispatchQueue.main.async {
                ProjectManager.sharedInstance.showLoader()
            }
            
            ProjectManager.sharedInstance.callApiWithParameters(urlStr: urlStr, params: params, completion: { (responseDict, error) in
                ProjectManager.sharedInstance.stopLoader()
                
              //  print(responseDict  , error)
                if error == nil {
                    guard let status = responseDict?.value(forKey:"status") as? String else{
                        
                        self.showAlert(message:"Server Error")
                        return
                    }
                    if status == "success" {
                        guard let code = responseDict?.value(forKey:"code")  as? String  else {return}
                        
                        if code != "200" {
                            self.productTable.isHidden = true
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
                                    self.productTable.isHidden = false
                                }
                                else
                                {
                                    self.productTable.isHidden = true
                                }
                                self.productTable.reloadData()
                            }
                            
                            
                        }
                    }
                    else {
                        self.productTable.isHidden = true
                        guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {
                            self.showAlert(message:"Server Error")
                            return}
                        
                        self.showAlert(message: msg)
                        
                    }
                    
                }
                
            })
        }
    }
    //MARK:-
    //MARK:- Get Products Webservice
    func getProductsFromServer() {
        self.view.endEditing(true)
        let userDefaults = UserDefaults.standard
        if let id = userDefaults.value(forKey: "userId") as? String {
        var urlStr = String()
        var action = String()
        var params = [String:Any]()
        if self.productType == "Pending" {
            urlStr = baseURL + ApiMethods.getPendingProducts
            action = "pending_products"
            params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id":id]
        }
        else if self.productType == "SellerAuthenticated"
        {
            urlStr = baseURL + ApiMethods.getSellerAuthenicatedProduct
            action = "authentic_product_seller"
            params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "seller_id":id]

        }
        else {
            urlStr = baseURL + ApiMethods.getAuthenticProducts
            action = "authentic_products"
            params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action]
        }
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
                    DispatchQueue.main.async {
                        ProjectManager.sharedInstance.stopLoader()
                    }
                    guard let code = responseDict?.value(forKey:"code")  as? String  else {return}
                    
                    if code != "200" {
                        self.productTable.isHidden = true
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
                                self.productTable.isHidden = false
                            }
                            else
                            {
                                self.productTable.isHidden = true
                            }
                            self.productTable.reloadData()
                        }
                   }
                }
                else {
                    DispatchQueue.main.async {
                        ProjectManager.sharedInstance.stopLoader()
                    }
                    self.productTable.isHidden = true
                    guard let msg = (responseDict?.value(forKey:"data") as! NSDictionary).value(forKey:"message") as? String  else {
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
    @objc func menuAction()  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
        
        self.present(vc!, animated: true, completion: nil)
    }
    //MARK:-
    //MARK:- TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 132
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProductViewCell = tableView.dequeueReusableCell(withIdentifier:"ProductViewCell", for: indexPath) as!
        ProductViewCell
        cell.selectionStyle = .none
        let obj = self.productsArray[indexPath.row]
        cell.nameLbl.text = obj.ProductName
        cell.websiteNameLbl.text = "Website: \(obj.WebsiteName)"
        if !obj.ApSealNo.isEmpty {
            cell.apSealLbl.text = "AP Seal: #\(obj.ApSealNo)"
        }
        else {
            cell.apSealLbl.text = ""
        }
        if obj.AdminStatus == "approved" {
        cell.logoImg.image = #imageLiteral(resourceName: "launch-screen-logo")
            
        }
        else {
        cell.logoImg.image = #imageLiteral(resourceName: "no-authentic")
        }
        
        if obj.ZipTieNo.isEmpty {
            cell.zipTieNoLbl.text = ""
        }
        else {
            cell.zipTieNoLbl.text = "Zip Tie: #\(obj.ZipTieNo)"
        }
        
        if obj.ProductImages.count > 0 {
        cell.productImg.sd_setImage(with:URL(string:obj.ProductImages[0].ImageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage:#imageLiteral(resourceName: "placeholder"), options: SDWebImageOptions.cacheMemoryOnly) { (img, error,cache, url) in
            
        }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = productsArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "productDetailViewController") as! productDetailViewController
        vc.obj = obj
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
    }
    
}
extension ProductViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
    
}
extension ProductViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
       if searchText.count <= 0
        {
            DispatchQueue.main.async {
              searchBar.resignFirstResponder()
            }
         
        // searchBar.endEditing(true)
         self.view.endEditing(true)
         self.getProductsFromServer()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text!.count) > 0
        { DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
         self.view.endEditing(true)
         self.getSearchProductsFromServer(searchtext: searchBar.text!)
        }
    }
    func  searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text!.count) <= 0
        {
           searchBar.endEditing(true)
            self.view.endEditing(true)
            self.getProductsFromServer()
        }
        }
    

}
