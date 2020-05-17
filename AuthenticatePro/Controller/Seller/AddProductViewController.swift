//
//  AddProductViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 06/06/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController ,UITextFieldDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    @IBOutlet weak var labelBrandHide: UILabel!
    
    @IBOutlet weak var heightConstraintBrand: NSLayoutConstraint!
    @IBOutlet weak var textfiledInputBrand: UITextField!
    @IBOutlet weak var collectionViewProductImage: UICollectionView!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var ziptieTxtFld: UITextField!
    @IBOutlet weak var brandPicker: UIPickerView!
    @IBOutlet var pickerView: UIView!
    @IBOutlet weak var Apcredits: UITextField!
    @IBOutlet weak var selectProductPrice: UITextField!
    @IBOutlet weak var textfiledLiveproductURL: UITextField!
    @IBOutlet weak var textfieldbuyingAnItem: UITextField!
    @IBOutlet weak var textfieldBrandName: UITextField!
    @IBOutlet weak var textfiledyourCategory: UITextField!
    @IBOutlet weak var textfiledProductDescription: UITextField!
    @IBOutlet weak var Textfieldproductname: UITextField!
    var brandsArray = [BrandObject]()
    var websiteArray = [String]()
     var productpriceArray = [String]()
    var categoryArray = [BrandObject]()
    var pickerArray = [BrandObject]()
    var pickerWesiteArray = [String]()
    var selectTag = Int()
    var ProductImageArray = [ImageObject]()
    var imagePicker = UIImagePickerController()
    var brandID = String()
    var catID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelBrandHide.isHidden = true
        heightConstraintBrand.constant = 0
        self.title = "Authenticate Now"
        textfieldBrandName.inputView = pickerView
        textfiledyourCategory.inputView = pickerView
        selectProductPrice.inputView = pickerView
         textfieldbuyingAnItem.inputView = pickerView
        let imgObj = ImageObject()
        ProductImageArray.append(imgObj)
        collectionViewProductImage.reloadData()
        SetUI()
        getBrandList()
       // getWebsiteFromServer()
        // getProductPriceFromServer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        self.title = "Authenticate Now"
    }
    func SetUI(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
        self.title = "Products"
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
        let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(menuAction))
        self.navigationItem.leftBarButtonItem = menuItem
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    //MARK:-
    //MARK:- Custom Methods
    @objc func menuAction()  {
        
        
        let vc = mainStoryBoard.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
        
        self.present(vc, animated: true, completion: nil)
    }
    //MARK: Get Website
    func getWebsiteFromServer()
    {
       //ProjectManager.sharedInstance.showLoader()
        ProjectManager.sharedInstance.getWebsite{ (array, status) in
            if status {
                self.websiteArray = array
               self.getProductPriceFromServer()
            }
            else {
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.stopLoader()
                }
                
            }
        }
    }
    //MARK: Get Website
    func getProductPriceFromServer()
    {
       // ProjectManager.sharedInstance.showLoader()
        ProjectManager.sharedInstance.getProductPrices{ (array, status) in
             ProjectManager.sharedInstance.stopLoader()
            if status {
               self.productpriceArray = array
               
            }
            else {
                
                
            }
        }
    }
    //MARK:
    //MARK:Get brand list
    func getBrandList()  {
        ProjectManager.sharedInstance.showLoader()
        ProjectManager.sharedInstance.getBrands { (array, status) in
            if status {
                self.brandsArray = array
                ProjectManager.sharedInstance.getCategories(completion: { (categories, success) in
                    
                    
//                    DispatchQueue.main.async {
//                        ProjectManager.sharedInstance.stopLoader()
//                    }
                    
                    if success {
                        self.categoryArray = categories
                        self.getWebsiteFromServer()
                    }
                })
            }
            else {
                DispatchQueue.main.async {
                    ProjectManager.sharedInstance.stopLoader()
                }
                
            }
        }
    }

    @IBAction func buttonSubmitClicked(_ sender: Any) {
        self.view.endEditing(true)
        let productName:String = (Textfieldproductname.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
         let zipTie:String = (ziptieTxtFld.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let brandName:String = (textfieldBrandName.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let category:String = (textfiledyourCategory.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let productDescription:String = (textfiledProductDescription.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let buyingItem:String = (textfieldbuyingAnItem.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let liveProductuRL:String = (textfiledLiveproductURL.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let productPrice:String = (selectProductPrice.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
          let appCredits:String = (Apcredits.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        let  textfilebrandinput:String = (textfiledInputBrand.text?.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines))!
        if userType == "expert" && zipTie.isEmpty {
             self.showAlert(title:"Error", message: "Please enter zip tie number")
        }
        
       else  if productName.isEmpty
        {
         self.showAlert(title:"Error", message: "Please enter product name")
        }
        else if category.isEmpty
        {
          self.showAlert(title:"Error", message: "Please select category")
        }
        else if brandName.isEmpty
        {
            self.showAlert(title:"Error", message: "Please select brand")
        }
        else if buyingItem.isEmpty
        {
            self.showAlert(title:"Error", message: "Please select website")
        }
        else if liveProductuRL.isEmpty
        {
          self.showAlert(title:"Error", message: "Please enter live product url.")
        }
        else if productPrice.isEmpty
        {
          self.showAlert(title:"Error", message: "Please select product price")
        }
        else if brandName == "Other" && textfilebrandinput.isEmpty
        {
           self.showAlert(title:"Error", message: "Please enter brand")
        }
       
        else
        {
           print(brandName)
            
           let urlStr = baseURL + ApiMethods.addProductAPI
            let action = "add_product"
        let userDefaults = UserDefaults.standard
        if let id = userDefaults.value(forKey: "userId") as? String {
        
       
            var productImgArr = [UIImage]()
            for i in ProductImageArray {
                if i.image != nil {
                    productImgArr.append(i.image!)
                }
            }
          //  let image = uploadBtn.currentImage
            let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "product_name":productName , "zipTie_no":zipTie,"product_description":productDescription,"category_name": catID,"product_brand": brandID,"product_url": liveProductuRL,"website_name": "Ebay","product_price": productPrice,"product_credit": appCredits,"created_by": id , "product_image[]":productImgArr] as [String : Any]
            ProjectManager.sharedInstance.showLoader()
            
            ProjectManager.sharedInstance.callApiWihUploadImages(urlStr: urlStr, params: params, completion: { (responseDict, error) in
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
                            
                            
                            guard let msg = (responseDict?.value(forKey:"data") as! [String:Any])["message"] as? String  else {return}
                            DispatchQueue.main.async {
                                self.selectProductPrice.text = ""
                                self.textfiledLiveproductURL.text = ""
                                self.textfieldBrandName.text = ""
                                self.textfiledyourCategory.text = ""
                                self.ziptieTxtFld.text = ""
                                self.textfieldbuyingAnItem.text = ""
                                self.Textfieldproductname.text = ""
                                self.textfiledProductDescription.text = ""
                                self.selectProductPrice.text = ""
                                self.Apcredits.text = ""
                                self.catID = ""
                                self.brandID = ""
                                
                                self.showAlert(message: msg)
                                
                            }
                            
                            
                            
                        }
                    }
                        
                    else {
                        self.showAlert(message:"Server Error")
                    }
                    
                }
                
            })
            
            
        }
        
    }
            
        
    }
    //MARK: Done And Cancel button Action
    @IBAction func buttonDoneClicked(_ sender: Any) {
    //    self.categoryBtn.setTitle(self.pickerArray[row].Name, for: .normal)
        let row = brandPicker.selectedRow(inComponent: 0)
        if selectTag == 1
        {
            catID = self.pickerArray[row].TermID
        self.textfiledyourCategory.text = self.pickerArray[row].Name
        }
        else if selectTag == 2
        {
            print("brandname",self.pickerArray[row].Name)
            brandID = self.pickerArray[row].TermID
            self.textfieldBrandName.text = self.pickerArray[row].Name
            if self.textfieldBrandName.text == "Other"
            {
             heightConstraintBrand.constant = 40
             labelBrandHide.isHidden = false
              textfiledInputBrand.becomeFirstResponder()
            }
            else
            {
                heightConstraintBrand.constant = 0
                labelBrandHide.isHidden = true
                
            }
        }
        else if selectTag == 4
        {
           
            self.textfieldbuyingAnItem.text = self.pickerWesiteArray[row]
        }
        else if selectTag == 3
        {
           
            self.selectProductPrice.text = self.pickerWesiteArray[row]
        }
        self.view.endEditing(true)
     //brandPicker.isHidden = true
    }
    
    @IBAction func buttoncancelClicked(_ sender: Any) {
       self.view.endEditing(true)
    }
    @objc func selectImageAction(sender:UIButton)  {
        if ProductImageArray.count < 12 && sender.tag == 0
        {
            selectTag = 0
            self.openActionSheet()
            
        }
        else if ProductImageArray.count > 11
        {
            self.showAlert(message: "You can upload maximum 10 images")
        }
    }
    @objc func buttonCrossClicked(sender: UIButton)  {
        print(sender.tag)
        if sender.tag > 0{
            ProductImageArray.remove(at: sender.tag)
            collectionViewProductImage.reloadData()
        }
        
    }
    //MARK:-
    //MARK:- IBAction Methods
    
    func openActionSheet() {
    
        
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
         otherwise app will crash on iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }*/
        
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
            let imgObj = ImageObject()
            imgObj.image = pickedImage
            ProductImageArray.append(imgObj)
           //  uploadBtn.setImage(pickedImage, for: .normal)
        }
        else if  let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
          //  uploadBtn.setImage(pickedImage, for: .normal)
            let imgObj = ImageObject()
            imgObj.image = pickedImage
            ProductImageArray.append(imgObj)
        }
         self.collectionViewProductImage.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }

 
    
    //MARK:-
    //MARK:- Textfiled delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textfiledyourCategory
        {
            selectTag = 1
            pickerArray = self.categoryArray
        }
        else if textField == textfieldBrandName
        {
            selectTag = 2
            pickerArray = self.brandsArray
        }
        else if textField == selectProductPrice
        {
            selectTag = 3
            pickerWesiteArray = self.productpriceArray
        }
        else if textField == textfieldbuyingAnItem {
            selectTag = 4
            pickerWesiteArray = self.websiteArray
            
            
        }
       brandPicker.reloadAllComponents()
        
    }
    
}
extension AddProductViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectTag > 2 {
        
            return pickerWesiteArray.count
        }
        else {
        return pickerArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectTag >  2 {
            return pickerWesiteArray[row]
        }
        else {
        
        return pickerArray[row].Name
        }
    }
}
extension AddProductViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  ProductImageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadProductExpert", for: indexPath) as! AddRquestCollectionViewCell
        
        
      if indexPath.row == 0 {
            cell.buttonDelete.isHidden = false
            cell.crossbutton.isHidden = true
            cell.imageProduct.image = #imageLiteral(resourceName: "upload-1")
            cell.buttonDelete.tag = indexPath.row
            cell.buttonDelete.addTarget(self, action: #selector(selectImageAction(sender: )), for: .touchUpInside)
        }
        else {
            cell.crossbutton.isHidden = false
            cell.crossbutton.image = #imageLiteral(resourceName: "Cross")
            cell.buttonDelete.isHidden = false
            cell.imageProduct.image = ProductImageArray[indexPath.item].image
            cell.buttonDelete.tag = indexPath.row
            cell.buttonDelete.addTarget(self, action: #selector(buttonCrossClicked(sender:)),for:.touchUpInside)
        }
        
        return cell
    }
    
    
}
