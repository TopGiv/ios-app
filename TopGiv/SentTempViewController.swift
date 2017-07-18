//
//  SentTempViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/1/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import Foundation

class SentTempViewController: UIViewController {
    
    var emailPassed = ""

    @IBOutlet var lb_Inform: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interfacelayout()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.transitionViewController()
//        })
        
        self.lb_Inform.text = "We sent an email to \(emailPassed) It has the login link that'll sign you in"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    func transitionViewController() {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ToMailboxViewController") as! ToMailboxViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

}
