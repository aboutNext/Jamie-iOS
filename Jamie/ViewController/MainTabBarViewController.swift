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
    var homeViewController : HomeViewController!
    var listViewController: ListViewController!
    var settingViewController: SettingViewController!
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    var movingView = UIView()
    
    //firebase
    var docRef: DatabaseReference!
    var firebaseAPIControllerHandle: FirebaseAPI?
    var contents = [Highlight]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn();
    }
    
    deinit {
        guard let firebaseHandle = firebaseAPIControllerHandle else { return }
        firebaseHandle.removeCheckingLoginStatus()
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
        let manager = HighlightManager.sharedInstance
        manager.showLoginGuide { result in
            if result {
                manager.isLoggedIn = true
                manager.getHighlights { result in
                    if result {
                        self.homeViewController.findTodayData()
                        self.listViewController.highlights = manager.contents
                    }
                }
                
                
            } else {
                manager.isLoggedIn = false
            }
        }
    }

    private func setupViews() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
        
        viewControllers = [homeViewController, listViewController, settingViewController]
        buttons[selectedIndex].isSelected = true
        didPressTab(buttons[selectedIndex])
    }
}

extension MainTabBarViewController {
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
            //임시
            self.showLoginGuide()
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
}
