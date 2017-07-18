//
//  EventsIndexViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/5/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class EventsIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tbl_Events: UITableView!
    var userDict:[NSDictionary] = []
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDict.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 && indexPath.row != 3 {
            return 120.0
        }
        else {
            return 340.0
        }
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 && indexPath.row != 3 {
            let identifier = "NewsDefaultTableViewCell"
            let object = self.userDict[indexPath.row]
            
            var cell: NewsDefaultTableViewCell! = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsDefaultTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "NewsDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsDefaultTableViewCell
            }
            
            cell.lb_Newstitle.text = object["title"]! as? String
            
            cell.lb_Newsdate.text = object["date"]! as? String
            
            return cell
        }
        else {
            let identifier = "NewsTableViewCell"
            let object = self.userDict[indexPath.row]
            
            var cell: NewsTableViewCell! = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsTableViewCell
            }
            
            cell.lb_Newstitle.text = object["title"]! as? String
            cell.lb_Newsdate.text = object["date"]! as? String
            cell.img_News.image = UIImage.init(named: (object["image"]! as? String)!)
            
            return cell
            
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.transitionViewController()
        //        print("You tapped cell number \(indexPath.row).")
        
    }
    
    
    func fetchData() {
        
        self.userDict = [["title":"A world premiere by Melissa Barak, The Moor's Pavane (Limon/Purcell)", "date":"Apr 22, 2017, 5:30pm", "image":"event1_img.png"],
                         ["title":"Minds in motion culminating performance", "date":"Apr 19, 2017, 7:30pm"],
                         ["title":"Studio three - choreographer's club", "date":"March 15, 2017, 6:30pm"],
                         ["title":"Three strikingly different ballets with richmond symphony", "date":"Mar 2, 2017, 5:30pm", "image": "event2_img.png"]]
        
    }
    
    func transitionViewController() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EventsOneViewController") as! EventsOneViewController
        //        self.present(vc, animated: true) {
        //            };
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func interfacelayout() {
        tbl_Events.delegate = self
        tbl_Events.dataSource = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Events", style:.plain, target:nil, action:nil)
    }

}
