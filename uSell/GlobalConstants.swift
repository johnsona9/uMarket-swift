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
        static let backgroundColor = UIColor(red: 80/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1.0)
        static let garnetColor = UIColor(red: 99/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        static let goldColor = UIColor(red: 220/255.0, green: 175/255.0, blue: 90/255.0, alpha: 1.0)
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
}
