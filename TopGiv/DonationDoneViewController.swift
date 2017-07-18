//
//  DonationDoneViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/3/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class DonationDoneViewController: UIViewController {

    @IBOutlet weak var bt_Share: UIButton!
    @IBOutlet var lb_Amount: UILabel!
    var titlePassed = ""
    var amountPassed = 0
    
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
        bt_Share.backgroundColor = .clear
        bt_Share.layer.cornerRadius = 20
        bt_Share.layer.borderWidth = 1
        bt_Share.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        lb_Amount.text = "$\(amountPassed)"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Done", style:.plain, target: self, action: #selector(transitionViewController(sender:)))
    }

    func transitionViewController(sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewController(animated: true)
/*        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DonationIndexViewController") as! DonationIndexViewController
        self.navigationController?.pushViewController(vc, animated: true)*/
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
}
