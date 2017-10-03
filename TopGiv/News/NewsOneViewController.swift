//
//  NewsOneViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/4/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class NewsOneViewController: UIViewController {

    @IBOutlet var sv_Container: UIScrollView!
    @IBOutlet weak var tv_News: UITextView!
    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var img_Back: UIImageView!
    @IBOutlet weak var lb_FirstLetter: UILabel!
    @IBOutlet weak var lb_ContentsDemo: UILabel!
    @IBOutlet weak var ai_Loading: UIActivityIndicatorView!
    @IBOutlet weak var lb_Author: UILabel!
    @IBOutlet weak var bt_AA: UIButton!
    @IBOutlet weak var uv_Bottom: UIView!
    
    var contentsPassed = ""
    var datePassed = ""
    var titlePassed = ""
    var authorPassed = ""
    var imagePassed = ""
    var dictPassed:[NSDictionary] = []
    var indexNum = 0
    var flagAA = false
    var flagBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ai_Loading.isHidden = false
        
        ai_Loading.startAnimating()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swipeLeft)
        
        self.view.addGestureRecognizer(swipeRight)
        
        interfacelayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAA(_ sender: Any) {
        
        if flagAA {
            lb_ContentsDemo.font = UIFont(name: lb_ContentsDemo.font.fontName, size: 15)
            lb_ContentsDemo.numberOfLines = 5
            tv_News.font = UIFont(name: (tv_News.font?.fontName)!, size: 15)
            newsStyleString()
            flagAA = false
        }
        else {
            lb_ContentsDemo.font = UIFont(name: lb_ContentsDemo.font.fontName, size: 19)
            lb_ContentsDemo.numberOfLines = 4
            tv_News.font = UIFont(name: (tv_News.font?.fontName)!, size: 19)
            newsStyleString()
            flagAA = true
        }
        
    }
    

    @IBAction func onShare(_ sender: Any) {
        
        // text to share
        let text = "\(titlePassed)\n\(datePassed)\n\(contentsPassed)"
        
        // set up activity view controller
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
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
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                self.navigationController?.popViewController(animated: true)
                print("Swiped Previous")
            case UISwipeGestureRecognizerDirection.left:
                self.nextNews()
                print("Swiped Next")
            default:
                break
                
            }
        }
        
    }
    
    func interfacelayout() {
    //This is for Interface
        
        newsStyleString()
        
//        tv_News.text = contentsPassed
        
        lb_Date.text = datePassed
        
        lb_Title.text = titlePassed
        
        lb_Author.text = authorPassed
        
        getImage(imageurl: imagePassed, imageview: img_Back)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapNews))
        
        sv_Container.addGestureRecognizer(tap)
        
        uv_Bottom.isHidden = true
        
        flagBar = true
        
    }
    
    func tapNews() {
        
        if flagBar {
            
            uv_Bottom.isHidden = false
            flagBar = false
        }
        else {
            uv_Bottom.isHidden = true
            flagBar = true
        }
        
    }
    
    @IBAction func onNextStory(_ sender: Any) {
        
        nextNews()
        
    }
    
    
    @IBAction func onShareButton(_ sender: Any) {
        
        // text to share
        let text = "\(titlePassed)\n\(datePassed)\n\(contentsPassed)"

        // set up activity view controller
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
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
                        
                        self.ai_Loading.isHidden = true
                        
                        self.ai_Loading.stopAnimating()
                        
                    })
                    
                }
                
            }
            
        })
        
        task.resume()
        
    }
    
    func nextNews() {
        
        let num = dictPassed.count
        
        if (indexNum < num - 1) {
            indexNum = indexNum + 1
        }
        else {
            indexNum = 0
        }
        
        titlePassed = (dictPassed[indexNum]["title"]! as? String)!
        
        datePassed = unixtoDate(timeResult: Double((dictPassed[indexNum]["date"]! as? String)!)!)
        
        contentsPassed = (dictPassed[indexNum]["content"]! as? String)!
        
        imagePassed = (dictPassed[indexNum]["image"]! as? String)!
                
        interfacelayout()
        
    }

    func unixtoDate(timeResult: Double) -> String {
        //This is for converting the received date to the ordinary one
        
        let date = NSDate(timeIntervalSince1970: timeResult)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        
        return dateFormatter.string(from: date as Date)
        
    }
    
    func newsStyleString() {
        
        let contentsAll = contentsPassed
        
        lb_FirstLetter.text = String(contentsAll.characters.prefix(1))
        
        let contentsWithoutFirst = contentsAll.substring(from: contentsAll.index(contentsAll.startIndex, offsetBy: 1))
        
        let font: UIFont = lb_ContentsDemo.font
        
        let demoFrame: CGRect = lb_ContentsDemo.frame
        
        var numberOfCharsInDemo: Int = NSNotFound
        
        var number = contentsWithoutFirst.characters.count
        
        while number >= 0 {
            let index = contentsWithoutFirst.index(contentsWithoutFirst.startIndex, offsetBy: number)
            let substring: String? = contentsWithoutFirst.substring(to: index) //(text as? String)?.substring(to: index)
            let attributedText = NSAttributedString(string: substring!, attributes: [NSFontAttributeName: font])
            let size = CGSize(width: demoFrame.size.width, height: CGFloat.greatestFiniteMagnitude)
            let textFrame: CGRect = attributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
            if textFrame.height <= demoFrame.height {
                numberOfCharsInDemo = number
                break
            }
            number -= 1
        }
        
        if numberOfCharsInDemo == NSNotFound {
            
        }
        
        let index = contentsWithoutFirst.index(contentsWithoutFirst.startIndex, offsetBy: numberOfCharsInDemo)
        
        lb_ContentsDemo.text = contentsWithoutFirst.substring(to: index)
        
        tv_News.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tv_News.text = contentsWithoutFirst.substring(from: index)
        
        //This is for adjusting height of scroll view
        let fixedWidth = tv_News.frame.size.width
        
        tv_News.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = tv_News.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        var newFrame = tv_News.frame
        
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        tv_News.frame = newFrame;
        
//        let shareY = newFrame.height + tv_News.frame.origin.y + 25
        
//        bt_Share.center.y = shareY
        
        sv_Container.contentSize = CGSize(width: self.view.frame.width, height: tv_News.frame.origin.y + newFrame.height + 10)
        
    }
    
}
