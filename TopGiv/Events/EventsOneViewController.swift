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
    @IBOutlet weak var tv_Content: UITextView!
    @IBOutlet weak var img_Back: UIImageView!
    @IBOutlet weak var lb_Place: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var lb_Title: UILabel!
    
    var contentsPassed = ""
    var datePassed = ""
    var titlePassed = ""
    var imagePassed = ""
    var placePassed = ""
    
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
        
        //This is when Add button is clicked
        transitionViewController()
        
    }
    

    @IBAction func onShare(_ sender: Any) {
        //This is when Share button is clicked
        
        // text to share
        let text = "\(titlePassed)\n\(placePassed)\n\(datePassed)\n\(contentsPassed)"
        
        // set up activity view controller
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,  UIActivityType.postToTwitter, UIActivityType.mail, UIActivityType.message]
        
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
        //This is for the Interface
 
        tv_Content.text = contentsPassed        //This is a description of a event
        
        lb_Date.text = datePassed       //This is a date of a event
        
        lb_Title.text = titlePassed     //This is a title of a event
        
        lb_Place.text = placePassed     //This is a place of a event
        
        getImage(imageurl: imagePassed, imageview: img_Back)        //This is a image for a event
        
        self.navigationController?.navigationBar.isHidden = true
        
        bt_AddCalendar.layer.cornerRadius = 20
        
        bt_AddCalendar.clipsToBounds = true
        
        bt_Share.backgroundColor = .clear
        
        bt_Share.layer.cornerRadius = 20
        
        bt_Share.layer.borderWidth = 1
        
        bt_Share.layer.borderColor = UIColor(red: 10/255, green: 97/255, blue: 115/255, alpha: 1).cgColor
        
        //This is for adjusting scrollview to the size of contents
        let fixedWidth = tv_Content.frame.size.width
        
        tv_Content.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = tv_Content.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        var newFrame = tv_Content.frame
        
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        tv_Content.frame = newFrame;
        
        let shareY = newFrame.height + tv_Content.frame.origin.y + 25
        
        bt_Share.center.y = shareY
        
        sv_Container.contentSize = CGSize(width: self.view.frame.width, height: tv_Content.frame.origin.y + newFrame.height + 64)
        
    }
    
    func transitionViewController() {
        //This is for transition of views
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddEventViewController")
            as! AddEventViewController
        
        vc.titlePassed = titlePassed
        
        vc.placePassed = placePassed
        
        self.present(vc, animated: true)
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func getImage (imageurl: String, imageview: UIImageView) {
        //This is for loading images from the server
        
        let url: URL = URL(string: imageurl)!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if data != nil {
                
                let image = UIImage(data: data!)
                
                if image != nil {
                    
                    DispatchQueue.main.async(execute: {
                        
                        imageview.image = image
                        
                    })
                }
            }
        })
        
        task.resume()
        
    }

}
