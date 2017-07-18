//
//  NewsTableViewCell.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/3/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_Newsdate: UILabel!
    @IBOutlet weak var img_News: UIImageView!
    @IBOutlet weak var lb_Newstitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
