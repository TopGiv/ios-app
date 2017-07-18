//
//  GetReceiptViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/4/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class GetReceiptViewController: UIViewController {

    @IBOutlet var bt_Reciept: UIButton!
    @IBOutlet var tf_Email: UITextField!
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
        tf_Email.becomeFirstResponder()
        bt_Reciept.layer.cornerRadius = 20
        bt_Reciept.clipsToBounds = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

}
