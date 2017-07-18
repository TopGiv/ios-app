//
//  EventsOneViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/5/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class EventsOneViewController: UIViewController {

    @IBOutlet var bt_AddCalendar: UIButton!
    @IBOutlet var bt_Share: UIButton!
    @IBOutlet var sv_Container: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interfacelayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddCalendar(_ sender: Any) {
        transitionViewController()
    }
    

    @IBAction func onShare(_ sender: Any) {
        // text to share
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
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
/*        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.hidesBackButton = true
 */
        self.navigationController?.navigationBar.isHidden = true
        sv_Container.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height + 820)
        bt_AddCalendar.layer.cornerRadius = 20
        bt_AddCalendar.clipsToBounds = true
        bt_Share.backgroundColor = .clear
        bt_Share.layer.cornerRadius = 20
        bt_Share.layer.borderWidth = 1
        bt_Share.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
    }
    
    func transitionViewController() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewEventViewController") as! NewEventViewController
        self.present(vc, animated: true)
    }
    @IBAction func onBack(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

}
