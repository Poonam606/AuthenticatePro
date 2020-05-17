//
//  AuthenticateThirdVC.swift
//  AuthenticatePro
//
//  Created by Love Verma on 13/12/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class AuthenticateThirdVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var imageCollectionView: UICollectionView!
    var imagePicker = UIImagePickerController()
    var imageArray = [ImageObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Authenticate Now"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Authenticate Now"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    @IBAction func nextAction(_ sender: Any) {
        let vc = sellerStoryBoard.instantiateViewController(withIdentifier:"AuthenticateFourthVC") as! AuthenticateFourthVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell() }
        if indexPath.row == self.imageArray.count {
            cell.productImageViw.image = #imageLiteral(resourceName: "upload-1")
            cell.deleteImgviw.isHidden = true
            let tapgesture = UITapGestureRecognizer(target:self, action:#selector(imageTapHandler(sender:)))
           cell.productImageViw.isUserInteractionEnabled = true
           cell.productImageViw.addGestureRecognizer(tapgesture)
            
            
        } else {
            cell.deleteImgBtn.tag = indexPath.row
            cell.deleteImgBtn.addTarget(self, action: #selector(deleteImgAction(_:)), for: .touchUpInside)
            cell.deleteImgviw.isHidden = false
            cell.productImageViw.image = imageArray[indexPath.row].image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 40)/3
        return CGSize(width:width , height:width)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func imageTapHandler(sender:UITapGestureRecognizer) {
        openActionSheet()
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
        
    @objc func deleteImgAction(_ sender: UIButton) {
        
        if sender.tag != imageArray.count{
            imageArray.remove(at: sender.tag)
            imageCollectionView.reloadData()
        }
    }
    //MARK:-
        //MARK:- ImagePicker delegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                // imageViewPic.contentMode = .scaleToFill
                let imgObj = ImageObject()
                imgObj.image = pickedImage
                imageArray.append(imgObj)
                //  uploadBtn.setImage(pickedImage, for: .normal)
            }
            else if  let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                // imageViewPic.contentMode = .scaleToFill
                //  uploadBtn.setImage(pickedImage, for: .normal)
                let imgObj = ImageObject()
                imgObj.image = pickedImage
                imageArray.append(imgObj)
            }
            self.imageCollectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
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
