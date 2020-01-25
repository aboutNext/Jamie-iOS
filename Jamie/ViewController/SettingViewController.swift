//
//  SettingViewController.swift
//  Jamie
//
//  Created by apple on 2019/11/20.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

enum SettingViewCellType: Int {
    case appVersion = 0
    case logout
}

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
        
        let cellType = SettingViewCellType(rawValue: indexPath.row)
        
        switch cellType {
        case .appVersion:
            cell.titleLabel.text = Constant.settingViewVersionInfoTitle
            cell.detailLabel.text = "v 1.0.0"
        case .logout:
            cell.titleLabel.text = Constant.settingViewLogoutCellTitle
            cell.detailLabel.isHidden = true
        default:
            break
        }
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellType = SettingViewCellType(rawValue: indexPath.row)

        switch cellType {
        case .appVersion:
            
            break
        case .logout:
            
            break
        default:
            return
        }
    }
}

