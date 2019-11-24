//
//  MainTabBarViewController.swift
//  Jamie
//
//  Created by USER on 2019/11/24.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit
class MainTabBarViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet var buttons: [UIButton]!
    var homeViewController : UIViewController!
    var listViewController: UIViewController!
    var settingViewController: UIViewController!
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    var movingView = UIView()

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
}

