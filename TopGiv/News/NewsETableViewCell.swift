//
//  NewsETableViewCell.swift
//  TopGiv
//
//  Created by Hera on 9/14/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class NewsETableViewCell: UITableViewCell {

    @IBOutlet weak var img_Back: UIImageView!
    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var lb_Author: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
