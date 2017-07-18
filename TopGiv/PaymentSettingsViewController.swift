//
//  PaymentSettingsViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/2/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class PaymentSettingsViewController: UIViewController {

    @IBOutlet weak var tf_Name: UITextField!
    @IBOutlet weak var bt_Save: UIButton!
    @IBOutlet var tf_CardA: UITextField!
    @IBOutlet var tf_CardB: UITextField!
    @IBOutlet var tf_CardC: UITextField!
    @IBOutlet var tf_CardD: UITextField!
    @IBOutlet var tf_Date: UITextField!
    
    
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
        tf_CardA.becomeFirstResponder()
        bt_Save.layer.cornerRadius = 20
        bt_Save.clipsToBounds = true
    }
    
    @IBAction func onCardA(_ sender: Any) {
        if (tf_CardA.text?.characters.count == 4) {
            tf_CardB.becomeFirstResponder()
        }
    }
    @IBAction func onCardB(_ sender: Any) {
        if (tf_CardB.text?.characters.count == 4) {
            tf_CardC.becomeFirstResponder()
        }
    }
    @IBAction func onCardC(_ sender: Any) {
        if (tf_CardC.text?.characters.count == 4) {
            tf_CardD.becomeFirstResponder()
        }
    }
    @IBAction func onCardD(_ sender: Any) {
        if (tf_CardD.text?.characters.count == 4) {
            tf_Name.becomeFirstResponder()
        }
    }

    @IBAction func onEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        tf_Date.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
