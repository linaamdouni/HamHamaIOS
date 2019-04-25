//
//  CellHomeList.swift
//  HamHamaIOS
//
//  Created by Mac on 4/14/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class CellHomeList: UITableViewCell {
    
    
    @IBOutlet weak var lab1: UILabel!
    
    @IBOutlet weak var lab2: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var img_user: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
