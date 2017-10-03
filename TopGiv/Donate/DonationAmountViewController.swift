//
//  DonationAmountViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/3/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import PassKit
import Stripe
import Alamofire
import AZDialogView

extension DonationAmountViewController: PKPaymentAuthorizationViewControllerDelegate {
    //This is for default Apple pay
    internal func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        
        completion(PKPaymentAuthorizationStatus.success)
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}


class DonationAmountViewController: UIViewController {
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.com.topgiv.merchant" // Fill in your merchant ID here!
    var amountPassed = 0
    var titlePassed = ""
    let primaryColor = #colorLiteral(red: 0.6271930337, green: 0.3653797209, blue: 0.8019730449, alpha: 1)
    let primaryColorDark = #colorLiteral(red: 0.5373370051, green: 0.2116269171, blue: 0.7118118405, alpha: 1)
    var pledgeFrequency = ""
    var cardChoice = ""

    @IBOutlet weak var bt_Card: UIButton!
    @IBOutlet weak var v_Container: UIView!
    @IBOutlet weak var bt_Applepay: UIButton!
    @IBOutlet var lb_Title: UILabel!
    @IBOutlet var lb_Amount: UILabel!
    @IBOutlet weak var bt_Pledge: UIButton!
    
    
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


    
    @IBAction func onCreditCard(_ sender: Any) {
        //This is when Credit card button is clicked
        transitionViewController()
        
    }
    
    @IBAction func onApplePay(_ sender: Any) {
        //////
        let request = PKPaymentRequest()

        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks) {
            
            print("Apple pay is available")
            
            request.supportedNetworks = SupportedPaymentNetworks
            
            request.countryCode = "US"
            
            request.currencyCode = "USD"
            
            request.merchantIdentifier = ApplePaySwagMerchantID
            
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            
            request.requiredShippingAddressFields = PKAddressField.postalAddress
            
            
            let amountDonation = PKPaymentSummaryItem(label: titlePassed, amount: NSDecimalNumber(string: String(amountPassed)))
            
            request.paymentSummaryItems = [amountDonation]
            
//            let sameday = PKShippingMethod(label: "Same Day", amount: NSDecimalNumber(string: "9.99"))
            
//            sameday.detail = "Guranteed Same day"
            
//            sameday.identifier = "sameday"

//            let twoday = PKShippingMethod(label: "Two Day", amount: NSDecimalNumber(string: "4.99"))
            
//            twoday.detail = "2 Day delivery"
            
//            twoday.identifier = "2day"
            
//            let shippingMethods : [PKShippingMethod] = [sameday, twoday]
            
//            request.shippingMethods = shippingMethods
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            applePayController.delegate = self
            
            present(applePayController, animated: true, completion: nil)
            
        }
        
        //////
    }
    
    
    func interfacelayout() {
        
        //This is for the Interface
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.view.backgroundColor = .clear
     
        bt_Applepay.layer.cornerRadius = 20
        
        bt_Applepay.clipsToBounds = true
        
        bt_Card.layer.cornerRadius = 20
        
        bt_Card.clipsToBounds = true
        
        bt_Pledge.layer.cornerRadius = 20
        
        bt_Pledge.clipsToBounds = true
        
        v_Container.layer.cornerRadius = 7
        
        v_Container.clipsToBounds = true
        
//        v_Container.backgroundColor = .clear
        
//        v_Container.layer.borderWidth = 1
        
//        v_Container.layer.borderColor = UIColor.gray.cgColor
        
        lb_Amount.text = "$ \(amountPassed)"
        
        lb_Title.text = "for \(titlePassed)"
        
    }
    
    func transitionViewController() {
        //This is for transition of views
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "CardDonateViewController") as! CardDonateViewController
        
        vc.amountPassed = self.amountPassed     //The amount of donation a user selected
        
        vc.titlePassed = self.titlePassed       //The form of donation a user selected
                
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onPledge(_ sender: Any) {
        howOftenDialog()
    }
    
    func howOftenDialog(){
        let dialogController = AZDialogViewController(title: "How Often?", message: "")
        dialogController.showSeparator = true
        
        dialogController.addAction(AZDialogAction(title: "Weekly", handler: { (dialog) -> (Void) in
            dialog.removeAction(at: 0)
            dialog.removeAction(at: 0)
            dialog.removeAction(at: 0)
            self.pledgeFrequency = "Weekly"
            print(self.pledgeFrequency)
            dialogController.title = "Pay by means of"
            dialog.addAction(AZDialogAction(title: "CC") { (dialog) -> (Void) in
                self.cardChoice = "CC"
                print(self.cardChoice)
                dialog.dismiss()
            })
            dialog.addAction(AZDialogAction(title: "Debit") { (dialog) -> (Void) in
                self.cardChoice = "Debit"
                print(self.cardChoice)
                dialog.dismiss()
            })
            
            dialog.contentOffset = self.view.frame.height / 2.0 - dialog.estimatedHeight / 2.0 - 16
            
        }))
        
        dialogController.addAction(AZDialogAction(title: "Monthly", handler: { (dialog) -> (Void) in
            self.pledgeFrequency = "Monthly"
            print(self.pledgeFrequency)
            dialogController.title = "Pay by means of"
            dialog.removeAction(at: 0)
            dialog.removeAction(at: 0)
            dialog.removeAction(at: 0)
            dialog.addAction(AZDialogAction(title: "CC") { (dialog) -> (Void) in
                self.cardChoice = "CC"
                print(self.cardChoice)
                dialog.dismiss()
            })
            dialog.addAction(AZDialogAction(title: "Debit") { (dialog) -> (Void) in
                self.cardChoice = "Debit"
                print(self.cardChoice)
                dialog.dismiss()
            })
            
            dialog.contentOffset = self.view.frame.height / 2.0 - dialog.estimatedHeight / 2.0 - 16
        }))
        
        dialogController.addAction(AZDialogAction(title: "Annually", handler: { (dialog) -> (Void) in
            self.pledgeFrequency = "Annually"
            print(self.pledgeFrequency)
            dialogController.title = "Pay by means of"
            dialog.removeAction(at: 0)
            dialog.removeAction(at: 0)
            dialog.removeAction(at: 0)
            dialog.addAction(AZDialogAction(title: "CC") { (dialog) -> (Void) in
                self.cardChoice = "CC"
                print(self.cardChoice)
                dialog.dismiss()
            })
            dialog.addAction(AZDialogAction(title: "Debit") { (dialog) -> (Void) in
                self.cardChoice = "Debit"
                print(self.cardChoice)
                dialog.dismiss()
            })
            
            dialog.contentOffset = self.view.frame.height / 2.0 - dialog.estimatedHeight / 2.0 - 16
            //dialog.spacing = 20
        }))
        
        dialogController.cancelButtonStyle = { (button,height) in
            button.tintColor = self.primaryColor
            button.setTitle("CANCEL", for: [])
            return true
            
        }
        
        dialogController.cancelEnabled = true
        
        dialogController.buttonStyle = { (button,height,position) in
//            button.setBackgroundImage(UIImage.imageWithColor(self.primaryColorDark), for: .highlighted)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(self.primaryColor, for: .normal)
            button.layer.masksToBounds = true
            button.layer.borderColor = self.primaryColor.cgColor
        }
        
        dialogController.dismissDirection = .bottom
        
        dialogController.dismissWithOutsideTouch = true
        
        dialogController.contentOffset = self.view.frame.height / 2.0 - dialogController.estimatedHeight / 2.0 - 16
        
        dialogController.show(in: self)
        
    }
    
}
