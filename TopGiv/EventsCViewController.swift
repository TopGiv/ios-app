//
//  EventsCViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/19/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class EventsCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        if indexPath.row == 0 {
            return 246.0
        }
        else {
            return 140.0
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let identifier = "NewsCTableViewCell"
            let object = self.userDict[indexPath.row]
            
            var cell: NewsCTableViewCell! = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsCTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "NewsCTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsCTableViewCell
            }
            
            cell.lb_Title.text = object["title"]! as? String
            cell.lb_Date.text = object["date"]! as? String
            cell.img_Top.image = UIImage.init(named: (object["image"]! as? String)!)
            
            return cell
        }
        else {
            let identifier = "NewsDTableViewCell"
            let object = self.userDict[indexPath.row]
            
            var cell: NewsDTableViewCell! = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsDTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "NewsDTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tbl_Events.dequeueReusableCell(withIdentifier: identifier) as? NewsDTableViewCell
            }
            
            cell.lb_Title.text = object["title"]! as? String
            cell.lb_Title.textColor = UIColor(red: 48/255, green: 111/255, blue: 141/255, alpha: 1)
            cell.lb_Date.text = object["date"]! as? String
            cell.img_Back.image = UIImage.init(named: (object["image"]! as? String)!)
            
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
                         ["title":"Minds in motion culminating performance", "date":"Apr 19, 2017, 7:30pm", "image": "news_img1.png"],
                         ["title":"Studio three - choreographer's club", "date":"March 15, 2017, 6:30pm", "image": "news_img2.png"],
                         ["title":"Three strikingly different ballets with richmond symphony", "date":"Mar 2, 2017, 5:30pm", "image": "news_img3.png"]]
        
/*        self.userDict = [["title":"School of Richmond ballet ensembles present: suite from sleeping beauty", "date":"April 24, 2017", "image": "news_img0.png"],
                         ["title": "Richmond Ballet announces its $10 million Road to the future campaing", "date": "March 24, 2017", "image": "news_img1.png"],
                         ["title":"Minds in motion Israel 2017", "date":"March 23, 2017", "image": "news_img2.png"],
                         ["title":"Three Richmond ballet company dancers announce retirement", "date":"March 6, 2017", "image": "news_img3.png"]]
*/
    }
    
    func transitionViewController() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EventsOneViewController") as! EventsOneViewController
        //        self.present(vc, animated: true) {
        //            };
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func interfacelayout() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        tbl_Events.delegate = self
        tbl_Events.dataSource = self
    }

}
