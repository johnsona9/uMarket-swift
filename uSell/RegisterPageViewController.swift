//
//  RegisterPageViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/6/15.
//
//

import UIKit
import Parse


protocol RegisterPageViewControllerDelegate {
    func userRegistered(controller: RegisterPageViewController)
}

class RegisterPageViewController: UIViewController, UITextFieldDelegate {

    var delegate: RegisterPageViewControllerDelegate?
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleColors()
        self.emailAddressTextField.delegate = self
        self.userPasswordTextField.delegate = self
        self.userConfirmPasswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func registerButtonTouch(sender: AnyObject) {
        
        let userEmail = emailAddressTextField.text;
        let userPassword = userPasswordTextField.text;
        let userConfirmPassword = userConfirmPasswordTextField.text;
        
        //check for empty fields
        
        
        //confirm passwords to make sure they are identical
        
        if (userEmail.isEmpty || userPassword.isEmpty || userConfirmPassword.isEmpty) {
            //display bad stuff
            GlobalConstants.AlertMessage.displayAlertMessage("All fields are required", view: self)
            return;
        }

        else if (userEmail.rangeOfString("@union.edu") == nil ) {
            GlobalConstants.AlertMessage.displayAlertMessage("We currently only support union email addresses, sorry!", view: self)
        }
        
        else if (userPassword != userConfirmPassword) {
            
            //passwords don't match, complain to them
            GlobalConstants.AlertMessage.displayAlertMessage("Passwords do not match", view: self)
            return;
            
        }
            
        else {
            let createdUser = PFUser()
            createdUser.password = userPassword
            createdUser.username = userEmail
            createdUser.email = userEmail
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                createdUser.signUpInBackgroundWithBlock({ (suceeded: Bool, error: NSError?) -> Void in
                    if (error == nil) {
                        self.dismissViewControllerAnimated(false, completion: { () -> Void in
                            self.delegate!.userRegistered(self)
                        })
                    }
                    else {
                        GlobalConstants.AlertMessage.displayAlertMessage("\(error)", view: self)
                    }
                })
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
            }
            
            
            
            
        }

        //display success once data has been sent to parse
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.registerButton.setTitleColor(GlobalConstants.Colors.goldColor, forState: UIControlState.Normal)
        self.cancelButton.setTitleColor(GlobalConstants.Colors.goldColor, forState: UIControlState.Normal)
        self.userPasswordTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.userPasswordTextField.textColor = GlobalConstants.Colors.goldColor
        self.userConfirmPasswordTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.userConfirmPasswordTextField.textColor = GlobalConstants.Colors.goldColor
        self.emailAddressTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.emailAddressTextField.textColor = GlobalConstants.Colors.goldColor
        self.emailAddressTextField.attributedPlaceholder = GlobalConstants.Colors.setPlaceholderColor("email", color: GlobalConstants.Colors.goldColor)
        self.userPasswordTextField.attributedPlaceholder = GlobalConstants.Colors.setPlaceholderColor("password", color: GlobalConstants.Colors.goldColor)
        self.userConfirmPasswordTextField.attributedPlaceholder = GlobalConstants.Colors.setPlaceholderColor("password", color: GlobalConstants.Colors.goldColor)
    }
    
    
    
    

}
