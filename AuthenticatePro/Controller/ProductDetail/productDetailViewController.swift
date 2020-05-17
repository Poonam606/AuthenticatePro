//
//  productDetailViewController.swift
//  AuthenticatePro
//
//  Created by Love Verma on 22/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import DTPhotoViewerController
class productDetailViewController: UIViewController , UIScrollViewDelegate , DTPhotoViewerControllerDelegate {

    
    @IBOutlet weak var detailTable: UITableView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var containerViw: UIView!
    
    @IBOutlet weak var scrollViw: UIScrollView!
    
    var selectedImageIndex = Int()
    
    var obj = ProductObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
        SetUI()
        pageControlScrollView()
        getProductDetailFromServer()
        //getProductDetailFromServer()
        // Do any additional setup after loading the view.
    }
    
    func pageControlScrollView() {
        if obj.ProductImages.count > 0{
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
        else {
            pageControl.isHidden = true
             let lbl = UILabel(frame: CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height:scrollViw.frame.size.height))
            lbl.text = "Images not available"
            lbl.textAlignment = .center
            scrollViw.addSubview(lbl)
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
    
    func SetUI(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Medium", size: 18)! , NSAttributedStringKey.foregroundColor:UIColor.white]
        self.title = "Product Detail"
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
            
           
        }
        
        
        
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 75/255.0, blue: 144/255.0, alpha: 1.0)
        let menuItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(menuAction))
        self.navigationItem.leftBarButtonItem = menuItem
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        
    }
    //MARK:-
    //MARK:- Custom Methods
    
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        let x = CGFloat(pageControl.currentPage) * scrollViw.frame.size.width
        scrollViw.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func menuAction()  {
        
        self.navigationController?.popViewController(animated: true)

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
extension productDetailViewController : UITableViewDataSource,UITableViewDelegate{
    
    //MARK:-
    //MARK:- TablView Delegate And Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
           return 1
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"productDetail", for: indexPath) as? productDetailTableViewCell
        cell?.selectionStyle = .none
        cell?.labelProductTitle.text = obj.ProductName
        cell?.labelProductDescription.text = obj.ProductDescription
        
        cell?.apSeal.text = obj.ApSealNo
        cell?.zipTieLbl.text = obj.ZipTieNo
        cell?.expertLbl.text  = obj.ExpertName
        if !obj.Date.isEmpty {
        cell?.dateLbl.text = obj.Date.getDateFromString()
        }
        return cell!
    }
    
    
    func productUrlAction() {
        let url = URL(string:obj.ProductURL.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:]) { (status) in
                
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    //MARK:-
    //MARK:- Product Detail Webservice
    
    func getProductDetailFromServer()  {
        let urlStr = baseURL + ApiMethods.getProductDetail
        let action = "product_details"
        
        
        let params = ["access_key":"bdddas9IEphRsH4EFEuH9o1qasmtgkQ", "action":action , "product_id":obj.ProductID]
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
                       
                        guard let productData = responseDict?.value(forKey:"data") as? [String:Any] else {
                            return
                        }
                        if let expertName = productData["expert_name"] as? String {
                            
                            DispatchQueue.main.async {
                                self.obj.ExpertName = expertName
                                self.detailTable.reloadData()
                            }
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



//MARK: DTPhotoViewerControllerDataSource
extension productDetailViewController: DTPhotoViewerControllerDataSource {
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
extension productDetailViewController: SimplePhotoViewerControllerDelegate {
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

/// Class CollectionViewCell
/// Add extra UI element to photo.
