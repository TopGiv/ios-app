//
//  ToMailboxViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/1/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FirebaseAuth

class ToMailboxViewController: UIViewController {

    @IBOutlet weak var bt_Signin: UIButton!
    
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
    
    @IBAction func onSignin(_ sender: Any) {
        transitionViewController()
        
    }
    func interfacelayout() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.title = "Mailbox"
        bt_Signin.layer.cornerRadius = 20
        bt_Signin.clipsToBounds = true
    }
    
    func transitionViewController() {
        Auth.auth().signIn(withEmail: "marksprenkle@gmail.com", password: "123456") { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                print(error.debugDescription)
            }
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileInfoViewController") as! ProfileInfoViewController
        vc.emailPassed = "jeremyfox99@outlook.com"
        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
