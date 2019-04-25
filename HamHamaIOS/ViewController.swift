//
//  ViewController.swift
//  HamHamaIOS
//
//  Created by Mac on 4/7/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import Alamofire


class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let URL_GET_USERS = "http://192.168.64.2/foodapp/affUsers.php"
    let URL_ADD_USER = "http://192.168.64.2/foodapp/inscri.php"
    var users: [[String: Any]] = [[String: Any]]()
    var mail: String = ""
    var nom: String = ""
    var prenom: String = ""
    var birthday: String = ""
    var picture: String = ""
    var verif: Bool = false
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print("erreura")
            print(error)
            return
        }
        print("********************************************")
        print(user.profile.email)
        print("********************************************")
        print(user.profile.imageURL(withDimension:400))
        
    }
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton(frame: CGRect(x:0,y:0,width: 200,height: 42))
        button.readPermissions=["email"]
        return button
    }()
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LOG OUT")
        self.verif = false
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed LOGIN")
        fetchProfile()
        addUser()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tryController = storyBoard.instantiateViewController(withIdentifier: "try") as! HomeController
        self.present(tryController, animated: true, completion: nil)
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Facebook
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        if let token = FBSDKAccessToken.current(){
            fetchProfile()
        }
        
        //Google
        //
        var error: NSError?
        GGLContext.sharedInstance()?.configureWithError(&error)
        /*if error != nil {
            print("erreura")
            print(error)
            return
        }*/
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signInSilently()
        let signInButton = GIDSignInButton(frame: CGRect(x:103,y:490,width: 207,height: 60))
        //signInButton.center = view.center
        view.addSubview(signInButton)
    }
    func fetchProfile(){
        print("fetch profile")
        let parameters = ["fields": "email, first_name, last_name, birthday, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start {
            (connection, result, error)->Void in
            if error != nil {
                print(error)
                return
            }
            if let userInfo = result as? [String: Any] {
                if let email = userInfo["email"] as? String{
                    print(email)
                    self.mail = userInfo["email"] as! String
                }
                if let nom = userInfo["last_name"] as? String{
                    print(nom)
                    self.nom = userInfo["last_name"] as! String
                }
                if let prenom = userInfo["first_name"] as? String{
                    print(prenom)
                    self.prenom = userInfo["first_name"] as! String
                }
                if let birthday = userInfo["birthday"] as? String{
                    print(birthday)
                    self.birthday = userInfo["birthday"] as! String
                }
                if let picture = userInfo["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                    print(url)
                    self.picture = url
                }
                print(userInfo)
            }
        }
    }
    
    
    
    func addUser(){
        //let row = self.users[1]
        //print(row["nom"] as? String)
        Alamofire.request(URL_GET_USERS, method: .post) .responseJSON{
            response in
            print(response)
            if let responseValue = response.result.value as! [String: Any]?{
                if let responseUser = responseValue["recettes"] as! [[ String:    Any]]?{
                    self.users = responseUser
                }
            }
            var c: Int = -1
            for i in self.users{
                c+=1
                print(self.mail)
                print(i["email"] as? String)
                if i["email"] as? String == self.mail{
                    print("equal !")
                    print(i)
                    print("haw l id")
                    print(i["id"])
                    print(self.mail)
                    self.verif = true
                }
            }
            print(self.verif)
            if(!self.verif){
                let parameters: Parameters=[
                    "nom":self.nom,
                    "prenom":self.prenom,
                    "date":self.birthday,
                    "email":self.mail,
                    "mdp":"",
                    "img_url":self.picture
                ]
                Alamofire.request(self.URL_ADD_USER, method: .post, parameters: parameters).responseJSON
                    {
                        response in
                        //printing response
                        print(response)
                        print("ADDED SUCCESSFULY")
                }
            }else{
                print("WELCOME")
            }
        }
    }

}

