//
//  DonationAmountViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/3/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import PassKit

extension DonationAmountViewController: PKPaymentAuthorizationViewControllerDelegate {
    internal func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class DonationAmountViewController: UIViewController {
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.com.YOURDOMAIN.ApplePaySwag" // Fill in your merchant ID here!

    
    var amountPassed = 0
    var titlePassed = ""

    @IBOutlet weak var bt_Card: UIButton!
    @IBOutlet weak var v_Container: UIView!
    @IBOutlet weak var bt_Applepay: UIButton!
    @IBOutlet var lb_Title: UILabel!
    @IBOutlet var lb_Amount: UILabel!
    
    
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
        transitionViewController()
    }
    
    @IBAction func onApplePay(_ sender: Any) {
        let request = PKPaymentRequest()
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        applePayController.delegate = self
        
        self.present(applePayController, animated: true, completion: nil)
    }
    
    
    func interfacelayout() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
     
        bt_Applepay.layer.cornerRadius = 20
        bt_Applepay.clipsToBounds = true
        bt_Card.layer.cornerRadius = 20
        bt_Card.clipsToBounds = true
        v_Container.layer.cornerRadius = 7
        v_Container.clipsToBounds = true
        v_Container.backgroundColor = .clear
        v_Container.layer.borderWidth = 1
        v_Container.layer.borderColor = UIColor.gray.cgColor
        
        lb_Amount.text = "$ \(amountPassed)"
        lb_Title.text = "for \(titlePassed)"
        

    }
    
    func transitionViewController() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CardDonateViewController") as! CardDonateViewController
        vc.amountPassed = self.amountPassed
        vc.titlePassed = self.titlePassed
        //        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
