//
//  NewsIndexViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/3/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class NewsIndexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbl_News: UITableView!
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
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDict.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 1 {
            return 120.0
        }
        else {
            return 340.0
        }
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 1 {
            let identifier = "NewsDefaultTableViewCell"
            let object = self.userDict[indexPath.row]
        
            var cell: NewsDefaultTableViewCell! = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsDefaultTableViewCell
        
            if cell == nil {
                tableView.register(UINib(nibName: "NewsDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsDefaultTableViewCell
            }
        
            cell.lb_Newstitle.text = object["title"]! as? String
            cell.lb_Newsdate.text = object["date"]! as? String
        
            return cell
        }
        else {
            let identifier = "NewsTableViewCell"
            let object = self.userDict[indexPath.row]
            
            var cell: NewsTableViewCell! = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tbl_News.dequeueReusableCell(withIdentifier: identifier) as? NewsTableViewCell
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
        
        self.userDict = [["title":"Richmond Ballet announces its $10 million Road to the future campaing", "date":"April 24, 2017"], 
                                ["title": "Minds in motion Israel 2017", "date": "March 24, 2017", "image": "news1_img.png"],
                                ["title":"School of Richmond ballet ensembles present: suite from sleeping beauty", "date":"March 23, 2017"],
                                ["title":"Three Richmond ballet company dancers announce retirement", "date":"March 6, 2017"]]

    }
    
    func transitionViewController() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewsOneViewController") as! NewsOneViewController
//        self.present(vc, animated: true) {
//            };
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func interfacelayout() {

        tbl_News.delegate = self
        tbl_News.dataSource = self
    }

}
