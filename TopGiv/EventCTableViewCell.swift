//
//  EventCTableViewCell.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/28/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class EventCTableViewCell: UITableViewCell {
    
    @IBOutlet var im_Events: UIImageView!
    @IBOutlet var lb_Title: UILabel!
    @IBOutlet var lb_Date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
