//
//  AddRequestVC.swift
//  AuthenticatePro
//
//  Created by Love Verma on 20/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class AddRequestVC: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var recieptImageBtn: UIButton!
    @IBOutlet weak var textfiledPhoneNumber: UITextField!
    @IBOutlet weak var textfiledCustomerName: UITextField!
    @IBOutlet weak var TextfiledProductName: UITextField!
    

    @IBOutlet weak var collectionViewProductimage: UICollectionView!
    
    var selectTag = Int()
    //MARK:-
    //MARK:- IBOutlets
    
    @IBOutlet weak var submitBtn: UIButton!
    var ProductImageArray = [ImageObject]()
      var imagePicker = UIImagePickerController()
    //MARK:-
    //MARK:- View Life Cycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
        let imgObj = ImageObject()
        ProductImageArray.append(imgObj)
        collectionViewProductimage.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        SetUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       //  super.viewWillDisappear(animated)
        
            super.viewWillDisappear(animated)
            DispatchQueue.main.async {
               self.navigationController?.isNavigationBarHidden = false
            }
            
        
        
    }
    
    func SetUI(){
    
       self.submitBtn.setCornerRadius(radius:26)
       self.navigationController?.navigationBar.tintColor = UIColor.white
     self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
       self.title = "Add Request"
       self.navigationController?.isNavigationBarHidden = false
       self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
       let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(menuAction))
       self.navigationItem.leftBarButtonItem = menuItem
    }
    
    //MARK:-
    //MARK:- Custom Methods
    @objc func menuAction()  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"LeftMenuNavigationController")
        
        self.present(vc!, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK:- Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
         otherwise app will crash on iPad */
        /* switch UIDevice.current.userInterfaceIdiom {
         case .pad:
         // alert.popoverPresentationController?.sourceView = self.userImgViw
         alert.popoverPresentationController?.sourceRect = self.userImgViw.bounds
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
    @IBAction func recieptAction(_ sender: Any) {
        
        selectTag = 1
         self.openActionSheet()
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
            if selectTag == 0 {
                let imgObj = ImageObject()
                imgObj.image = pickedImage
                ProductImageArray.append(imgObj)
            }
            else {
                recieptImageBtn.setImage(pickedImage, for: .normal)
            }
          
        }
        else if  let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            if selectTag == 0 {
                let imgObj = ImageObject()
                imgObj.image = pickedImage
                ProductImageArray.append(imgObj)
            }
            else {
                recieptImageBtn.setImage(pickedImage, for: .normal)
            }
        }
        self.collectionViewProductimage.reloadData()
       // profieChk =  true
        picker.dismiss(animated: true, completion: nil)
    }
    @objc func buttonCrossClicked(sender: UIButton)  {
        print(sender.tag)
        if sender.tag > 0{
            ProductImageArray.remove(at: sender.tag)
            collectionViewProductimage.reloadData()
        }
        
    }
    
    @IBAction func buttonSubmitClicked(_ sender: Any) {
        let productName:String =  (self.TextfiledProductName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        let customerName:String =  (self.textfiledCustomerName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        let phoneNumber:String =  (self.textfiledPhoneNumber.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        let action = "product_request_by_expert"
        
        if productName.isEmpty {
            self.showAlert(message: "Please enter product name.")
        }
        else  if customerName.isEmpty {
            self.showAlert(message: "Please enter customer name.")
        }
        else  if phoneNumber.isEmpty {
            self.showAlert(message: "Please enter phone number.")
        }
        else {
    
        let urlStr = baseURL + ApiMethods.addBuyerRequest
            
            let userDefaults = UserDefaults.standard
            if let id = userDefaults.value(forKey: "userId") as? String {
                
        var reciptImgArr = [UIImage]()
        if recieptImageBtn.currentImage == #imageLiteral(resourceName: "upload-1") {
            reciptImgArr = []
        }
        else {
            reciptImgArr.append(recieptImageBtn.currentImage!)

        }
                
                var productImgArr = [UIImage]()
                for i in ProductImageArray {
                    if i.image != nil {
                        productImgArr.append(i.image!)
                    }
                }
       
        let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "user_id": id , "product_name":productName , "customer_name":customerName,
            "phone_no":phoneNumber,
            "receipt_image":reciptImgArr,
            "product_image[]": productImgArr] as [String : Any]
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
                    guard let code = responseDict?.value(forKey:"code")  as? String  else {return}
        
                    if code != "200" {
                        guard let msg = (responseDict?.value(forKey:"data") as? NSDictionary)?.value(forKey:"message") as? String  else {return}
        
                        self.showAlert(message: msg)
                    }
                    else {
        
                        
                        
                        guard let msg = (responseDict?.value(forKey:"data") as? NSDictionary)?.value(forKey:"message") as? String  else {return}
        
                        DispatchQueue.main.async {
                            self.showAlert(message: msg)
                            self.TextfiledProductName.text = ""
                            self.textfiledPhoneNumber.text = ""
                            self.textfiledCustomerName.text = ""
                            self.recieptImageBtn.setImage(#imageLiteral(resourceName: "upload-1"), for: .normal)
                            let imgObj = ImageObject()
                            self.ProductImageArray = [imgObj]
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
    
}
extension AddRequestVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return  ProductImageArray.count
       
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadProduct", for: indexPath) as! AddRquestCollectionViewCell
        
        
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
