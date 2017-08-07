//
//  EventFViewController.swift
//  TopGiv
//
//  Created by Artemis on 8/1/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventFViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbl_Event: UITableView!
    
    var userDict:[NSDictionary] = []
    var eventData:[NSDictionary] = []
    
    var ref: DatabaseReference!
    var titleChosen = ""
    var dateChosen = ""
    var contentChosen = ""
    var imageChosen = ""
    var placeChosen = ""
    
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
        return 385
        
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
        
        cell.lb_Title.text = object["title"]! as? String        //This is a title of a event
        //        cell.lb_Date.text = object["date"]! as? String
        cell.img_Back.image = UIImage.init(named: (object["image"]! as? String)!)       //This is a image for a event
        cell.lb_Mark.layer.cornerRadius = 10
        cell.lb_Mark.clipsToBounds = true
        cell.lb_Place.text = object["place"]! as? String        //This is a place for a event
        cell.lb_Date.text = object["date"]! as? String          //This is a date for a event
        cell.img_Thumbnail.image = UIImage.init(named: (object["image"]! as? String)!)      //This is a thumbnail for a event
        
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identifier = "EventFTableViewCell"
//        let object = self.userDict[indexPath.row]
//        var cell: EventFTableViewCell! = tbl_Event.dequeueReusableCell(withIdentifier: identifier) as? EventFTableViewCell
//        if cell == nil {
//            tableView.register(UINib(nibName: "EventFTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
//            cell = tbl_Event.dequeueReusableCell(withIdentifier: identifier) as? EventFTableViewCell
//        }
//        
//        if(self.selectedButtonsArray.containsObject(indexPath.row)){
//            
//            cell.btnGetUpdates.backgroundColor = UIColor.redColor()
//            cell.btnGetUpdates.layer.borderColor = UIColor.darkGrayColor().CGColor
//            cell.btnGetUpdates.layer.borderWidth = 1
//            cell.btnGetUpdates.layer.cornerRadius = 5.0
//            
//        }else{
//            
//            cell.btnGetUpdates.layer.borderColor = UIColor.darkGrayColor().CGColor
//            cell.btnGetUpdates.layer.borderWidth = 1
//            cell.btnGetUpdates.layer.cornerRadius = 5.0
//            
//        }
//        
//        cell.lb_Title.text = object["title"]! as? String
//        cell.img_Back.image = UIImage.init(named: (object["image"]! as? String)!)
//        cell.lb_Mark.layer.cornerRadius = 10
//        cell.lb_Mark.clipsToBounds = true
//        cell.lb_Place.text = object["place"]! as? String
//        cell.lb_Date.text = object["date"]! as? String
//        cell.img_Thumbnail.image = UIImage.init(named: (object["image"]! as? String)!)
//        
////        cell.dateMissingPersonPlace.text = self.MissingPeoplePlace[indexPath.row]
////        cell.dateMissingPersonSince.text = self.MissingPeopleSince[indexPath.row]
//        
//        cell.bt_Share.tag = indexPath.row
//        cell.bt_Share.addTarget(self, action: "onShareButton", for: .touchUpInside)
//        
//        
//        return cell
//        
//    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //This is when a cell is selected
        titleChosen = (userDict[indexPath.row]["title"]! as? String)!
        dateChosen = (userDict[indexPath.row]["date"]! as? String)!
        contentChosen = (userDict[indexPath.row]["content"]! as? String)!
        imageChosen = (userDict[indexPath.row]["image"]! as? String)!
        placeChosen = (userDict[indexPath.row]["place"]! as? String)!
        
        self.transitionViewController()
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    func fetchData() {
        //This is for fetching data from Firebase
        ref = Database.database().reference()
        
        ref.child("events").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let dataTitle = ((child as! DataSnapshot).value as! NSDictionary)["title"] ?? ""
                let dataDate = ((child as! DataSnapshot).value as! NSDictionary)["date"] ?? ""
                let dataImage = ((child as! DataSnapshot).value as! NSDictionary)["image"] ?? ""
                let dataContent = ((child as! DataSnapshot).value as! NSDictionary)["content"] ?? ""
                let dataPlace = ((child as! DataSnapshot).value as! NSDictionary)["place"] ?? ""
                let data: NSDictionary = ["title": dataTitle as! String, "date": dataDate as! String, "content": dataContent as! String, "place": dataPlace as! String, "image": dataImage]
                self.userDict.append(data)
            }
            self.tbl_Event.reloadData()
        })
        
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
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func interfacelayout() {
        //This is for the Interface
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.isNavigationBarHidden = true
        tbl_Event.delegate = self
        tbl_Event.dataSource = self
        
    }
    
    func onShareButton(sender: UIButton) {
        
    }
    
}
