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
    var highlights = [Highlight]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
     func setupUI() {
         let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
         tableView.register(nibName, forCellReuseIdentifier: "ListTableViewCell")
         self.view.addSubview(tableView)
        
        let xib = UINib(nibName: "ListTableHeaderView", bundle: nil)
        tableView.register(xib, forHeaderFooterViewReuseIdentifier: "ListTableHeaderView")
    }
}



extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlights.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ListTableHeaderView") as! ListTableHeaderView
//        headerView.dateLabel.text = "Date test"
//        headerView.contentView.backgroundColor = Colors.backgroundGray
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
            formatter.locale = Locale(identifier:"ko_KR")
            formatter.dateFormat = "MM DD EEEE"
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
