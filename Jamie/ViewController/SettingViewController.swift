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
    var highlights = [Highlight]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        makeTestData()
    }
    
    func setupUI() {
        let nibName = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "SettingTableViewCell")
        self.view.addSubview(tableView)
    }
    
//    private func makeTestData() {
//        for i in 0..<10 {
//            var data = Highlight.init(highlightID: UUID(), date: Date(), title: "highlight")
//            data.memo = "오늘의 메모 123123 12312312 123123"
//            data.isSuccess = i % 2 == 0 ? true : false
//            highlights.append(data)
//        }
//        tableView.reloadData()
//    }
}



extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //임시 설정
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        let data = highlights[indexPath.row]
        
        //Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd"
        let dateString =  dateFormatter.string(from: data.createdDate)
//        cell.dateLabel.text = dateString
//        cell.titleLabel.text = data.title
        //
        return cell
    }
}
