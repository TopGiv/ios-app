//
//  DonationHistoryViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/2/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import AAPickerView
import FirebaseDatabase
import FirebaseAuth
import RSLoadingView
import MGSwipeTableCell


class DonationHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bt_Emailreceipts: UIButton!
    @IBOutlet var tbl_History: UITableView!
    @IBOutlet var pv_Emailreceipt: AAPickerView!
    var ref:DatabaseReference!
    var userDict:[NSDictionary] = []
    var emailPassed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configPicker()
        interfacelayout()
        fetchData()
        
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
        return 83.0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let identifier = "HistoryTableViewCell"
            let object = self.userDict[indexPath.row]
            var cell: HistoryTableViewCell! = tbl_History.dequeueReusableCell(withIdentifier: identifier) as? HistoryTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tbl_History.dequeueReusableCell(withIdentifier: identifier) as? HistoryTableViewCell
            }
            
            cell.lb_Category.text = object["category"]! as? String
            
            cell.lb_Date.text = object["date"]! as? String
        
            cell.lb_Amount.text = object["amount"]! as? String
            
            return cell
        
    }
/*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "HistoryTableViewCell"
        let object = self.userDict[indexPath.row]
        let cell = tbl_History.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MGSwipeTableCell
        
        cell.textLabel!.text = object["category"]! as? String
        cell.detailTextLabel!.text = object["date"]! as? String
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: .green),
                            MGSwipeButton(title: "", icon: UIImage(named:"fav.png"), backgroundColor: .blue)]
        cell.leftSwipeSettings.transition = .rotate3D
        
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: .red),
                             MGSwipeButton(title: "More",backgroundColor: .lightGray)]
        cell.rightSwipeSettings.transition = .rotate3D
        
        return cell
    }
*/
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.transitionViewController(index: indexPath.row)
        //        print("You tapped cell number \(indexPath.row).")
        
    }

    
    func fetchData() {
        
//        self.userDict = [["category":"General Fund", "date":"Apr 27, 2017", "amount":"$25"], ["category":"Minds in Motion", "date":"Apr 27, 2017", "amount":"$35"], ["category":"The School of Richmond Ballet", "date":"Apr 27, 2017", "amount":"$100"]]
        
        ref = Database.database().reference()        
        ref.child("donation_history").queryOrdered(byChild: "email").queryEqual(toValue: Auth.auth().currentUser?.email).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let dataCategory = ((child as! DataSnapshot).value as! NSDictionary)["title"] ?? ""
                let dataDate = ((child as! DataSnapshot).value as! NSDictionary)["date"] ?? ""
                let dataAmount = ((child as! DataSnapshot).value as! NSDictionary)["amount"] ?? ""
                let data: NSDictionary = ["category": dataCategory as! String, "date": dataDate as! String, "amount": "$\(dataAmount)"]
                self.userDict.append(data)
            }
            self.tbl_History.reloadData()
        })
        
    }
    
    func transitionViewController(index: Int) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DonationViewController") as! DonationViewController
        
        vc.amountPassed = ((self.userDict[index])["amount"]! as? String)!
        vc.datePassed = ((self.userDict[index])["date"]! as? String)!
        vc.categoryPassed = ((self.userDict[index])["category"]! as? String)!
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configPicker() {
        pv_Emailreceipt.pickerType = .DatePicker
        
        pv_Emailreceipt.datePicker?.datePickerMode = .date
        
        pv_Emailreceipt.dateDidChange = { date in
            print("selectedDate ", date)
        }

    }
    
    
    
    func interfacelayout() {
        tbl_History.delegate = self
        tbl_History.dataSource = self
        pv_Emailreceipt.text = "Email Receipts"
        pv_Emailreceipt.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        pv_Emailreceipt.textColor = UIColor.white
        pv_Emailreceipt.textAlignment = .center
        bt_Emailreceipts.layer.cornerRadius = 20
        bt_Emailreceipts.clipsToBounds = true
        let loadingView = RSLoadingView()
        loadingView.sizeFactor = 1.0
        loadingView.speedFactor = 2.0
        loadingView.lifeSpanFactor = 1.0
        loadingView.spreadingFactor = 2.0
        loadingView.sizeInContainer = CGSize(width: 90, height: 90)
        loadingView.show(on: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            loadingView.hide()
        })
        self.navigationController?.navigationItem.title = "Donation History"
    }

    func displayConfirm() {
        let alertController = UIAlertController(title: "Confirmation", message: "All receipts have been sent to \(emailPassed)", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
