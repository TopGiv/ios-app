//
//  ProfileIndexViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/1/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit
import Alamofire


class ProfileIndexViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var bt_Signinemail: UIButton!
    @IBOutlet weak var bt_Signingplus: UIButton!
    @IBOutlet weak var bt_Signinfb: UIButton!
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO(developer) Configure the sign-in button look/feel

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self

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
        //This is for the Interface
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        bt_Signinemail.layer.cornerRadius = 20
        
        bt_Signinfb.layer.cornerRadius = 20
        
        bt_Signingplus.layer.cornerRadius = 20
        
        bt_Signinemail.clipsToBounds = true
        
        bt_Signingplus.clipsToBounds = true
        
        bt_Signinfb.clipsToBounds = true
        
    }
    
    @IBAction func onGoogleplus(_ sender: Any) {        //This is when G+ Sign in button is touched
        
        appDelegate.loginMode = 2       //This is for avoiding conflicts between FB sign in and G+ sign in
        
        GIDSignIn.sharedInstance().signIn()
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            
            let loggedEmail: String
            
            loggedEmail = GIDSignIn.sharedInstance().currentUser.profile.email
            
            Alamofire.request("http://popnus.com/index.php/mobile/signUp?mail=\(loggedEmail)").responseJSON { response in
                            print("Request: \(String(describing: response.request))")   // original url request
                            print("Response: \(String(describing: response.response))") // http url response
                            print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value as? [String: Any] {
                    self.appDelegate.userID = json["uid"] as! String
                    print("JSON: \(self.appDelegate.userID)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                
            }
            
            transitionViewController(email: GIDSignIn.sharedInstance().currentUser.profile.email, fullname: GIDSignIn.sharedInstance().currentUser.profile.name)
            
        }
        
    }
    
    @IBAction func onEmailLogin(_ sender: Any) {        //This is when Sign in via email button is touched
    
        presentAlert()
        
    }
    
    @IBAction func onFBLogin(_ sender: Any) {       //This is when Sign in with FB button is touched
        
        appDelegate.loginMode = 1       //This is for avoiding conflicts between FB sign in and G+ sign in

        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                
                print("Failed to login: \(error.localizedDescription)")
                
                return
                
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                
                print("Failed to get access token")
                
                return
                
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                if let error = error {
                    
                    print("Login error: \(error.localizedDescription)")
                    
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(okayAction)
                    
                    return
                    
                }
                
                self.saveUserInfo(user!)
                
                self.transitionViewController(email: (user?.email)!, fullname: (user?.displayName)!)
                
            })
            
        }
        
    }
    
    func transitionViewController(email: String, fullname: String) {
        //This is for transition of views
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileInfoViewController") as! ProfileInfoViewController
        
        vc.emailPassed = email
        
        vc.fullnamePassed = fullname
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func saveUserInfo(_ user: User) {       //This is for storing data when a user signs up
        
        // Otherwise, add this user to the database.
        let userDict = [
            "user_id": user.uid ,
            "email": user.email ?? ""
            ] as [String: Any]
        
        let loggedEmail: String
        
        loggedEmail = user.email!
        
        Alamofire.request("http://popnus.com/index.php/mobile/signUp?mail=\(loggedEmail)").responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            
            print("Response: \(String(describing: response.response))") // http url response
            
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? [String: Any] {
                
                self.appDelegate.userID = json["uid"] as! String
                
                print("JSON: \(self.appDelegate.userID)") // serialized json response
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
            }
            
        }
    
        print(userDict)
        
    }
    
    func presentAlert() {       //This is for the case when a user signs up via email
        
        let alertController = UIAlertController(title: "", message: "Please input your email", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if let field = alertController.textFields?[0] {
                
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userEmail")
                
                UserDefaults.standard.synchronize()
                
                self.loginEmail(emailIn: field.text!)
                
             }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            
            textField.placeholder = "Your Email"
            
            textField.keyboardType = .emailAddress
            
        }
        
        alertController.addAction(confirmAction)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func transitionViewControllerEmail(emailAddr: String) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileInfoViewController") as! ProfileInfoViewController
        
        vc.emailPassed = emailAddr
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loginEmail(emailIn: String){
        
        if emailIn == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Warning", message: "Please enter your email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.presentAlert()
            }
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
            
        else {
            
            Auth.auth().createUser(withEmail: emailIn, password: "123456") { (user:User?, error:Error?) in
                
                if error == nil {
                    
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            
                            let post2 = UIAlertController(title: "Please check your email", message: "Verification sent!\nAn email will be sent to activate your account.", preferredStyle: .alert)
                            
                            post2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                
                                self.transitionViewControllerEmail(emailAddr: emailIn)
                            }))
                            
                            self.present(post2, animated: true, completion: nil)
                            
                        })
                    }
                    
                } else {
                    let nsError = (error! as NSError)
                    
                    if nsError.code == 17007 {
                        
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            
                            let post2 = UIAlertController(title: "Please check your email", message: "Verification sent!\nAn email will be sent to activate your account.", preferredStyle: .alert)
                            
                            post2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                
                                Alamofire.request("http://popnus.com/index.php/mobile/signUp?mail=\(emailIn)").responseJSON { response in
                                    
                                    print("Request: \(String(describing: response.request))")   // original url request
                                    
                                    print("Response: \(String(describing: response.response))") // http url response
                                    
                                    print("Result: \(response.result)")                         // response serialization result
                                    
                                    if let json = response.result.value as? [String: Any] {
                                        
                                        self.appDelegate.userID = json["uid"] as! String
                                        
                                        print("JSON: \(self.appDelegate.userID)") // serialized json response
                                        
                                    }
                                    
                                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                        
                                        print("Data: \(utf8Text)") // original server data as UTF8 string
                                        
                                    }
                                    
                                }
                                
                                self.transitionViewControllerEmail(emailAddr: emailIn)
                                
                            }))
                            
                            self.present(post2, animated: true, completion: nil)
                            
                        })
                    }
                        
                    else {
                        
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            self.presentAlert()
                            
                        }
                        
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        print(error.debugDescription)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
