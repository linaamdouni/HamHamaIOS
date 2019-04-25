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

class HomeList: UITableViewController {

    let URL_GET_RECETTES = "http://192.168.64.2/foodapp/affRecette.php"
    var recettes: [[String: Any]] = [[String: Any]]()
    var recipes: [Recette] = []
    var mail: String = ""
    var nom: String = ""
    var prenom: String = ""
    var birthday: String = ""
    var picture: String = ""
    var verif: Bool = false
    
    @IBOutlet var tab: UITableView!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return images.count
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // t3ayet el prepare automatiquement bch n3adi fel sender l'indexpath
        //performSegue(withIdentifier: "toDetails", sender: indexPath)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getRecettes(){
        //let row = self.users[1]
        //print(row["nom"] as? String)
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
                let youtube = i["urlYoutube"] as? String
                let id = i["idR"] as? String
                let rect = Recette(name: nomR!, desc: desc!, immg: img!, user_img: imgU!, user_name: nomU, youtube: youtube!, id: id!)
                self.recipes.append(rect)
            }
            self.tab.reloadData()
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
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else{
                fatalError("the selected cell is not being displayed by the table !!")
            }
            let selectedMeal = recipes[indexPath.row]
            mealDetailViewController.rec = selectedMeal
        default: fatalError("Unexpected segue identifier \(segue.identifier) !!")
        }
    }

}
