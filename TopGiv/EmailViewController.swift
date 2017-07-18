//
//  EmailViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 7/7/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import JDMailBox

class EmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let jdmailbox = JDMailBoxComposeVC(rootVC: self)
        jdmailbox.setSignature(signature: "RichmondBallet")
        jdmailbox.setToRecipients(["smckinney@richmondballet.com"])
        if(JDMailBoxComposeVC.canSendMail())   /* importnat */
        {
            self.present(jdmailbox, animated: true, completion: nil)
        }
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

}
