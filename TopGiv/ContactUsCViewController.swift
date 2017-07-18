//
//  ContactUsCViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/19/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class ContactUsCViewController: UIViewController {
    
    @IBOutlet var v_ContentsA: UIView!
    @IBOutlet var v_ContentsB: UIView!
    @IBOutlet var bt_Rate: UIButton!
    @IBOutlet var bt_More: UIButton!
    @IBOutlet var lb_ContentsA: UILabel!
    @IBOutlet var lb_URL: UILabel!
    @IBOutlet var lb_Phone: UILabel!
    @IBOutlet var lb_Email: UILabel!
    var moreless = true

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
        v_ContentsA.layer.cornerRadius = 4
        v_ContentsA.clipsToBounds = true
        v_ContentsB.layer.cornerRadius = 4
        v_ContentsB.clipsToBounds = true
        bt_Rate.layer.cornerRadius = 20
        bt_Rate.clipsToBounds = true
        lb_URL.isUserInteractionEnabled = true
        lb_Phone.isUserInteractionEnabled = true
        lb_Email.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapURLFunction))
        lb_URL.addGestureRecognizer(tap)
        let ptap = UITapGestureRecognizer(target: self, action: #selector(self.tapPhoneFunction))
        lb_Phone.addGestureRecognizer(ptap)
        let etap = UITapGestureRecognizer(target: self, action: #selector(self.tapEmailFunction))
        lb_Email.addGestureRecognizer(etap)
//        v_ContetsA.backgroundColor = .clear
//        v_ContetsA.layer.borderWidth = 1
//        v_ContetsA.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func onRate(_ sender: Any) {
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

    @IBAction func onMoreContents(_ sender: Any) {
        if (moreless) {
            v_ContentsA.frame.size.height = v_ContentsA.frame.size.height + 180.0
            bt_More.frame.origin = CGPoint(x: 159, y: 301)
            bt_More.setImage(UIImage.init(named: "less-icon.png"), for: .normal)
            lb_ContentsA.frame.size.height = lb_ContentsA.frame.size.height + 180.0
            moreless = false
        }
        else {
            v_ContentsA.frame.size.height = v_ContentsA.frame.size.height - 180.0
            bt_More.frame.origin = CGPoint(x: 159, y: 121)
            bt_More.setImage(UIImage.init(named: "more-icon.png"), for: .normal)
            lb_ContentsA.frame.size.height = lb_ContentsA.frame.size.height - 180.0
            moreless = true
        }
    }
    
    func tapURLFunction() {
        if let url = NSURL(string: "http://www.richmondballet.com/") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func tapPhoneFunction() {
        if let url = NSURL(string: "tel://8043440906"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func tapEmailFunction() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
        self.present(vc, animated: true)
        
    }
}
