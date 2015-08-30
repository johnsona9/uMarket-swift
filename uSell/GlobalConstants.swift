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
        
        static let primarySecond = UIColor(red: 27/255.0, green: 194/255.0, blue: 229/255.0, alpha: 1.0)
        static let primaryFirst = UIColor(red: 45/255.0, green: 104/255.0, blue: 231/255.0, alpha: 1.0)
        static let secondaryFirst = UIColor(red: 236/255.0, green: 148/255.0, blue: 89/255.0, alpha: 1.0)
        static let secondarySecond = UIColor(red: 234/255.0, green: 96/255.0, blue: 4/255.0, alpha: 1.0)
        
        
        static let backgroundColor = UIColor(red: 80/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1.0)
        static let garnetColor = UIColor(red: 99/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        static let goldColor = UIColor(red: 220/255.0, green: 175/255.0, blue: 90/255.0, alpha: 1.0)
        static func setPlaceholderColor(string: String, color: UIColor) -> NSAttributedString {
            return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName: color])
        }
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
