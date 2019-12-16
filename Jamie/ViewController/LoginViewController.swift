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
    var firebaseAPIControllerHandle: FirebaseAPI?
    var contents = [Highlight]()
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn();
        
        firebaseAPIControllerHandle = FirebaseAPI()
        guard let firebaseHandle = firebaseAPIControllerHandle else { return }
        
        firebaseHandle.checkLoginStatus { (result) in
            if result {
                //membership 조회
                
                //data 조회
                firebaseHandle.getContentsData { Highlights in
                    self.contents = Highlights
                }
                return
            } else {
                
                //membership 없으면 생성
                firebaseHandle.joinMembership()

                //or 로그인 화면 연결
//                let vc = self.switchToLoginPage()
//                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    deinit {
         guard let firebaseHandle = firebaseAPIControllerHandle else { return }
        firebaseHandle.removeCheckingLoginStatus()
    }

    
    private func switchToLoginPage() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        return controller
    }
    
    @IBAction func onClickGoogleButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    @IBAction func touchUpShowResult(_ sender: Any) {
        let firebaseHandle = FirebaseAPI()

        //TODO : saveButton에 사용
        guard let fakeData = makeFakeHightlightData() else { return }
//        firebaseAPIControllerHandle?.addDataAtDocument(collectionName: Constant.firebaseContentsCollectionName, data: fakeData)
        
        //TODO : List tab에서 refresh call 에 사용
//        firebaseAPIControllerHandle.getContentsData { highlights in
//            self.contents = highlights
//        }
    }
    
    private func makeFakeHightlightData() -> Highlight? {
        guard let uid = uid else { return nil }
        let hightlight = Highlight.init(highlightID: "asdf123123", createdAt: Date(), goalDate: nil, goal: "testtitle goal 12123123", uid: uid, feedback: "ayayyaayya", isSuccess: true)
        
        return hightlight
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
