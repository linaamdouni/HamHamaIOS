//
//  checkBox4.swift
//  HamHamaIOS
//
//  Created by Mac on 4/22/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class checkBox4: UIButton {
    
    //images
    let checkedImage = UIImage(named: "checked") as! UIImage
    let uncheckedImage = UIImage(named: "nochecked") as! UIImage
    
    //bool property
    var ischecked: Bool = false{
        didSet{
            if ischecked == true{
                self.setImage(checkedImage, for: .normal)
            }else{
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        self.ischecked = false
    }
    
    @objc func buttonClicked(sender: UIButton){
        if sender == self{
            if ischecked == true{
                ischecked = false
                sender.tag = 7
            }else{
                ischecked = true
                sender.tag = 8
            }
        }
    }
    
}
