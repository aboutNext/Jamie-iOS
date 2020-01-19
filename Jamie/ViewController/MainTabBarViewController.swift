//
//  MainTabBarViewController.swift
//  Jamie
//
//  Created by USER on 2019/11/24.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseFirestore

class MainTabBarViewController: UIViewController, GIDSignInDelegate{

    @IBOutlet weak var contentView: UIView!
    @IBOutlet var buttons: [UIButton]!
    var homeViewController : UIViewController!
    var listViewController: UIViewController!
    var settingViewController: UIViewController!
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    var movingView = UIView()
    
    //firebase
    var docRef: DatabaseReference!
    var firebaseAPIControllerHandle: FirebaseAPI?
    var contents = [Highlight]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController")
        settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        
        
        viewControllers = [homeViewController, listViewController, settingViewController]
        
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn();
        
//        showHighlightOfToday()
        
    }
    
    deinit {
        guard let firebaseHandle = firebaseAPIControllerHandle else { return }
        firebaseHandle.removeCheckingLoginStatus()
    }
    
    //test
    //    func signInButton(_ sender: Any) {
    //        GIDSignIn.sharedInstance().signIn()
    //        GIDSignIn.sharedInstance()?.presentingViewController = self
    //    }
    
    
    private func getContentsData() {
        let firebaseHandle = FirebaseAPI()
        firebaseHandle.getContentsData { highlights in
            self.contents.append(highlights)
            //            self.contents = highlights
            print(self.contents)
            
        }
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        buttons[previousIndex].isSelected = false
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        let newx = sender.frame.origin.x
        
        UIView.animate(withDuration: 1.0) {
            self.movingView.frame.origin.x = newx
        }
    }
    
    
    func showLoginGuide() {
        firebaseAPIControllerHandle = FirebaseAPI()
        guard let firebaseHandle = firebaseAPIControllerHandle else { return }
        
        firebaseHandle.checkLoginStatus { (result) in
            if result {
                //membership 조회
                
//                data 조회
                
                self.getContentsData()

//                                firebaseHandle.getContentsData { Highlights in
//                                    self.contents = Highlights
//                                }
                return
            } else {
                
                //membership 없으면 생성
//                firebaseHandle.joinMembership()
                
                //or 로그인 화면 연결
                let vc = self.switchToLoginPage()
                self.present(vc, animated: true, completion: nil)
            }
        }
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
            print("로그인 정보 없음")
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
                    self.showLoginGuide()

                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print(sign)
    }
    
    private func switchToLoginPage() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        return controller
    }
}
