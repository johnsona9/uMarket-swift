//
//  RegisterPageViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/6/15.
//
//

import UIKit
import Parse

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButtonTouch(sender: AnyObject) {
        
        let userEmail = emailAddressTextField.text;
        let userPassword = userPasswordTextField.text;
        let userConfirmPassword = userConfirmPasswordTextField.text;
        let username = usernameTextField.text;
        
        //check for empty fields
        
        
        //confirm passwords to make sure they are identical
        
        if (userEmail.isEmpty || userPassword.isEmpty || userConfirmPassword.isEmpty) {
            //display bad stuff
            displayAlertMessage("All fields are required");
            return;
        }
        
        else if (userPassword != userConfirmPassword) {
            
            //passwords don't match, complain to them
            displayAlertMessage("Passwords do not match");
            return;
            
        }
        
        else {
            let createdUser = PFUser()
            createdUser.email = userEmail
            createdUser.password = userPassword
            createdUser.username = username
            
            createdUser.signUpInBackgroundWithBlock({ (suceeded: Bool, error: NSError?) -> Void in
                if (error == nil) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    
                }
            })
            
            
            
            
        }
        
        
        
        //display success once data has been sent to parse
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func displayAlertMessage(userMessage:String) {
        
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
        
    }
    
    
    
    
    
    

}
