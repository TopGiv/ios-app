//
//  NewsDTableViewCell.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/18/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class NewsDTableViewCell: UITableViewCell {

    @IBOutlet var img_Back: UIImageView!
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
