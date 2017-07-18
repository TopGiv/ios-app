//
//  DonationViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/1/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FirebaseAuth

class DonationViewController: UIViewController {

    @IBOutlet var bt_Sendreceipt: UIButton!
    @IBOutlet var v_Container: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet var lb_Amount: UILabel!
    @IBOutlet var lb_Category: UILabel!
    @IBOutlet var lb_Date: UILabel!
    
    var amountPassed = ""
    var datePassed = ""
    var categoryPassed = ""
    
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
    @IBAction func onSendReceipt(_ sender: Any) {
        // create the alert
        
        let alert = UIAlertController(title: "", message: "Receipt has been sent to \(Auth.auth().currentUser?.email ?? "")", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onShare(_ sender: Any) {
        // text to share
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func interfacelayout() {
//        self.title = "Donation"
        shareBtn.backgroundColor = .clear
        shareBtn.layer.cornerRadius = 20
        shareBtn.layer.borderWidth = 1
        shareBtn.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        bt_Sendreceipt.layer.cornerRadius = 20
        bt_Sendreceipt.clipsToBounds = true
        v_Container.layer.cornerRadius = 7
        v_Container.clipsToBounds = true
        v_Container.backgroundColor = .clear
        v_Container.layer.borderWidth = 1
        v_Container.layer.borderColor = UIColor.gray.cgColor
        self.navigationItem.backBarButtonItem?.title = "History"
        lb_Amount.text = amountPassed
        lb_Date.text = datePassed
        lb_Category.text = "for \(categoryPassed)"
    }

}
