//
//  AppDelegate.swift
//  HamHamaIOS
//
//  Created by Mac on 4/7/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData
import FacebookCore
import FacebookLogin
import GoogleSignIn
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
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
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            print("connect")
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            print(userId)
            print(idToken)
            print(email)
            print(familyName)
            print(givenName)
            print(fullName)
            
            
            self.mail = user.profile.email
            self.nom = user.profile.familyName
            self.prenom = user.profile.givenName
            self.birthday = "0000-00-00"
            self.picture = ""
            addUser()
            
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
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print("disconnect")
    }
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "649548438563-36r1r1jkfs19d3emopmuj330botapto8.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
 
  
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HamHamaIOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

