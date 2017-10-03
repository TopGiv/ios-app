//
//  DonationIndexViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/3/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import AAPickerView

class DonationIndexViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var categoryPicker: UIPickerView!
    let stringData = ["Minds in Motion","The school of Richmond Ballet","Professional Company and Performances","General Fund"]
    
    @IBOutlet weak var bt_Custom: UIButton!
    @IBOutlet weak var bt_100: UIButton!
    @IBOutlet weak var bt_50: UIButton!
    @IBOutlet weak var bt_20: UIButton!
    @IBOutlet weak var bt_10: UIButton!
    @IBOutlet weak var bt_5: UIButton!
    @IBOutlet var uv_Contents: UIView!
    @IBOutlet weak var uv_Amounts: UIView!
    @IBOutlet weak var tf_Category: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //This for showing Donation button on the tab bar
        self.tabBarController?.tabBar.items?[2].selectedImage = UIImage(named: "donate_icon.png")!.withRenderingMode(.alwaysOriginal)
        
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "donate_icon.png")!.withRenderingMode(.alwaysOriginal)
        
        categoryPicker = UIPickerView()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        tf_Category.inputView = categoryPicker
        tf_Category.text = stringData[0]
        
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
    
    
    @IBAction func on5(_ sender: Any) {
        //This is when $5 is selected
        
        bt_5.backgroundColor = UIColor.white
        
        bt_5.setTitleColor(UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1), for: .normal)
        
        transitionViewController(amount: 5)
        
    }
    
    
    @IBAction func on5Down(_ sender: Any) {
        //This is for coloring the button when $5 is selected
        
        bt_5.setTitleColor(UIColor.white, for: .normal)
        
        bt_5.backgroundColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1)
        
    }
    
    @IBAction func on10(_ sender: Any) {
        //This is when $10 is selected
        
        bt_10.backgroundColor = UIColor.white
        
        bt_10.setTitleColor(UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1), for: .normal)
        
        transitionViewController(amount: 10)
        
    }
    
    @IBAction func on10Down(_ sender: Any) {
        //This is for coloring the button when $10 is selected
        
        bt_10.setTitleColor(UIColor.white, for: .normal)
        
        bt_10.backgroundColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1)
        
    }
    
    @IBAction func on20(_ sender: Any) {
        //This is when $20 is selected
        
        bt_20.backgroundColor = UIColor.white
        
        bt_20.setTitleColor(UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1), for: .normal)
        
        transitionViewController(amount: 20)
        
    }
    
    @IBAction func on20Down(_ sender: Any) {
        //This is for coloring the button when $20 is selected
        
        bt_20.backgroundColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1)
        
        bt_20.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    
    @IBAction func on50(_ sender: Any) {
        //This is when $50 is selected
        
        bt_50.backgroundColor = UIColor.white
        
        bt_50.setTitleColor(UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1), for: .normal)
        
        transitionViewController(amount: 50)
        
    }
    
    @IBAction func on50Down(_ sender: Any) {
        //This is for coloring the button when $50 is selected
        
        bt_50.backgroundColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1)
        
        bt_50.setTitleColor(UIColor.white, for: .normal)
        
    }

    @IBAction func on100(_ sender: Any) {
        //This is when $100 is selected
        
        bt_100.backgroundColor = UIColor.white
        
        bt_100.setTitleColor(UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1), for: .normal)
        
        transitionViewController(amount: 100)
        
    }
    
    @IBAction func on100Down(_ sender: Any) {
        //This is for coloring the button when $100 is selected
        
        bt_100.backgroundColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1)
        
        bt_100.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func onCustom(_ sender: Any) {
        //This is when custom buttons is clicked
        
        presentAlert()
        
    }
    
    //This is for the interface
    func interfacelayout() {
        
        self.navigationController?.navigationBar.topItem?.title = "DONATE"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        uv_Contents.layer.cornerRadius = 7
        
        uv_Contents.clipsToBounds = true
        
        uv_Amounts.layer.cornerRadius = 7
        
        uv_Amounts.clipsToBounds = true
        
        bt_5.layer.cornerRadius = 20
        
        bt_5.clipsToBounds = true
        
        bt_5.layer.borderWidth = 2.0
        
        bt_5.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
        bt_10.layer.cornerRadius = 20
        
        bt_10.clipsToBounds = true
        
        bt_10.layer.borderWidth = 2.0
        
        bt_10.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
        bt_20.layer.cornerRadius = 20
        
        bt_20.clipsToBounds = true
        
        bt_20.layer.borderWidth = 2.0
        
        bt_20.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
        bt_50.layer.cornerRadius = 20
        
        bt_50.clipsToBounds = true
        
        bt_50.layer.borderWidth = 2.0
        
        bt_50.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
        bt_100.layer.cornerRadius = 20
        
        bt_100.clipsToBounds = true
        
        bt_100.layer.borderWidth = 2.0
        
        bt_100.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
        bt_Custom.layer.cornerRadius = 20
        
        bt_Custom.clipsToBounds = true
        
        bt_Custom.layer.borderWidth = 2.0
        
        bt_Custom.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
    }
    
    func presentAlert() {
        //This is for entering custom amount
        
        let alertController = UIAlertController(title: "", message: "Enter a custom amount that you want to donate", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userEmail")
                
                UserDefaults.standard.synchronize()
                
                self.transitionViewController(amount: Int(field.text!)!)
                
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            
            textField.placeholder = "Amount"
            
            textField.keyboardType = .numberPad
            
        }
        
        alertController.addAction(confirmAction)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    func transitionViewController(amount: Int) {
        //This is for transition of views
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "DonationAmountViewController") as! DonationAmountViewController
        
        vc.amountPassed = amount        //Amount to be donated
        
        vc.titlePassed = tf_Category.text!      //Form of donation
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return stringData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stringData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        tf_Category.text = stringData[row]
        self.view.endEditing(true)
    }
    
}
