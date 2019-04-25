//
//  Recette.swift
//  HamHamaIOS
//
//  Created by Mac on 4/14/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
class Recette{
    var name: String
    var desc: String
    var immg: String
    var img_user: String
    var user_name: String
    var youtube: String
    var id: String
    
    init(name: String, desc: String, immg: String, user_img: String, user_name: String, youtube: String, id: String){
        self.name = name
        self.desc = desc
        self.immg = immg
        self.img_user = user_img
        self.user_name = user_name
        self.youtube = youtube
        self.id = id
    }
}
