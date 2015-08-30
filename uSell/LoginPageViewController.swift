//
//  LoginPageViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/6/15.
//
//

import UIKit
import Parse

class LoginPageViewController: UIViewController, RegisterPageViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.handleColors()
        // Do any additional setup after loading the view.
//        if (PFUser.currentUser()?.username != nil) {
//            self.performSegueWithIdentifier("loginToMainSegue", sender: self)
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func userRegistered(controller: RegisterPageViewController) {
        self.performSegueWithIdentifier("loginToMainSegue", sender: self)
    }
    @IBAction func RegisterButtonTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("loginToRegisterSegue", sender: self)
        
    }
    
    @IBAction func ForgotPasswordButtonTouch(sender: AnyObject) {
        
        self.performSegueWithIdentifier("loginToPasswordResetSegue", sender: self)
    }
    
    @IBAction func LoginButtonTouch(sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            if (username != "" && password != "") {
                PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
                    if(PFUser.currentUser()?.username != nil) {
                        self.performSegueWithIdentifier("loginToMainSegue", sender: self)
                    }
                    else {
                        GlobalConstants.AlertMessage.displayAlertMessage("Your login information is incorrect, please try again", view: self)
                    }
                }
            }
            else {
                GlobalConstants.AlertMessage.displayAlertMessage("Your login information is incorrect, please double check and try again", view: self)
            }
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "loginToRegisterSegue") {
            var svc = segue.destinationViewController as! RegisterPageViewController
            svc.delegate = self
        }
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.primaryFirst
        self.logInButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.registerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.forgotPasswordButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.forgotPasswordButton.backgroundColor = GlobalConstants.Colors.secondarySecond
        self.forgotPasswordButton.layer.cornerRadius = 5
        self.forgotPasswordButton.layer.borderWidth = 1
        self.forgotPasswordButton.layer.borderColor = GlobalConstants.Colors.secondarySecond.CGColor
        
        
        self.logInButton.backgroundColor = GlobalConstants.Colors.secondarySecond
        self.logInButton.layer.cornerRadius = 5
        self.logInButton.layer.borderWidth = 1
        self.logInButton.layer.borderColor = GlobalConstants.Colors.secondarySecond.CGColor
        
        self.registerButton.backgroundColor = GlobalConstants.Colors.secondarySecond
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.layer.borderWidth = 1
        self.registerButton.layer.borderColor = GlobalConstants.Colors.secondarySecond.CGColor
        
        self.usernameTextField.backgroundColor = UIColor.whiteColor()
        self.usernameTextField.textColor = GlobalConstants.Colors.secondarySecond
        self.passwordTextField.backgroundColor = UIColor.whiteColor()
        self.passwordTextField.textColor = GlobalConstants.Colors.secondarySecond
    }


}
