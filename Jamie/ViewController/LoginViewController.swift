//
//  LoginViewController.swift
//  Jamie
//
//  Created by apple on 2019/12/13.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseFirestore


class LoginViewController: UIViewController, GIDSignInDelegate {
    @IBOutlet weak var signInGoogleButton: GIDSignInButton!
    

    var docRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn();
        
        let FirebaseAPIControllerHandle = FirebaseAPI()
        FirebaseAPIControllerHandle.setDatabase()
    }
    
    @IBAction func onClickGoogleButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    @IBAction func touchUpShowResult(_ sender: Any) {
        let FirebaseAPIControllerHandle = FirebaseAPI()
        FirebaseAPIControllerHandle.getUserData()
        FirebaseAPIControllerHandle.getAllDocumentsFromCollecton(collectionName: Constant.firebaseCollectionName)
        FirebaseAPIControllerHandle.getAllDataFromDocuments(collectionName: Constant.firebaseCollectionName)
        FirebaseAPIControllerHandle.getDatabase()

    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
        
        return googleDidHandle
    
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let authentication = user.authentication else { return }
        
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print(error.localizedDescription)
            return
          }
            guard let auth = user.authentication else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credentials) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Login Successful.")
                    //This is where you should add the functionality of successful login
                    //i.e. dismissing this view or push the home view controller etc
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print(sign)
    }
}
