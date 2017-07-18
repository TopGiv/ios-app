//
//  RateViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/4/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet var tf_Feedback: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interfacelayout()
        rateInitial()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }

    @IBAction func sendBtnClicked(_ sender: Any) {
        self.dismiss(animated: true) {
        }
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
        tf_Feedback.becomeFirstResponder()
    }

    func rateInitial() {
        //configure
        SARate.sharedInstance().daysUntilPrompt = 5
        SARate.sharedInstance().usesUntilPrompt = 5
        SARate.sharedInstance().remindPeriod = 30
        SARate.sharedInstance().promptForNewVersionIfUserRated = true
        //enable preview mode
        SARate.sharedInstance().previewMode = true
        SARate.sharedInstance().email = "andrei@solovjev.com"
        // 4 and 5 stars
        SARate.sharedInstance().minAppStoreRaiting = 4
        //        SARate.sharedInstance().emailSubject = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        SARate.sharedInstance().emailText = "Disadvantages: "
        SARate.sharedInstance().headerLabelText = "Like app?"
        SARate.sharedInstance().descriptionLabelText = "Touch the star to rate."
        SARate.sharedInstance().rateButtonLabelText = "Rate"
        SARate.sharedInstance().cancelButtonLabelText = "Not Now"
        SARate.sharedInstance().setRaitingAlertTitle = "Rate"
        SARate.sharedInstance().setRaitingAlertMessage = "Touch the star to rate."
        SARate.sharedInstance().appstoreRaitingAlertTitle = "Write a review on the AppStore"
        SARate.sharedInstance().appstoreRaitingAlertMessage = "Would you mind taking a moment to rate it on the AppStore? It won’t take more than a minute. Thanks for your support!"
        SARate.sharedInstance().appstoreRaitingCancel = "Cancel"
        SARate.sharedInstance().appstoreRaitingButton = "Rate It Now"
        SARate.sharedInstance().disadvantagesAlertTitle = "Disadvantages"
        SARate.sharedInstance().disadvantagesAlertMessage = "Please specify the deficiencies in the application. We will try to fix it!"
    }
}
