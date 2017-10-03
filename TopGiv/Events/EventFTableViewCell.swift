//
//  EventFTableViewCell.swift
//  TopGiv
//
//  Created by Artemis on 8/1/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class EventFTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lb_Title: UILabel!
    @IBOutlet weak var img_Back: UIImageView!
    @IBOutlet weak var lb_Place: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
//    @IBOutlet weak var bt_Share: UIButton!
//    @IBOutlet weak var bt_Donate: UIButton!
//    @IBOutlet weak var bt_Calendar: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
