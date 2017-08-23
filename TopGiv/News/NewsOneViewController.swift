//
//  NewsOneViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/4/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class NewsOneViewController: UIViewController {

    @IBOutlet var bt_Share: UIButton!
    @IBOutlet var sv_Container: UIScrollView!
    @IBOutlet weak var tv_News: UITextView!
    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var img_Back: UIImageView!
    
    var contentsPassed = ""
    var datePassed = ""
    var titlePassed = ""
    var imagePassed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interfacelayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onShare(_ sender: Any) {
        
        // text to share
        let text = "\(titlePassed)\n\(datePassed)\n\(contentsPassed)"
        
        // set up activity view controller
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,  UIActivityType.postToTwitter, UIActivityType.mail, UIActivityType.message ]
        
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
        //This is for Interface
        
        tv_News.text = contentsPassed
        
        lb_Date.text = datePassed
        
        lb_Title.text = titlePassed
        
        img_Back.image = UIImage.init(named: imagePassed)
        
        self.navigationController?.navigationBar.isHidden = true
        
        bt_Share.backgroundColor = .clear
        
        bt_Share.layer.cornerRadius = 20
        
        bt_Share.layer.borderWidth = 1
        
        bt_Share.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
        //This is for adjusting height of scroll view
        let fixedWidth = tv_News.frame.size.width
        
        tv_News.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = tv_News.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        var newFrame = tv_News.frame
        
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        tv_News.frame = newFrame;
        
        let shareY = newFrame.height + tv_News.frame.origin.y + 25
        
        bt_Share.center.y = shareY
        
        sv_Container.contentSize = CGSize(width: self.view.frame.width, height: tv_News.frame.origin.y + newFrame.height + 64)
        
    }
  
    
    @IBAction func onBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

}
