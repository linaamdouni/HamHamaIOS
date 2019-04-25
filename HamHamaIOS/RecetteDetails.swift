//
//  RecetteDetails.swift
//  HamHamaIOS
//
//  Created by Mac on 4/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RecetteDetails: UIViewController,  UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var imgDeails: UIImageView!
    
    @IBOutlet weak var nameRecDetails: UILabel!
    
    @IBOutlet weak var descRecDetails: UITextView!
    
    @IBOutlet weak var imgYoutube: UIButton!
    
    var rec: Recette?
    
    
    
    var URL_GET_RECETTES = ""
    var recettes: [[String: Any]] = [[String: Any]]()
    var recipes: [Ingredient] = []
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DetailsRecTabCellTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.lb1.text = String(String(tvShowsDict.qt) + " " + String( tvShowsDict.nom ) + " " + String(tvShowsDict.unite))
        
        //imageSeason.image = UIImage(named: images[indexPath.row])
        let imagesRecette = String("http://192.168.64.2//foodapp//uploads//mekla//" + String( tvShowsDict.nom )+".png")
        cell.img.af_setImage(withURL: URL(string: imagesRecette )!)
        
        return cell
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let rec = rec{
            URL_GET_RECETTES = String("http://192.168.64.2/foodapp/IngbyRec.php?idR=" + String( rec.id ))
            navigationItem.title = rec.name
            nameRecDetails.text = rec.name
            descRecDetails.text = rec.desc
            let imagesRecette = String("http://192.168.64.2//foodapp//" + String( rec.immg ))
            imgDeails.af_setImage(withURL: URL(string: imagesRecette )!)
            if(rec.youtube.count != 0)
            {
                imgYoutube.isEnabled = true
            }
            else{
                imgYoutube.isEnabled = false
            }
        }
        
        getRecettes()
    }

    
    func getRecettes(){
        //let row = self.users[1]
        //print(row["nom"] as? String)
        self.recipes.removeAll()
        Alamofire.request(URL_GET_RECETTES, method: .get) .responseJSON{
            response in
            print(response)
            if let responseValue = response.result.value as! [String: Any]?{
                if let responseUser = responseValue["users"] as! [[ String:    Any]]?{
                    self.recettes = responseUser
                }
            }
            var c: Int = -1
            for i in self.recettes{
                c+=1
                let nom = i["nom"] as? String
                let qt = i["qt"] as? String
                let unite = i["unite"] as? String
                let Ing = Ingredient(nom: nom!, qt: qt!, unite: unite!)
                self.recipes.append(Ing)
            }
            self.tab.reloadData()
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "toYoutube":
            guard let mealDetailViewController = segue.destination as? RecetteDetailsYoutube else{
                fatalError("Unexpected destination \(segue.destination) !!")
            }
            
            let selectedMeal = rec?.youtube
            mealDetailViewController.you = selectedMeal
        case "toHome":
            print("heyel yesser")
        default: fatalError("Unexpected segue identifier \(segue.identifier) !!")
        }
    }
    
}
