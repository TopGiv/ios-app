//
//  ContactUsViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/2/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet var bt_Rate: UIButton!
    @IBOutlet weak var sv_Contactus: UIScrollView!
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
        sv_Contactus.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height + 220)
        bt_Rate.layer.cornerRadius = 20
        bt_Rate.clipsToBounds = true
    }

}
