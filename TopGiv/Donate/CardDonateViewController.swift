//
//  CardDonateViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/3/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Stripe
import AFNetworking
import Alamofire

class CardDonateViewController: UIViewController {
    
    var titlePassed = ""
    var amountPassed = 0
    var URL: String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var tf_CardA: UITextField!
    @IBOutlet var tf_CardB: UITextField!
    @IBOutlet var tf_CardC: UITextField!
    @IBOutlet var tf_CardD: UITextField!
    @IBOutlet var tf_HolderName: UITextField!
    @IBOutlet weak var bt_Donate: UIButton!
    @IBOutlet var tf_Date: UITextField!
    @IBOutlet var tf_Email: UITextField!
    @IBOutlet weak var tf_CVC: UITextField!
    
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
    
    @IBAction func onDonate(_ sender: Any) {        //This is when Donate button is clicked
        
        //Today
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        let today = String(Int(NSDate().timeIntervalSince1970))
        
        //This is validation for all the textfields
        if self.tf_CardA.text == "" || self.tf_CardB.text == "" || self.tf_CardC.text == "" || self.tf_CardD.text == "" || self.tf_HolderName.text == "" || self.tf_Date.text == "" || self.tf_Email.text == ""{
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Warning", message: "Please fill all the blanks.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
            
        else {
            
            let providedEmailAddress = tf_Email.text
            
            let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
            
            if isEmailAddressValid
            {
                
                print("Email address is valid")
                
            } else {
                
                print("Email address is not valid")
                
                displayAlertMessage(messageToDisplay: "Email address is not valid")
                
            }
            
            let donationCategory = titlePassed.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            URL = "http://popnus.com/index.php/mobile/addHistory?mail=\(String(describing: tf_Email.text!))&amount=\(amountPassed)&date=\(today)&kind=\(donationCategory)&token="

            //Stripe payment processing
            // Initiate the card
            let stripCard = STPCard()
            
            let stripCardParams = STPCardParams()
            
            // Split the expiration date to extract Month & Year
            let expirationDate = self.tf_Date.text?.components(separatedBy: "/")
            
            let expMonth = monthConvert(mediumMonth: (expirationDate?[0])!)
            
            let expYear = UInt((expirationDate?[1])!)

            let number = "\(self.tf_CardA.text!)\(self.tf_CardB.text!)\(self.tf_CardC.text!)\(self.tf_CardD.text!)"       //Card number

            //Stripe card info
            stripCard.number = number
            
            stripCard.cvc = self.tf_CVC.text!        //CVC
            
            stripCard.expMonth = UInt(expMonth)
            
            stripCard.expYear = expYear!
            
            stripCardParams.number = "\(self.tf_CardA.text!)\(self.tf_CardB.text!)\(self.tf_CardC.text!)\(self.tf_CardD.text!)"
            
            stripCardParams.cvc = tf_CVC.text
            
            stripCardParams.expYear = expYear!
            
            stripCardParams.expMonth = UInt(expMonth)
            
            if STPCardValidator.validationState(forCard: stripCardParams) == .valid {
                // the card is valid.
                STPAPIClient.shared().createToken(withCard: stripCard, completion: { (token, error) -> Void in
                    
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    print("This is the TOKEN: \(token)")
                    
                    self.postStripeToken(token: token!)
                })
               
            }
            
            displayThanksMessage(messageToDisplay: "Your donation is complete\nWe are so grateful to you for your gift - thanks!")
        
        }
        
    }
    
    @IBAction func onEditing(_ sender: UITextField) {       //This is for expire date
        
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
    
    func interfacelayout() {
        //This is for the Interface
        
        tf_CardA.becomeFirstResponder()
        
        bt_Donate.layer.cornerRadius = 20
        
        bt_Donate.clipsToBounds = true
        
        bt_Donate.setTitle("Donate $\(amountPassed)", for: .normal)
        
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
            
            tf_HolderName.becomeFirstResponder()
            
        }
        
    }
    
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        //This is for email address validation
        
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
    
    func displayAlertMessage(messageToDisplay: String)
    {
        //This is for displaying alert messages
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func displayThanksMessage(messageToDisplay: String)
    {
        //This is for displaying thankful messages when donation is done.
        let alertController = UIAlertController(title: "Thank You", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            self.navigationController?.popToRootViewController(animated: true)
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func monthConvert(mediumMonth: String) -> Int
    {
        //This is for expiratoin date
        
        switch mediumMonth {
            
        case "Jan":
            return 1
            
        case "Feb":
            return 2
            
        case "Mar":
            return 3
            
        case "Apr":
            return 4
            
        case "May":
            return 5
            
        case "Jun":
            return 6
            
        case "Jul":
            return 7
            
        case "Aug":
            return 8
            
        case "Sep":
            return 9
            
        case "Oct":
            return 10
            
        case "Nov":
            return 11
            
        case "Dec":
            return 12
            
        default:
            return 1
            
        }
        
    }
    
    func handleError(error: NSError) {      //To handle errors for Stripe
        
        //This is for displaying alert messages
        let alertController = UIAlertController(title: "Please Try Again", message: error.localizedDescription, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
    }
    
    func postStripeToken(token: STPToken) {
        
        let ID = token.tokenId

        Alamofire.request("\(self.URL!)\(ID)").responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            
            print("Response: \(String(describing: response.response))") // http url response
            
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? [String: Any] {
                
                print("JSON: \(json)") // serialized json response
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
            }
            
        }
        
    }
  
}
