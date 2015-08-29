//
//  EditPostViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

class EditPostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var initialObject:PFObject!
    
    @IBOutlet weak var departmentPickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
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
        self.titleTextField.text = self.initialObject["postTitle"] as? String
        self.editionTextField.text = self.initialObject["postEdition"] as? String
        self.costTextField.text = self.initialObject["postCost"] as? String
        departmentPickerView.selectRow(find(pickerData, (self.initialObject["postDepartment"] as? String)!)!, inComponent: 0, animated: false)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButtonTouch(sender: AnyObject) {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            PFQuery(className: "post").getObjectInBackgroundWithId(self.initialObject.objectId!, block: { (object, error) -> Void in
                if (error == nil) {
                    object!["postTitle"] = self.titleTextField.text
                    object!["postEdition"] = self.editionTextField.text
                    object!["postClass"] = self.pickerSelection
                    object!["postCost"] = self.costTextField.text
                    object!.saveInBackgroundWithBlock { (success, error) -> Void in
                        if (success == true) {
                            if (error == nil) {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                        else {
                            println("error updating object")
                        }
                        
                    }
                }
            })
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
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
        self.saveButton.setTitleColor(GlobalConstants.Colors.goldColor, forState: UIControlState.Normal)
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
