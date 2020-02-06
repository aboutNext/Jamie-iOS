//
//  ListViewController.swift
//  About
//
//  Created by yunseo on 11/20/19.
//  Copyright © 2019 aboutNext. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyNoticeLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var highlights = [Highlight]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLoginStatus()
        //        indicator.isHidden = true

    }
    
    func setupUI() {
        indicator.isHidden = false
        indicator.startAnimating()
        
        let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ListTableViewCell")
        self.view.addSubview(tableView)
        
        let xib = UINib(nibName: "ListTableHeaderView", bundle: nil)
        tableView.register(xib, forHeaderFooterViewReuseIdentifier: "ListTableHeaderView")
    }
    
    func checkLoginStatus() {
        let manager = HighlightManager.sharedInstance
        manager.showLoginGuide { isSuccess in
            if isSuccess {
                self.getListData()

            } else {
                
            }
        }
    }
    
    func getListData() {
        let manager = HighlightManager.sharedInstance
        manager.getHighlights { result in
            if result {
                self.highlights = manager.contents
                self.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newData = highlights[indexPath.row]

        let content = Content.init(targetDate: newData.targetDate, highlight: newData.highlight, memo: newData.memo, status: newData.status)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        homeVC.modalPresentationStyle = .overCurrentContext
//        homeVC.showEvaluableViews(isEvaluabled: true)
     
        present(homeVC, animated: true) {
            homeVC.content = content
                 homeVC.showWrittenContent(data: content)
        }
//        present(homeVC, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlights.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ListTableHeaderView") as! ListTableHeaderView
        //TODO:
        headerView.dateLabel.text = "2020년 1월"

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //임시 설정
        return Constant.listViewHeightForHeader
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let data = highlights[indexPath.row]
        
        if data.updatedDate != nil {
            let formatter = DateFormatter()
            //TODO : 한국에만 아래 해당 (eng: EE - Tue 로)
            formatter.locale = Locale(identifier:"ko")
            formatter.dateFormat = "MMM d EEE"
            let dateString =  formatter.string(from: data.updatedDate!)
            cell.dateLabel.text = dateString
        }
        cell.titleLabel.text = data.highlight
        
        guard let status = data.status else {
            cell.dateImageView.isHidden = true
            return cell
        }
        cell.showStatusLabel(status: status)
        return cell
    }
}
