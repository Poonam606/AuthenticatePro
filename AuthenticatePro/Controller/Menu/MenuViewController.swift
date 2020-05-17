//
//  MenuViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 23/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var userImageViw: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var menuTable: UITableView!
    var menuArray = ["Add Request" , "Products" , "Profile" , "Contact Us" ,"Logout"]
    var expertArray = ["Find Jobs" , "Products" , "Your Jobs","Authenticate Now","Profile" , "Contact Us" ,"Logout"]
    var menuSellerArray = ["Authenticate Now" , "Products" , "Profile" , "My Authenticated Products" , "Pending Authentication", "Credits", "Contact Us" ,"Logout"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userType == "seller"{
            menuArray = menuSellerArray
        }
        else if userType == "expert" {
            menuArray = expertArray
        }
        let userImgStr = UserDefaults.standard.string(forKey:DefaultsIdentifier.profileImage)
        
        userImageViw.sd_setImage(with: URL(string:(userImgStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!), placeholderImage: #imageLiteral(resourceName: "Screen Shot 2018-05-21 at 11.56.59 PM"), options: .refreshCached) { (img, error, cache, url) in
        
        }
        let username  = UserDefaults.standard.string(forKey:DefaultsIdentifier.username)
        self.usernameLbl.text = username
        self.navigationController?.isNavigationBarHidden = true
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuTable.tvFadeCell()
    }
    @IBAction func crossAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier:"MenuCell", for: indexPath) as! MenuCell
        cell.selectionStyle = .none
        if userType == "expert" {
            cell.titleLbl.text = expertArray[indexPath.row]
        }
        else if userType == "seller" {
            cell.titleLbl.text = menuSellerArray[indexPath.row]
        }
        else  if userType == "buyer"{
        cell.titleLbl.text = menuArray[indexPath.row]
        }
        cell.titleLbl.numberOfLines = 0
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath) as! MenuCell
        cell.contentView.backgroundColor = UIColor(red: 92/255.0, green: 94/255.0, blue: 106/255.0, alpha: 0.4)
        cell.titleLbl.font = UIFont(name:"Montserrat-Bold" , size: 16)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath) as! MenuCell
        cell.contentView.backgroundColor = .clear
        cell.titleLbl.font = UIFont(name:"Montserrat" , size: 16)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.dismiss(animated: true) {
        //9!VvPZp5m&sRodHIdtVewV2N
        if userType == "expert" {
             if indexPath.row == 0 {
                let addProduct = expertStoryBoard.instantiateViewController(withIdentifier: "ExpertProductViewController") as! ExpertProductViewController
                self.navigationController?.pushViewController(addProduct, animated: true)
            }
            else if indexPath.row == 1 {
                let Product = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                self.navigationController?.pushViewController(Product, animated: true)
            }
            else if indexPath.row == 2 {
               let yourJobs = expertStoryBoard.instantiateViewController(withIdentifier: "ExpertYourJobsViewController") as! ExpertYourJobsViewController
            self.navigationController?.pushViewController(yourJobs, animated: true)
            }
             else if indexPath.row == 3 {
                let story = UIStoryboard(name:"Seller", bundle:nil)
                let addProduct = story.instantiateViewController(withIdentifier: "AuthenticateFirstVC") as! AuthenticateFirstVC
                self.navigationController?.pushViewController(addProduct, animated: true)
             }
            else if indexPath.row == 4 {
                let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(profile, animated: true)
            } else if indexPath.row == 5 {
                let contact = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                 self.navigationController?.pushViewController(contact, animated: true)
             } else if indexPath.row == 6{
                UserDefaults.standard.set(false, forKey: DefaultsIdentifier.isLogin)
                UserDefaults.standard.synchronize()
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                 self.navigationController?.pushViewController(login, animated: false)
            }
        }
        
        else if userType == "buyer"  {
        if indexPath.row == 0 {
            let story = UIStoryboard(name:"Seller", bundle:nil)
            let addProduct = story.instantiateViewController(withIdentifier: "AuthenticateFirstVC") as! AuthenticateFirstVC
            self.navigationController?.pushViewController(addProduct, animated: true)
            }
            else if indexPath.row == 1 {
                let Product = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                self.navigationController?.pushViewController(Product, animated: true)
            }
            else if indexPath.row == 2 {
                let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(profile, animated: true)
            }
        else if indexPath.row == 3 {
            let contact = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            self.navigationController?.pushViewController(contact, animated: true)
        }
            else if indexPath.row == 4{
            
            UserDefaults.standard.set(false, forKey: DefaultsIdentifier.isLogin)
            UserDefaults.standard.synchronize()
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: false)
                
                /* let addProduct = self.storyboard?.instantiateViewController(withIdentifier: "AddRequestVC") as! AddRequestVC
                 self.navigationController?.pushViewController(addProduct, animated: true)*/
            }
        }
        else
        {
            let storyBoard = UIStoryboard(name:"Seller", bundle: nil)
            
         if indexPath.row == 0{
            let story = UIStoryboard(name:"Seller", bundle:nil)
            let addProduct = story.instantiateViewController(withIdentifier: "AuthenticateFirstVC") as! AuthenticateFirstVC
            self.navigationController?.pushViewController(addProduct, animated: true)
            }
            else if indexPath.row == 1 {
                let Product = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                self.navigationController?.pushViewController(Product, animated: true)
            }
            else if indexPath.row == 2 {
                let profile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(profile, animated: true)
            }
         else if indexPath.row == 3 {
            
            let Product = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            Product.productType = "SellerAuthenticated"
            self.navigationController?.pushViewController(Product, animated: true)
         }
    else if indexPath.row == 4 {
            
            let Product = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            Product.productType = "Pending"
            self.navigationController?.pushViewController(Product, animated: true)
            }
         else if indexPath.row == 6 {
            let contact = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            self.navigationController?.pushViewController(contact, animated: true)
         }
            else if indexPath.row == 7{
            UserDefaults.standard.set(false, forKey: DefaultsIdentifier.isLogin)
            UserDefaults.standard.synchronize()
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: false)
                /* let addProduct = self.storyboard?.instantiateViewController(withIdentifier: "AddRequestVC") as! AddRequestVC
                 self.navigationController?.pushViewController(addProduct, animated: true)*/
            }
        }
        //}
       
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
extension UITableView {
    func tvFadeCell() {
        self.reloadData()
        var delayCounter = 0.0
        for cell in self.visibleCells {
            cell.alpha = 0.0
            UIView.animate(withDuration: TimeInterval(delayCounter),animations: {
                cell.alpha = 1.0
            }, completion: nil)
            delayCounter += 0.60
        }
    }
}
