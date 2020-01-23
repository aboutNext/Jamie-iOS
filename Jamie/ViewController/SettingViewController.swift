//
//  SettingViewController.swift
//  Jamie
//
//  Created by apple on 2019/11/20.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let nibName = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "SettingTableViewCell")
        self.view.addSubview(tableView)
        
        self.tableView.backgroundColor = Colors.backgroundGray
        
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Colors.backgroundGray
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //임시 설정
        return Constant.settingViewHeightForHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        let row = indexPath.row
        if row == 0 {
            cell.titleLabel.text = Constant.settingViewVersionInfoTitle
            cell.detailLabel.text = "v 1.0.0"
        } else {
            cell.titleLabel.text = Constant.settingViewLogoutCellTitle
            cell.detailLabel.isHidden = true
        }
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

