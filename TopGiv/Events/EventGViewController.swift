//
//  EventGViewController.swift
//  TopGiv
//
//  Created by Hera on 8/24/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import Alamofire

class EventGViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbl_Event: UITableView!
    @IBOutlet weak var ai_Loading: UIActivityIndicatorView!
    
    var userDict:[NSDictionary] = []
    var eventData:[NSDictionary] = []
    var titleChosen = ""
    var dateChosen = ""
    var contentChosen = ""
    var imageChosen = ""
    var placeChosen = ""
    var indexChosen = 0
    var indexButtonChosen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchData()
        interfacelayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //This is location of a table
        tbl_Event.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //This is the number of cells in a table
        return userDict.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //This is height of a cell in a table
        return 345
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "EventFTableViewCell"
        
        let object = self.userDict[indexPath.row]
        
        var cell: EventFTableViewCell! = tbl_Event.dequeueReusableCell(withIdentifier: identifier) as? EventFTableViewCell
        
        if cell == nil {
            
            tableView.register(UINib(nibName: "EventFTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            
            cell = tbl_Event.dequeueReusableCell(withIdentifier: identifier) as? EventFTableViewCell
            
        }
        
        cell.lb_Title.text = object["title"]! as? String        //This is a title of an event
        if (object["image"] != nil) {
            getImage(imageurl: (object["image"]! as? String)!, imageview: cell.img_Back)        //This is an image for an event
        }
        
        
        cell.lb_Place.text = object["place"]! as? String        //This is a place for an event
        
        //This is a date for an event
        let timeResult = Double((object["date"]! as? String)!)
        
        let date = NSDate(timeIntervalSince1970: timeResult!)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        
        let localDate = dateFormatter.string(from: date as Date)
        
        cell.lb_Date.text = localDate
        
        cell.backgroundColor = UIColor.clear
        
//        //Action when sharing button is pressed
//        cell.bt_Share.addTarget(self, action: #selector(onShareButton), for: .touchUpInside)
//        
//        cell.bt_Share.tag = indexPath.row
//        
//        //Action when donation button is pressed
//        cell.bt_Donate.addTarget(self, action: #selector(onDonationButton), for: .touchUpInside)
//        
//        cell.bt_Donate.tag = indexPath.row
//        
//        //Action when calendar button is pressed
//        cell.bt_Calendar.addTarget(self, action: #selector(onCalendarButton), for: .touchUpInside)
//        
//        cell.bt_Calendar.tag = indexPath.row
        
        //Action when dislike button is pressed
//        cell.bt_Dislike.addTarget(self, action: #selector(onDislikeButton), for: .touchUpInside)
        
//        cell.bt_Dislike.tag = indexPath.row
        
        print(indexPath.row)
        
        return cell
        
    }
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //This is when a cell is selected
        
        titleChosen = (userDict[indexPath.row]["title"]! as? String)!
        
        dateChosen = unixtoDate(timeResult: Double((userDict[indexPath.row]["date"]! as? String)!)!)
        
        contentChosen = (userDict[indexPath.row]["content"]! as? String)!
        
        imageChosen = (userDict[indexPath.row]["image"]! as? String)!
        
        placeChosen = (userDict[indexPath.row]["place"]! as? String)!
        
        indexChosen = indexPath.row
        
        self.transitionViewController()
        
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    func fetchData() {
        
        ai_Loading.isHidden = false     //This is for the activity indicator
        
        ai_Loading.startAnimating()     //Start spinning
        
        //This is for fetching data from Firebase
        
        Alamofire.request("http://popnus.com/index.php/mobile/events").responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            
            print("Response: \(String(describing: response.response))") // http url response
            
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                
                print("The data about getting from Event:\n\(json)")
                
                if let data = json["data"] as? Array<AnyObject> {
                    
                    var dataCell: NSDictionary = [:]
                    
                    for myEntry in data {
                        
                        print("One of the events:\n\(myEntry)")
                        
                        if let dataTitle = myEntry["title"] as? String {
                            
                            if let dataContent = myEntry["content"] as? String {
                                
                                if let dataDate = myEntry["date"] as? String {
                                    
                                    if let dataImage = myEntry["image"] as? String {
                                        
                                        if let dataPlace = myEntry["place"] as? String {
                                            
                                            dataCell = ["title": dataTitle , "date": dataDate , "content": dataContent , "place": dataPlace , "image": dataImage]
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        self.userDict.append(dataCell)
                        
                    }
                    
                }
                
            }
            
            self.ai_Loading.stopAnimating()     //To stop spinning
            
            self.ai_Loading.isHidden = true     //To hide the activity indicator
            
            self.tbl_Event.reloadData()
            
        }
        
    }
    
    func transitionViewController() {
        //This is for transition of views
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "EventsOneViewController") as! EventsOneViewController
        
        vc.contentsPassed = contentChosen
        
        vc.datePassed = dateChosen
        
        vc.titlePassed = titleChosen
        
        vc.imagePassed = imageChosen
        
        vc.placePassed = placeChosen
        
        vc.dictPassed = userDict
        
        vc.indexNum = indexChosen
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func interfacelayout() {
        //This is for the Interface
        
        self.navigationController?.isNavigationBarHidden = true
        
        tbl_Event.delegate = self
        
        tbl_Event.dataSource = self
        
    }
    
    func onShareButton(sender: UIButton) {
        //This is the case when the share button is pressed
        
        // text to share
        let text = "\(titleChosen)\n\(placeChosen)\n\(dateChosen)\n\(contentChosen)"
        
        // set up activity view controller
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        titleChosen = (userDict[indexPath.row]["title"]! as? String)!
        
        dateChosen = unixtoDate(timeResult: Double((userDict[indexPath.row]["date"]! as? String)!)!)
        
        contentChosen = (userDict[indexPath.row]["content"]! as? String)!
        
        imageChosen = (userDict[indexPath.row]["image"]! as? String)!
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            
            // text to share
            let text = "\(self.titleChosen)\n\(self.dateChosen)\n\(self.contentChosen)"
            
            // set up activity view controller
            let textToShare = [ text ]
            
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        
        share.backgroundColor = .gray
        
        return [share]
    }
    
    func onCalendarButton(sender: UIButton) {
        //This is the case when the share button is pressed
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddEventViewController")
            as! AddEventViewController
        
        vc.titlePassed = (userDict[sender.tag]["title"]! as? String)!
        
        vc.placePassed = (userDict[sender.tag]["place"]! as? String)!
        
        self.present(vc, animated: true)
        
    }
    
    func onDonationButton(sender: UIButton) {
        //This is the case when the donation button is pressed
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "DonationIndexViewController") as! DonationIndexViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func onDislikeButton(sender: UIButton) {
        //This is the case when the dislike button is pressed
        
        let rowNum = sender.tag
        
        print(rowNum)
        
        userDict.remove(at: rowNum)
        
        tbl_Event.reloadData()
        
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
    
    func unixtoDate(timeResult: Double) -> String {
        //This is for converting the received date to the ordinary one
        
        let date = NSDate(timeIntervalSince1970: timeResult)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        
        return dateFormatter.string(from: date as Date)
        
    }
    
}
