//
//  FindJobsViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 25/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import DTPhotoViewerController
class UpdateStatusViewController: UIViewController , UITextFieldDelegate , DTPhotoViewerControllerDelegate, UIScrollViewDelegate , UIPickerViewDelegate , UIPickerViewDataSource{
    @IBOutlet weak var statusPicker: UIPickerView!
    
    
    @IBOutlet weak var pickerContainerViw: UIView!
    
    @IBOutlet weak var statusBtn: UIButton!
    
    
    @IBOutlet weak var zipTieTxtFld: UITextField!
     var selectedImageIndex = Int()
    @IBOutlet weak var jobTable: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerViw: UIView!
    @IBOutlet weak var scrollViw: UIScrollView!
    var obj = ProductObject()
    var pickerArray = ["Approved" , "Disapproved"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControlScrollView()
        pickerContainerViw.isHidden = true
        //pickerContainerViw.animHide()
        // Do any additional setup after loading the view.
        self.SetUI()
    }
    
    
    //MARK:-
    //MARK:- Set UI
    func SetUI(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
        
        self.title = "Product"
        DispatchQueue.main.async {
        self.navigationController?.isNavigationBarHidden = false
        }
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
        let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = menuItem
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        
    }
    
    
    func pageControlScrollView() {
        
        for i in 0..<obj.ProductImages.count {
            
            let imgViw = UIImageView(frame: CGRect(x:(CGFloat(i) * UIScreen.main.bounds.size.width), y: 0, width: UIScreen.main.bounds.size.width, height:scrollViw.frame.size.height))
            
            imgViw.tag = i
            imgViw.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(sender:)))
            imgViw.addGestureRecognizer(tap)
            imgViw.sd_setImage(with:URL(string:obj.ProductImages[i].ImageStr.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!), placeholderImage: #imageLiteral(resourceName: "placeholder") , options: .cacheMemoryOnly, completed: { (img, error, cache, url) in
                
            })
            
            scrollViw.addSubview(imgViw)
        }
        scrollViw.contentSize = CGSize(width:UIScreen.main.bounds.size.width * CGFloat(obj.ProductImages.count), height: scrollViw.frame.size.height)
        pageControl.numberOfPages = obj.ProductImages.count
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.pickerContainerViw.isHidden = true
         //   self.pickerContainerViw.animHide()
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        let row = statusPicker.selectedRow(inComponent: 0)
        DispatchQueue.main.async {
               self.pickerContainerViw.isHidden = true
            self.statusBtn.setTitle(self.pickerArray[row], for: .normal)
       // self.pickerContainerViw.animHide()
        }
        
    }
    
    @objc func tapGestureHandler(sender:UITapGestureRecognizer){
        if let viewController = SimplePhotoViewerController(referencedView: (sender.view as! UIImageView), image: (sender.view as! UIImageView).image) {
            selectedImageIndex =  (sender.view as! UIImageView).tag
            viewController.dataSource = self
            viewController.delegate = self
            viewController.moreButton.isHidden = true
            
            self.present(viewController, animated: true, completion: nil)
        }
        
        
    }
    //MARK:-
    //MARK:-  UIPickerView Datasource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    
    //MARK:-
    //MARK:- Custom Methods
    
    @IBAction func updateStatusAction(_ sender: Any) {
     
        let comment:String = (zipTieTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        if statusBtn.currentTitle == "Select Status" {
           self.showAlert(message:"Please Select Status")
        }
        else if comment.isEmpty {
            self.showAlert(message:"Please enter comments")

        }
        else {
                var urlStr = String()
                var action = String()
                urlStr = baseURL + ApiMethods.updateStatusAPI
                action = "expert_status_update"
                let userDefaults = UserDefaults.standard
                if let id = userDefaults.value(forKey: "userId") as? String {
                    // let user = UserInfo
   let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id": id, "product_id":obj.ProductID, "product_status":statusBtn.currentTitle , "productComments":comment]
    ProjectManager.sharedInstance.showLoader()
    ProjectManager.sharedInstance.callApiWithParameters(urlStr: urlStr, params: params as! [String:String], completion: { (responseDict, error) in
        ProjectManager.sharedInstance.stopLoader()
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
            
    guard let msg = (responseDict?.value(forKey:"data") as! [String:Any])["message"] as? String  else {return}
   ProjectManager.sharedInstance.refreshProductDel?.refreshProducts()
   
        DispatchQueue.main.async {
     self.navigationController?.popViewController(animated: true)
      self.showAlert(message: msg)
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
    }
    
    
    @IBAction func statusAction(_ sender: Any) {
        DispatchQueue.main.async {
        self.pickerContainerViw.isHidden = false
        }
        statusPicker.reloadAllComponents()
        //pickerContainerViw.animShow()
    }
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        let x = CGFloat(pageControl.currentPage) * scrollViw.frame.size.width
        scrollViw.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
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

extension UpdateStatusViewController : UITableViewDataSource,UITableViewDelegate{
    //MARK:-
    //MARK:- TablView Delegate And Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"findJobCell", for: indexPath) as? productDetailTableViewCell
        cell?.selectionStyle = .none
        cell?.labelProductTitle.text = obj.ProductName
        cell?.labelProductDescription.text = obj.ProductDescription
        return cell!
    }
}
//MARK: DTPhotoViewerControllerDataSource
extension UpdateStatusViewController: DTPhotoViewerControllerDataSource {
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        // Set text for each item
        if let cell = cell as? CustomPhotoCollectionViewCell {
            cell.extraLabel.text = ""
        }
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        
        return scrollViw
        
        
        
    }
    
    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return self.obj.ProductImages.count
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with:URL(string:self.obj.ProductImages[index].ImageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) , placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .refreshCached) { (img, error, cache, url) in
            
        }
        
        
    }
}
//MARK: DTPhotoViewerControllerDelegate
extension UpdateStatusViewController: SimplePhotoViewerControllerDelegate {
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        
    }
    
    func simplePhotoViewerController(_ viewController: SimplePhotoViewerController, savePhotoAt index: Int) {
        //    UIImageWriteToSavedPhotosAlbum(self.obj.ProductImages[index], nil, nil, nil)
    }
}
