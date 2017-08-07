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
    @IBOutlet weak var lb_Mark: UILabel!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var img_Thumbnail: UIImageView!

    @IBOutlet weak var bt_Like: UIButton!
    @IBOutlet weak var bt_Dislike: UIButton!
    @IBOutlet weak var bt_Heart: UIButton!
    @IBOutlet weak var bt_Share: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
