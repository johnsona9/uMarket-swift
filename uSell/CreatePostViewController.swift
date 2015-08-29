//
//  CreatePostViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

protocol CreatePostViewControllerDelegate {
    func updateTableView(controller: CreatePostViewController, object: PFObject)
}

class CreatePostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: CreatePostViewControllerDelegate?
    
    @IBOutlet weak var departmentPickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    let pickerData = ["ECE", "CSC", "ECO", "PSY", "OTHER"]
    var pickerSelection = "ECE"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleColors()
        self.titleTextField.delegate = self
        self.editionTextField.delegate = self
        self.costTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTouch(sender: AnyObject) {
        let postTitle = titleTextField.text
        let postEdition = editionTextField.text
        let postCost = costTextField.text
        
        if (postTitle != "" && postCost != "") {
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                var newPost = PFObject(className: "post")
                newPost.setObject(postTitle, forKey: "postTitle")
                newPost.setObject(self.pickerSelection, forKey: "postDepartment")
                newPost.setObject(postEdition, forKey: "postEdition")
                newPost.setObject(postCost, forKey: "postCost")
                newPost.setObject(PFUser.currentUser()!, forKey: "poster")
                newPost.saveInBackgroundWithBlock({ (success: Bool, error: NSError? ) -> Void in
                    
                    if (error == nil) {
                        self.delegate!.updateTableView(self, object: newPost)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else {
                        //put an alert in here
                    }
                    
                })
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
            }
            
            
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You are missing some necessary fields", view: self)
        }

    }

    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attString = NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName :GlobalConstants.Colors.goldColor])
        return attString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = pickerData[row]
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.cancelButton.setTitleColor(GlobalConstants.Colors.goldColor, forState: UIControlState.Normal)
        self.postButton.setTitleColor(GlobalConstants.Colors.goldColor, forState: UIControlState.Normal)
        self.titleTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.titleTextField.textColor = GlobalConstants.Colors.goldColor
        self.editionTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.editionTextField.textColor = GlobalConstants.Colors.goldColor
        self.costTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.costTextField.textColor = GlobalConstants.Colors.goldColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
