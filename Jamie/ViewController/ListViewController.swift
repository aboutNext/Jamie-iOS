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
     
     func setupUI() {
         let nibName = UINib(nibName: "ListTableViewCell", bundle: nil)
         tableView.register(nibName, forCellReuseIdentifier: "ListTableViewCell")
         self.view.addSubview(tableView)
    }
}



extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    //Date : Constant.listViewHeightForHeader

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
//        let data = highlights[indexPath.row]

        //Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd"
//        let dateString =  dateFormatter.string(from: data.createdDate)
//        cell.dateLabel.text = dateString
//        cell.titleLabel.text = data.title
//        
//        if let name = card.imageName, let testImage = UIImage(named: name) {
//            cell.backgroundImageView.image = testImage
//        }
//        //test
//        if let image = card.image {
//            cell.backgroundImageView.image = image
//        }
        return cell
    }
}
