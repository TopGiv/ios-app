//
//  NewsEViewController.swift
//  TopGiv
//
//  Created by Hera on 8/30/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import Alamofire

class NewsEViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tbl_News: UITableView!
    @IBOutlet weak var ai_Loading: UIActivityIndicatorView!
    
    var userDict:[NSDictionary] = []
    var newsData:[NSDictionary] = []
    var titleChosen = ""
    var dateChosen = ""
    var contentChosen = ""
    var imageChosen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This for showing Donation button on the tab bar
        self.tabBarController?.tabBar.items?[2].selectedImage = UIImage(named: "donate_icon.png")!.withRenderingMode(.alwaysOriginal)
        
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "donate_icon.png")!.withRenderingMode(.alwaysOriginal)
        
        // Do any additional setup after loading the view.
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
        
        if indexPath.row == 0 {
            
            return 206.0
            
        }
        else {
            
            return 110.0
            
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This is for the cells except for the top one
        if indexPath.row != 0 {
            
            let identifier = "NewsCTableViewCell"
            
            let object = self.userDict[indexPath.row]
            
            var cell: NewsCTableViewCell! = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsCTableViewCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "NewsCTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                
                cell = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsCTableViewCell
                
            }
            
            cell.lb_Title.text = object["title"]! as? String        //This is a title of a news
            
            cell.lb_Date.text = unixtoDate(timeResult: Double((object["date"]! as? String)!)!)      //This is a date for a news
            
            getImage(imageurl: (object["image"]! as? String)!, imageview: cell.img_Top)     //This is a image for a event
            
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
            
        else {      //This is for the top cell
            
            let identifier = "NewsDTableViewCell"
            
            let object = self.userDict[indexPath.row]
            
            var cell: NewsDTableViewCell! = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsDTableViewCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "NewsDTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                
                cell = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsDTableViewCell
                
            }
            
            cell.lb_Title.text = object["title"]! as? String        //This is a title of a news
            
            cell.lb_Date.text = unixtoDate(timeResult: Double((object["date"]! as? String)!)!)      //This is a date for a event
            
            getImage(imageurl: (object["image"]! as? String)!, imageview: cell.img_Back)        //This is a image for a event
            
            return cell
            
        }
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //This is when a cell is selected
        titleChosen = (userDict[indexPath.row]["title"]! as? String)!
        
        dateChosen = unixtoDate(timeResult: Double((userDict[indexPath.row]["date"]! as? String)!)!)
        
        contentChosen = (userDict[indexPath.row]["content"]! as? String)!
        
        imageChosen = (userDict[indexPath.row]["image"]! as? String)!
        
        self.transitionViewController()
        
        print("You tapped cell number \(indexPath.row).")
        
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
                
                print("&&&\(json)")
                
                if let data = json["data"] as? Array<AnyObject> {
                    
                    var dataCell: NSDictionary = [:]
                    
                    for myEntry in data {
                        
                        print("&&&\(myEntry)")
                        
                        if let dataTitle = myEntry["title"] as? String {
                            
                            if let dataContent = myEntry["content"] as? String {
                                
                                if let dataDate = myEntry["date"] as? String {
                                    
                                    if let dataImage = myEntry["image"] as? String {
                                        
                                            dataCell = ["title": dataTitle , "date": dataDate , "content": dataContent , "image": dataImage]
                                        
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
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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

}
