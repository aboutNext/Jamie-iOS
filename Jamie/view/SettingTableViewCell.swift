//
//  SettingTableViewCell.swift
//  Jamie
//
//  Created by apple on 2019/11/21.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }    
}
