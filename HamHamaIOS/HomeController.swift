//
//  HomeList.swift
//  HamHamaIOS
//
//  Created by Mac on 4/14/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Floaty
import Lottie

class HomeController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lottie: LottieView!
    var URL_GET_RECETTES = "http://192.168.64.2/foodapp/affRecette.php"
    var recettes: [[String: Any]] = [[String: Any]]()
    var recipes: [Recette] = []
    var mail: String = ""
    var nom: String = ""
    var prenom: String = ""
    var birthday: String = ""
    var picture: String = ""
    var verif: Bool = false
    
    @IBOutlet var tab: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "cell"
        
        let tvShowsDict = recipes[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CellHomeList  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.lab1.text = String("Recette : " + String( tvShowsDict.name ))
        cell.lab2.text = String ("Description : " + String( tvShowsDict.desc ))
        cell.user_name.text = String( tvShowsDict.user_name )
        
        //imageSeason.image = UIImage(named: images[indexPath.row])
        let imagesRecette = String("http://192.168.64.2//foodapp//" + String( tvShowsDict.immg ))
        cell.img.af_setImage(withURL: URL(string: imagesRecette )!)
        
        let imageUser = String("http://192.168.64.2//foodapp//" + String( tvShowsDict.img_user ))
        cell.img_user.af_setImage(withURL: URL(string: imageUser )!)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // t3ayet el prepare automatiquement bch n3adi fel sender l'indexpath
        //performSegue(withIdentifier: "toDetails", sender: indexPath)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*let floaty = Floaty()
        floaty.addItem("Hello, World!", icon: UIImage(named: "email")!)
        self.view.addSubview(floaty)*/
        
        
        /*let animationView = AnimationView(name: "add");
        
        animationView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        self.view.addSubview(animationView)
        animationView.play()*/
        
        getRecettes()
        
        
        /*Alamofire.request("http://api.tvmaze.com/shows/66/seasons").responseJSON{ response in
         print("response reponse : *********")
         
         print(response.result.value)
         
         let tvShowArray = response.result.value as! NSArray
         
         self.tvShows = tvShowArray
         
         //print(self.seasons.count)
         
         self.tab.reloadData()
         }*/
        
    }
    
   
    
    func getRecettes(){
        //let row = self.users[1]
        //print(row["nom"] as? String)
        self.recipes.removeAll()
        Alamofire.request(URL_GET_RECETTES, method: .post) .responseJSON{
            response in
            print(response)
            if let responseValue = response.result.value as! [String: Any]?{
                if let responseUser = responseValue["recettes"] as! [[ String:    Any]]?{
                    self.recettes = responseUser
                }
            }
            var c: Int = -1
            for i in self.recettes{
                c+=1
                let nomR = i["nomR"] as? String
                let desc = i["description"] as? String
                let img = i["img_url_recette"] as? String
                let imgU = i["img_url"] as? String
                let nomU = String((i["nom"] as? String)! + String(" ") +  String( String((i["prenom"] as? String)!  )))
                let youtube = (i["urlYoutube"] as? String)!
                let id = (i["idR"] as? String)!
                let rect = Recette(name: nomR!, desc: desc!, immg: img!, user_img: imgU!, user_name: nomU, youtube: youtube, id: id)
                self.recipes.append(rect)
            }
            self.tab.reloadData()
        }
        
    }
    
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            URL_GET_RECETTES = "http://192.168.64.2/foodapp/affRecette.php"
            getRecettes()
            break
        case 1:
            URL_GET_RECETTES = "http://192.168.64.2/foodapp/categories/MainDish.php"
            getRecettes()
            break
        case 2:
            URL_GET_RECETTES = "http://192.168.64.2/foodapp/categories/Dessert.php"
            getRecettes()
            break
        case 3:
            URL_GET_RECETTES = "http://192.168.64.2/foodapp/categories/Snacks.php"
            getRecettes()
            break
        case 4:
            URL_GET_RECETTES = "http://192.168.64.2/foodapp/categories/Drinks.php"
            getRecettes()
            break
        default:
            break
        }
    }
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "toDetails":
            guard let mealDetailViewController = segue.destination as? RecetteDetails else{
                fatalError("Unexpected destination \(segue.destination) !!")
            }
            guard let selectedMealCell = sender as? CellHomeList else{
                fatalError("Unexpected sender \(sender)")
            }
            guard let indexPath = tab.indexPath(for: selectedMealCell) else{
                fatalError("the selected cell is not being displayed by the table !!")
            }
            let selectedMeal = recipes[indexPath.row]
            mealDetailViewController.rec = selectedMeal
        case "toADD":
            print("add")
        default: fatalError("Unexpected segue identifier \(segue.identifier) !!")
        }
    }
    
}
