//
//  ExtensionClass.swift
//  AuthenticatePro
//
//  Created by Love Verma on 10/06/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit

class ExtensionClass: NSObject {

}
extension UIView{
    func animShow(){
        
        UIView.animate(withDuration: 0, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.frame.origin.y = UIScreen.main.bounds.size.height - 200
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0, delay: 0, options: [.curveLinear],
                       animations: {
                        print(self.frame.origin.y)
                        self.frame.origin.y = self.frame.origin.y + 200
                        print("Hide animation",self.frame.origin.y)
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}


extension  UIViewController {
    func showAlert(title: String = "", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
        var hexString: String {
            let hexString = map { String(format: "%02.2hhx", $0) }.joined()
            return hexString
        }
    
}

extension String {
    
    func getDateFromString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let  date = dateFormat.date(from:self )
        dateFormat.dateFormat = "dd-MMM-yyyy"
        return dateFormat.string(from: date!)
    }
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
}
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension Error {
    
    var isConnectivityError: String {
        // let code = self._code || Can safely bridged to NSError, avoid using _ members
        let code = (self as NSError).code
        
        if (code == NSURLErrorTimedOut) {
            return "Request time out" // time-out
        }
        
        if (self._domain != NSURLErrorDomain) {
            return "Server Error" // Cannot be a NSURLConnection error
        }
        
        switch (code) {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
            return "Internet connection error"
        default:
            return "Something went wrong."
        }
    }
    
}
