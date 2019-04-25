//
//  AddRecipe.swift
//  HamHamaIOS
//
//  Created by Mac on 4/21/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AddRecipe: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var B4: checkBox4!
    @IBOutlet weak var B3: checkBox3!
    @IBOutlet weak var B2: checkBox2!
    @IBOutlet weak var B1: checkBox!
    @IBOutlet weak var B_add: UIButton!
    @IBOutlet weak var B_img: UIButton!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    @IBOutlet weak var AddImg: UIImageView!
    @IBOutlet weak var RecipeName: UITextField!
    @IBOutlet weak var DescRecipe: UITextField!
    @IBOutlet weak var youtubeRecipe: UITextField!
    
    let URL_ADD_RECIPE = "http://192.168.64.2/foodapp/ajoutRecette.php"
    let URL_ADD_CATEG = "http://192.168.64.2/foodapp/ajoutCategories.php"
    
    @IBAction func addImageAction(_ sender: UIButton) {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.photoLibrary
        img.allowsEditing = false
        self.present(img, animated: true){
            //After it is compelet
        }
    }
    var imageStr = ""
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
     AddImg.image = image
     let imageData = image.jpegData(compressionQuality: 0)!
     imageStr = imageData.base64EncodedString()
     print(imageStr)
     print(imageStr.count)
     }else{
     //error
     }
     self.dismiss(animated: true, completion: nil)
     }*/
    
    
    
    
    
    func getImageFromBase64(base64:String) -> UIImage {
        let data = Data(base64Encoded: base64)
        return UIImage(data: data!)!
    }
    
    
    
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            AddImg.image = image
            
            
            let img = AddImg.image?.jpegData(compressionQuality: 0.5)
            
            //let imgTry = UIImage(named: "email")!
            //let imgtry2 = imgTry.jpegData(compressionQuality: 0.1)
            imageStr = img!.base64EncodedString()
            
            //AddImg.image = getImageFromBase64(base64: imageStr)
            
        } else {
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wait.isHidden = true
    }
    
    var check1 = 0
    var check2 = 0
    var check3 = 0
    var check4 = 0
    @IBAction func checkBoxChecked(_ sender: UIButton){
        print(sender.tag)
        if sender.tag == 1{
            check1 = 2
        }else{
            check1 = 1
        }
    }
    @IBAction func checkBoxChecked2(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag == 3{
            check2 = 4
        }else{
            check2 = 3
        }
    }
    @IBAction func checkBoxChecked3(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag == 5{
            check3 = 6
        }else{
            check3 = 5
        }
    }
    @IBAction func checkBoxChecked4(_ sender: UIButton) {
        print(sender.tag)
        if sender.tag == 7{
            check4 = 8
        }else{
            check4 = 7
        }
    }
    
    
    @IBAction func addAction(_ sender: UIButton) {
        addRec()
        self.RecipeName.isEnabled = false
        self.DescRecipe.isEnabled = false
        self.youtubeRecipe.isEnabled = false
        self.B_img.isEnabled = false
        self.B_add.isEnabled = false
        self.B1.isEnabled = false
        self.B2.isEnabled = false
        self.B3.isEnabled = false
        self.B4.isEnabled = false


        self.wait.isHidden = false
        self.wait.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.addCateg()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tryController = storyBoard.instantiateViewController(withIdentifier: "try") as! HomeController
            self.present(tryController, animated: true, completion: nil)
            self.wait.stopAnimating()
            self.wait.isHidden = true
        })
    }
    
    
    func addRec(){
        let parameters: Parameters=[
            "nomR":RecipeName.text!,
            "description":DescRecipe.text!,
            "urlYoutube":youtubeRecipe.text!,
            "nb_love":"0",
            "idU":"60",
            "img_url_recette":imageStr
        ]
        Alamofire.request(self.URL_ADD_RECIPE, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                print("ADDED SUCCESSFULY")
        }
    }
    
    
    func addCateg(){
    
        if check1 == 2 {
            let parameters: Parameters=[
                "Categ":"Main Dish",
            ]
            Alamofire.request(self.URL_ADD_CATEG, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    print("ADDED SUCCESSFULY")
            }
        }
        if check2 == 4 {
            let parameters: Parameters=[
                "Categ":"Dessert",
            ]
            Alamofire.request(self.URL_ADD_CATEG, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    print("ADDED SUCCESSFULY")
            }
        }
        if check3 == 6 {
            let parameters: Parameters=[
                "Categ":"Snacks",
            ]
            Alamofire.request(self.URL_ADD_CATEG, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    print("ADDED SUCCESSFULY")
            }
        }
        if check4 == 8 {
            let parameters: Parameters=[
                "Categ":"Drinks",
            ]
            Alamofire.request(self.URL_ADD_CATEG, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    print("ADDED SUCCESSFULY")
            }
        }
        
        
    }
    
}





