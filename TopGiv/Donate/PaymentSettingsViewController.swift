//
//  PaymentSettingsViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/2/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire

class PaymentSettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_Name: UITextField!
    @IBOutlet weak var bt_Save: UIButton!
    @IBOutlet var tf_CardA: UITextField!
    @IBOutlet var tf_CardB: UITextField!
    @IBOutlet var tf_CardC: UITextField!
    @IBOutlet var tf_CardD: UITextField!
    @IBOutlet var tf_Date: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_CVV: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interfacelayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func interfacelayout() {
        
        tf_CardA.becomeFirstResponder()
        
        bt_Save.layer.cornerRadius = 20
        
        bt_Save.clipsToBounds = true
        
        tf_CVV.delegate = self
        
        tf_CardA.delegate = self
        
        tf_CardB.delegate = self
        
        tf_CardC.delegate = self
        
        tf_CardD.delegate = self
        
    }
    
    @IBAction func onCVC(_ sender: Any) {
        if (tf_CVV.text?.characters.count == 3) {
            
            tf_Email.becomeFirstResponder()
            
        }
    }
    
    @IBAction func onCardA(_ sender: Any) {
        
        if (tf_CardA.text?.characters.count == 4) {
            
            tf_CardB.becomeFirstResponder()
            
        }
        
    }
    
    @IBAction func onCardB(_ sender: Any) {
        
        if (tf_CardB.text?.characters.count == 4) {
            
            tf_CardC.becomeFirstResponder()
            
        }
        
    }
    
    @IBAction func onCardC(_ sender: Any) {
        
        if (tf_CardC.text?.characters.count == 4) {
            
            tf_CardD.becomeFirstResponder()
            
        }
        
    }
    
    @IBAction func onCardD(_ sender: Any) {
        
        if (tf_CardD.text?.characters.count == 4) {
            
            tf_Name.becomeFirstResponder()
            
        }
        
    }

    @IBAction func onEditing(_ sender: UITextField) {
        //The date picker for expiration date
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        //This is for expiration date
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        let dateChosen = dateFormatter.string(from: sender.date)
        
        let dateShown = dateChosen.components(separatedBy: " ")
        
        tf_Date.text = "\(dateShown[0])/\(dateShown[2])"
        
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        if self.tf_CardA.text == "" || self.tf_CardB.text == "" || self.tf_CardC.text == "" || self.tf_CardD.text == "" || self.tf_Name.text == "" || self.tf_Date.text == "" || self.tf_Email.text == "" || self.tf_CVV.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Warning", message: "Please fill all the blanks.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
            
        else {
            
            let providedEmailAddress = tf_Email.text
            
            let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)        //Email validation
            
            if isEmailAddressValid
            {
                
                print("Email address is valid")
                
                Alamofire.request("http://popnus.com/index.php/mobile/updateCardInfo?uid=\(self.appDelegate.userID)&card_number=\(self.tf_CardA.text!)-\(self.tf_CardB.text!)-\(self.tf_CardC.text!)-\(self.tf_CardD.text!)&card_name=\(self.tf_Name.text!)&cvc=\(self.tf_CVV.text!)").responseJSON { response in
                    
                    print("Request: \(String(describing: response.request))")   // original url request
                    
                    print("Response: \(String(describing: response.response))") // http url response
                    
                    print("Result: \(response.result)")                         // response serialization result
                    
                    if let json = response.result.value {
                        
                        print("JSON: \(json)") // serialized json response
                    }
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                        
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                    
//                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            } else {
                
                print("Email address is not valid")
                
                displayAlertMessage(messageToDisplay: "Email address is not valid")
                
            }
            
        }
        
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        //This is for email validation
        
        var returnValue = true
        
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            
            let regex = try NSRegularExpression(pattern: emailRegEx)
            
            let nsString = emailAddressString as NSString
            
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                
                returnValue = false
                
            }
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            
            returnValue = false
            
        }
        
        return  returnValue
        
    }
    
    func displayAlertMessage(messageToDisplay: String){
        
        //To display alert message
        
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

}
