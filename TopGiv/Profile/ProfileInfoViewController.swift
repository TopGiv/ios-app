//
//  ProfileInfoViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/2/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileInfoViewController: UIViewController {

    var emailPassed = ""
    var fullnamePassed = "User"
    @IBOutlet weak var bt_Sharelink: UIButton!
    @IBOutlet var lb_Email: UILabel!
    @IBOutlet var lb_Fullname: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interfacelayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onShare(_ sender: Any) {
        
        // text to share
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,  UIActivityType.postToTwitter, UIActivityType.mail, UIActivityType.message ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
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
        
        self.title = "Profile"
        bt_Sharelink.layer.cornerRadius = 20
        bt_Sharelink.clipsToBounds = true
        lb_Email.text = emailPassed
        lb_Fullname.text = fullnamePassed
        
    }

    
    
    @IBAction func onDonationHistory(_ sender: Any) {
        
        transitionViewController(target: "DonationHistoryViewController", style: true)
        
    }
    
    @IBAction func onDonationSettings(_ sender: Any) {
        
        transitionViewController(target: "PaymentSettingsViewController", style: false)
        
    }
    
    func transitionViewController(target: String, style: Bool) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: target)

        if style {
            let vc = storyBoard.instantiateViewController(withIdentifier: "DonationHistoryViewController") as! DonationHistoryViewController
            vc.emailPassed = self.emailPassed
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = storyBoard.instantiateViewController(withIdentifier: target)
            self.present(vc, animated: true)
        }
        
    }
    
}
