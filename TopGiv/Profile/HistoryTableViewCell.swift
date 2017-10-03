//
//  HistoryTableViewCell.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/7/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var lb_Category: UILabel!
    @IBOutlet var lb_Date: UILabel!
    @IBOutlet var lb_Amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
