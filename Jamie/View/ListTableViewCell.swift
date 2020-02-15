//
//  ListTableViewCell.swift
//  About
//
//  Created by yunseo on 11/20/19.
//  Copyright © 2019 aboutNext. All rights reserved.
//

import UIKit

enum evaluationState: String {
    case none = "none"
    case success = "success"
    case fail = "fail"
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    //TODO: Enum으로 분리
    func showStatusLabel(status: String) {
        guard let statusType = evaluationState(rawValue: status) else {
            return
        }
        
        switch statusType {
        case .none:
            dateImageView.isHidden = true
        case .success:
            dateImageView.isHidden = false
            dateImageView.image = UIImage(named: "text-highlight-green")
        case .fail:
            dateImageView.isHidden = false
            dateImageView.image = UIImage(named: "text-highlight-yellow")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

