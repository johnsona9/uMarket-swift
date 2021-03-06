//
//  PasswordResetViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/17/15.
//
//

import UIKit
import Parse
import Reachability

class PasswordResetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.handleColors()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetButtonTouch(sender: AnyObject) {
        if emailTextField.text != "" {
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                PFUser.requestPasswordResetForEmailInBackground(emailTextField.text!, block: { (success, error) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
            }
        }
        
    }
    
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        
        self.cancelButton.setTitleColor(GlobalConstants.Colors.buttonTextColor, forState: UIControlState.Normal)
        self.cancelButton.backgroundColor = GlobalConstants.Colors.buttonBackgroundColor
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.layer.borderColor = GlobalConstants.Colors.buttonBackgroundColor.CGColor
        
        self.resetButton.setTitleColor(GlobalConstants.Colors.buttonTextColor, forState: UIControlState.Normal)
        self.resetButton.backgroundColor = GlobalConstants.Colors.buttonBackgroundColor
        self.resetButton.layer.cornerRadius = 5
        self.resetButton.layer.borderWidth = 1
        self.resetButton.layer.borderColor = GlobalConstants.Colors.buttonBackgroundColor.CGColor
        
        
        self.emailTextField.backgroundColor = GlobalConstants.Colors.textFieldBackgroundColor
        self.emailTextField.textColor = GlobalConstants.Colors.textFieldTextColor
    }


}
