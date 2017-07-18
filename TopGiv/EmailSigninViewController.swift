//
//  EmailSigninViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/1/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EmailSigninViewController: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var bt_Sendtoemail: UIButton!
    
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

    @IBAction func onSendEmail(_ sender: Any) {
        if self.tf_Email.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Warning", message: "Please enter your email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated:  true, completion: nil)
        }
        else {

            Auth.auth().createUser(withEmail: self.tf_Email.text!, password: "123456") { (user:User?, error:Error?) in
                if error == nil {
                    
                    self.ref = Database.database().reference()
                    
                    let newUserRef = self.ref!
                        .child("users").child((user!.uid))
                    
                    let newDonationData = [
                        "user_id": user!.uid,
                        "email": self.tf_Email.text!,
                        ] as [String : Any]
                    
                    newUserRef.setValue(newDonationData)
                    
                    
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            
                            let post2 = UIAlertController(title: "Verification sent", message: "An email will be sent to activate your account.", preferredStyle: .alert)
                            
                            post2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                
                                self.transitionViewController()
                            }))
                            
                            self.present(post2, animated: true, completion: nil)
                            
                        })
                    }
                    
                } else {
                    let nsError = (error! as NSError)
                    
                    if nsError.code == 17007 {
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            
                            let post2 = UIAlertController(title: "Verification sent", message: "An email will be sent to activate your account.", preferredStyle: .alert)
                            
                            post2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                
                                self.transitionViewController()
                            }))
                            
                            self.present(post2, animated: true, completion: nil)
                            
                        })
                    }
                    else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        print(error.debugDescription)
                        
                    }
                    
                }
                
            }
        }
    }
    
    func transitionViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SentTempViewController") as! SentTempViewController
        vc.emailPassed = self.tf_Email.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func interfacelayout() {
        self.view.backgroundColor = UIColor.white
        tf_Email.becomeFirstResponder()
        bt_Sendtoemail.layer.cornerRadius = 20
        bt_Sendtoemail.clipsToBounds = true
    }
}
