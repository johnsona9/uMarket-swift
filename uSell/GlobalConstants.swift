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
        static let departments = ["AAH", "ACC", "AFR", "AIS", "ADA", "ANT", "ARB", "AST", "ATH", "AVA", "BCH", "BIO", "BNG", "CHM", "CHN", "CLS", "CSC", "ECE", "ECO", "EGL", "ENS", "ESC", "FLM", "FPR", "FRN", "GEO", "GER", "GRK", "HCM", "HEB", "HBR", "HST", "IDM", "ITL", "JPN", "LAS", "LAT", "MTH", "MBA", "MER", "MLL", "AMU", "PHL", "IMP", "PHY", "POR", "PSC", "PSY", "REL", "MLT", "RUS", "SMT", "SOC", "SPN", "SRS", "GSW", "OTHER"].sorted { $0 < $1 }
    }
}
