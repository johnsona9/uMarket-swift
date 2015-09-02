//
//  GlobalConstants.swift
//  uSell
//
//  Created by Adam Johnson on 8/17/15.
//
//

import Foundation
import UIKit

struct GlobalConstants {
    struct Colors {
        
        static let backgroundColor = UIColor(red: 200/255, green: 220/255, blue: 220/255, alpha: 1.0)
        
        static let buttonBackgroundColor = UIColor(red: 236/255.0, green: 148/255.0, blue: 89/255.0, alpha: 1.0)
        static let buttonTextColor = UIColor.whiteColor()
        
        static let textFieldBackgroundColor = UIColor.whiteColor()
        static let textFieldTextColor = UIColor(red: 45/255.0, green: 104/255.0, blue: 231/255.0, alpha: 1.0)
        
        static let cellBackgroundColor = UIColor(red: 27/255.0, green: 194/255.0, blue: 229/255.0, alpha: 1.0)
        static let cellTextColor = UIColor(red: 45/255.0, green: 104/255.0, blue: 231/255.0, alpha: 1.0)
        static let cellDetailTextColor = UIColor(red: 45/255.0, green: 104/255.0, blue: 231/255.0, alpha: 1.0)
        static let tableViewSeparatorColor = UIColor(red: 236/255.0, green: 148/255.0, blue: 89/255.0, alpha: 1.0)
        
        static let navigatorBarBackgroundColor = UIColor(red: 200/255, green: 220/255, blue: 220/255, alpha: 1.0)
        static let navigatorBarTextColor = UIColor(red: 236/255.0, green: 148/255.0, blue: 89/255.0, alpha: 1.0)
        
        static let pickerViewTextColor = UIColor(red: 236/255.0, green: 148/255.0, blue: 89/255.0, alpha: 1.0)
        
    }
    
    struct AlertMessage {
        static func displayAlertMessage(userMessage:String, view:UIViewController) -> UIAlertController {
            
            var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
            myAlert.addAction(okAction);
            view.presentViewController(myAlert, animated: true, completion: nil)
            return myAlert
            
        }
    }
    
    struct Departments {
        static let departments = ["ECE", "CSC", "ECO", "PSY", "OTHER"]
    }
}
