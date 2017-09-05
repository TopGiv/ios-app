//
//  DonationHistoryViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/2/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MGSwipeTableCell
import SBPickerSelector
import MessageUI
import Alamofire

class DonationHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SBPickerSelectorDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var ai_Loading: UIActivityIndicatorView!
    @IBOutlet weak var bt_Emailreceipts: UIButton!
    @IBOutlet var tbl_History: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userDict:[NSDictionary] = []
    var emailPassed = ""
    var dateSelected = ""
    var receiptText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !MFMailComposeViewController.canSendMail() {
            
            print("Mail services are not available")
            
        }
        
        interfacelayout()
        
        fetchData()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userDict.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 83.0
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let identifier = "HistoryTableViewCell"
        
            let object = self.userDict[indexPath.row]
        
            var cell: HistoryTableViewCell! = tbl_History.dequeueReusableCell(withIdentifier: identifier) as? HistoryTableViewCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                
                cell = tbl_History.dequeueReusableCell(withIdentifier: identifier) as? HistoryTableViewCell
                
            }
        
        cell.lb_Category.text = object["category"]! as? String
        
        cell.lb_Date.text = unixtoDate(timeResult: Double((object["date"]! as? String)!)!)
        
        
        cell.lb_Amount.text = object["amount"]! as? String
        
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.transitionViewController(index: indexPath.row)
        
        print("You tapped cell number \(indexPath.row).")
        
    }

    
    func fetchData() {
        
        ai_Loading.isHidden = false     //This is for the activity indicator
        
        ai_Loading.startAnimating()     //Start spinning
        
        //To fetch data of donation history from backend
        Alamofire.request("http://popnus.com/index.php/mobile/history?uid=\(self.appDelegate.userID)").responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            
            print("Response: \(String(describing: response.response))") // http url response
            
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                
                print("&&&\(json)")
                
                if let data = json["data"] as? Array<AnyObject> {
                    
                    var dataCell: NSDictionary = [:]
                    
                    for myEntry in data {
                        
                        print("&&&\(myEntry)")
                        
                        if let dataCategory = myEntry["kind"] as? String {
                            
                            if let dataAmount = myEntry["amount"] as? String {
                                
                                if let dataDate = myEntry["date"] as? String {
                                    
                                    dataCell = ["category": dataCategory , "date": dataDate , "amount": "\(dataAmount)$"]
                                        
                                }
                            }
                        }
                        
                        self.userDict.append(dataCell)
                        
                    }
                    
                }
                
            }
            
            print(self.userDict)
            
            self.ai_Loading.stopAnimating()     //Stop spinning
            
            self.ai_Loading.isHidden = true     //To hide the activity indicator
            
            self.tbl_History.reloadData()
            
        }
        
    }
    
    func receiptData() {
        
        for item in userDict {
            
            let obj = item as NSDictionary
            
            let date:String! = item.value(forKey: "date") as? String
            
            let category:String! = item.value(forKey: "category") as? String
            
            let amount:String! = item.value(forKey: "amount") as? String
            
            let dateDiv = date.components(separatedBy: " ")
            
            if dateSelected == dateDiv[2] {
                
                receiptText = receiptText + "\(category) \(amount) \(date)\n"
                
                print(dateDiv[2])
                
            }
            
            else {
                print(dateDiv)
            }

        }
        
    }
    
    func transitionViewController(index: Int) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "DonationViewController") as! DonationViewController
        
        vc.amountPassed = ((self.userDict[index])["amount"]! as? String)!
        
        vc.datePassed = ((self.userDict[index])["date"]! as? String)!
        
        vc.categoryPassed = ((self.userDict[index])["category"]! as? String)!
        
        vc.emailPassed = emailPassed
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    @IBAction func onEmailReceipt(_ sender: Any) {
        
        let picker: SBPickerSelector = SBPickerSelector()
        
        picker.delegate = self
        
        picker.pickerType = SBPickerSelectorType.text
        
        picker.doneButtonTitle = "Done"
        
        picker.cancelButtonTitle = "Cancel"
        
        picker.pickerType = SBPickerSelectorType.date //select date(needs implements delegate method with date)
        
        picker.datePickerType = SBPickerSelectorDateType.onlyMonthAndYear //type of date picker (complete, only day, only hour)
        
        picker.showPickerOver(self) //classic picker display
        
        let point: CGPoint = view.convert((sender as AnyObject).frame.origin, from: (sender as AnyObject).superview)
        
        var frame: CGRect = (sender as AnyObject).frame
        
        frame.origin = point
        
    }
    
    func interfacelayout() {
        
        tbl_History.backgroundView = UIImageView(image: UIImage(named: "hisback.jpg"))
        
        tbl_History.delegate = self
        
        tbl_History.dataSource = self
        
        bt_Emailreceipts.layer.cornerRadius = 20
        
        bt_Emailreceipts.clipsToBounds = true
        
        self.navigationController?.navigationItem.title = "Donation History"
        
    }
    
    func pickerSelector(_ selector: SBPickerSelector, selectedValue value: String, index idx: Int) {
        
        dateSelected = value
        
    }
    
    func pickerSelector(_ selector: SBPickerSelector, dateSelected date: Date) {
        
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = "yyyy"
        
        dateSelected = dateFormat.string(from: date)
        
        receiptData()
        
        displayConfirm()
        
        print(dateSelected)

    }
    
    func pickerSelector(_ selector: SBPickerSelector, cancelPicker cancel: Bool) {
        
        print("press cancel")
        
    }
    
    func pickerSelector(_ selector: SBPickerSelector, intermediatelySelectedValue value: Any, at idx: Int) {

    }

    func displayConfirm() {
        
        let alertController = UIAlertController(title: "Confirmation", message: "All receipts in \(dateSelected) have been sent to \(emailPassed)", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func sendEmail() {
        
        let composeVC = MFMailComposeViewController()
        
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([emailPassed])
        
        composeVC.setSubject("All the receipts in \(dateSelected)")
        
        composeVC.setMessageBody("Thanks for your kind heart!\n\(receiptText)", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func unixtoDate(timeResult: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeResult)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        
        return dateFormatter.string(from: date as Date)
        
    }
    
}
