//
//  RecetteDetailsYoutube.swift
//  HamHamaIOS
//
//  Created by Mac on 4/20/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class RecetteDetailsYoutube: UIViewController {
    
    @IBOutlet weak var webView2: WKWebView!
    
    var you: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getVideo(videoCode: you!)
    }
    

    func getVideo(videoCode : String){
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        webView2.load(URLRequest(url: url!))
    }

}
