//
//  LoginPageViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/6/15.
//
//

import UIKit
import Parse

class LoginPageViewController: UIViewController, RegisterPageViewControllerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if (username != "" && password != "") {
            PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
                if(PFUser.currentUser()?.username != nil) {
                    self.performSegueWithIdentifier("loginToMainSegue", sender: self)
                }
                else {
                    
                }
            }
        }
        else {
            //show some alert saying they're dumb
        }
        
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


}
