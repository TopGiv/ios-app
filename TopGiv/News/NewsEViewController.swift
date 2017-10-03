//
//  NewsEViewController.swift
//  TopGiv
//
//  Created by Hera on 8/30/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Alamofire
import ARFacebookShareKitActivity

class NewsEViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tbl_News: UITableView!
    @IBOutlet weak var ai_Loading: UIActivityIndicatorView!
    
    var userDict:[NSDictionary] = []
    var newsData:[NSDictionary] = []
    var titleChosen = ""
    var dateChosen = ""
    var authorChosen = ""
    var contentChosen = ""
    var imageChosen = ""
    let today = String(Int(NSDate().timeIntervalSince1970))
    let dateFormatter = DateFormatter()
    var indexChosen = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This for showing Donation button on the tab bar
        self.tabBarController?.tabBar.items?[2].selectedImage = UIImage(named: "donate_icon.png")!.withRenderingMode(.alwaysOriginal)
        
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "donate_icon.png")!.withRenderingMode(.alwaysOriginal)
        
        // Do any additional setup after loading the view.
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .medium
        
        //        storeData()
        
        fetchData()
        
        interfacelayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //This is location of a table
        
        tbl_News.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
        
            return 330.0

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "NewsETableViewCell"
        
        let object = self.userDict[indexPath.row]
        
        var day_diff  = 0
        var hour_diff = 0
        var min_diff = 0
        
        var cell: NewsETableViewCell! = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsETableViewCell
        
        if cell == nil {
            
            tableView.register(UINib(nibName: "NewsETableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            
            cell = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsETableViewCell
            
        }
        
        cell.lb_Title.text = object["title"]! as? String        //This is a title of a news
        
        cell.lb_Author.text = object["author"]! as? String      //This is a author of a news
        
        //This is for calculating date
        let beginDate = unixtoDate(timeResult: Double((object["date"]! as? String)!)!)
        
        let endDate = unixtoDate(timeResult: Double(today)!)
        let startDateTime = dateFormatter.date(from: beginDate) //according to date format your date string
        let endDateTime = dateFormatter.date(from: endDate) //according to date format your date string
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.minute,NSCalendar.Unit.hour,NSCalendar.Unit.day]
        
        let interval = endDateTime!.timeIntervalSince(startDateTime!)
        var diff = dateComponentsFormatter.string(from: interval)!
        if (diff.contains("d"))
        {
            let day = diff.substring(to: (diff.range(of: "d")?.lowerBound)!)
            
            day_diff  = Int(day)!
            cell.lb_Date.text = "\(day_diff)d ago"
            
            diff = diff.substring(from:(diff.range(of : " ")?.upperBound )!)
            print(diff)
        }
        else {
            if (diff.contains(":")){
                let hour = diff.substring(to: (diff.range(of : ":")?.lowerBound )!)
                hour_diff  = Int(hour)!
                cell.lb_Date.text = "\(hour_diff)h ago"
            }
            else {
                min_diff  = Int(diff)!
                cell.lb_Date.text = "\(min_diff)m ago"
            }
            
        }
//        cell.lb_Date.text = unixtoDate(timeResult: Double((object["date"]! as? String)!)!)      //This is a date for a event
        
        getImage(imageurl: (object["image"]! as? String)!, imageview: cell.img_Back)        //This is a image for a event
        
        //Action when sharing button is pressed
//        cell.bt_Share.addTarget(self, action: #selector(onShareButton), for: .touchUpInside)
        
//        cell.bt_Share.tag = indexPath.row
        
        return cell

    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //This is when a cell is selected
        titleChosen = (userDict[indexPath.row]["title"]! as? String)!
        
        dateChosen = unixtoDate(timeResult: Double((userDict[indexPath.row]["date"]! as? String)!)!)
        
        contentChosen = (userDict[indexPath.row]["content"]! as? String)!
        
        imageChosen = (userDict[indexPath.row]["image"]! as? String)!
        
        authorChosen = (userDict[indexPath.row]["author"]! as? String)!
        
        indexChosen = indexPath.row
        
        self.transitionViewController()
        
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        titleChosen = (userDict[indexPath.row]["title"]! as? String)!
        
        dateChosen = unixtoDate(timeResult: Double((userDict[indexPath.row]["date"]! as? String)!)!)
        
        contentChosen = (userDict[indexPath.row]["content"]! as? String)!
        
        imageChosen = (userDict[indexPath.row]["image"]! as? String)!
        
        authorChosen = (userDict[indexPath.row]["author"]! as? String)!
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            
            // text to share
            let text = "\(self.titleChosen)\n\(self.dateChosen)\n\(self.contentChosen)"
            
            // set up activity view controller
            let textToShare = [ text ]
            
            let applicationActivities = [Share()]
            
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: [ShareLinkActivity()])
            
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
            
            activityViewController.completionWithItemsHandler = self.completionHandler
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)

        }
        
        share.backgroundColor = .gray
        
        return [share]
    }
    
    func completionHandler(activityType: UIActivityType?, shared: Bool, items: [Any]?, error: Error?) {
        if (shared) {
            print("Cool user shared some stuff")
            if activityType == UIActivityType.postToTwitter {
                print("twitter")
            }
            
            if activityType == UIActivityType.mail {
                print("mail")
            }
            
            if activityType == UIActivityType.postToFacebook {
                print("-0-0-0-0-0-0-0-0-0-0FB")
            }
        }
        else {
            print("Bad user canceled sharing :(")
        }
    }
    
    func fetchData() {
        
        ai_Loading.isHidden = false     //This is for the activity indicator
        
        ai_Loading.startAnimating()     //Start spinning
        
        //This is for fetching data from Firebase
        
        Alamofire.request("http://popnus.com/index.php/mobile/news").responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            
            print("Response: \(String(describing: response.response))") // http url response
            
            print("Result: \(response.result)")                         // response serialization result
            
            
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                
                print("The data about getting from News:\n\(json)")
                
                if let data = json["data"] as? Array<AnyObject> {
                    
                    var dataCell: NSDictionary = [:]
                    
                    for myEntry in data {
                        
                        print("One of the News:\n\(myEntry)")
                        
                        if let dataTitle = myEntry["title"] as? String {
                            
                            if let dataContent = myEntry["content"] as? String {
                                
                                if let dataDate = myEntry["date"] as? String {
                                    
                                    if let dataImage = myEntry["image"] as? String {
                                        
                                        if let dataAuthor = myEntry["author"] as? String {
                                        
                                            dataCell = ["title": dataTitle , "date": dataDate , "content": dataContent , "image": dataImage, "author": dataAuthor]
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                        self.userDict.append(dataCell)
                        
                    }
                    
                }
                
            }
            
            self.ai_Loading.stopAnimating()     //Stop spinning
            
            self.ai_Loading.isHidden = true     //To hide the activity indicator
            
            self.tbl_News.reloadData()
            
        }
        
    }
    
    func transitionViewController() {
        //This is for transition of views
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewsOneViewController") as! NewsOneViewController
        
        vc.contentsPassed = contentChosen
        
        vc.datePassed = dateChosen
        
        vc.titlePassed = titleChosen
        
        vc.imagePassed = imageChosen
        
        vc.authorPassed = authorChosen
        
        vc.dictPassed = userDict
        
        vc.indexNum = indexChosen
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func onShareButton(sender: UIButton) {  //This is the case when the share button is pressed
        
        // text to share
        let text = "\(titleChosen)\n\(dateChosen)\n\(contentChosen)"
        
        // set up activity view controller
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func interfacelayout() {
        
        //This is for the Interface
        
        self.navigationController?.isNavigationBarHidden = true
        
        tbl_News.delegate = self
        
        tbl_News.dataSource = self
        
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
        
        let date = NSDate(timeIntervalSince1970: timeResult)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        
        return dateFormatter.string(from: date as Date)
        
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        if (activityType == .postToFacebook) {
            dismiss(animated: true) { _ in }
            perform(#selector(self.postToFacebook), with: self, afterDelay: 1.0)
        }
        return nil
    }

    func postToFacebook() {
        let content = FBSDKShareLinkContent()
        content.quote = "dfdfdfdfdfdfdfdfdfd"
        content.contentURL = URL(string: "https://developers.facebook.com")
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = .shareSheet
        dialog.show()
    }

}

class Share: UIActivity {
    var navController: UINavigationController = UINavigationController()
     override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        NSLog("%@", #function)
        return true
    }
    
     override func prepare(withActivityItems activityItems: [Any]) {
        NSLog("%@", #function)
    }
    
      override func perform() {
        // Todo: handle action:
        NSLog("%@", #function)
        let content = FBSDKShareLinkContent()
        content.quote = "dfdfdfdfdfdfdfdfdfd"
        content.contentURL = URL(string: "https://developers.facebook.com")
        let dialog = FBSDKShareDialog()
//        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = .shareSheet
        dialog.show()
        self.activityDidFinish(true)
    }
    
    
//    override func activityType() -> String? {
//        return "TestActionss.Favorite"
//    }
//    
//    override func activityTitle() -> String? {
//        return "Add to Favorites"
//    }
    
//    override func activityViewController() -> UIViewController? {
//        NSLog("%@", #function)
//        return nil
//    }
    
//    override func activityImage() -> UIImage? {
//        return UIImage(named: "favorites_action")
//    }
}
