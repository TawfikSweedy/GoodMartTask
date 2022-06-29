//
//  BGAlertPresenter.swift
//
//  Created by TawfiqSweedy on 01/06/2020.
//  Copyright © 2020 TawfiqSweedy. All rights reserved.
//


import UIKit
import SPIndicator

class BGAlertPresenter{
    // MARK: - Display alert
    static public func displayToast(title: String , message : String , type: SPIndicatorHaptic ){
        SPIndicator.present(title: title, message: message, haptic: type)
    }
    // MARK: - Display normal alert
    static public func displayAlert(title: String, message:String,doneBtn:String,forController controller:UIViewController, completion:(()  -> ())? = nil){
           var alertTitle:String?
           var alertMessage:String?
           if message == "" {
            alertMessage = ""
           }
           if title == "" {
               alertTitle = message
               alertMessage = ""
           }else{
               alertTitle = title
               alertMessage = message
           }
           let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: doneBtn, style: .default, handler: { (_) in
            
            completion?()
        }))
           controller.present(alert, animated: true)
       }
}
