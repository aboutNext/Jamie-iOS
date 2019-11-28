//
//  WriteViewController.swift
//  Jamie
//
//  Created by USER on 2019/11/24.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

class WriteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        //text view
        textView.textContainerInset = UIEdgeInsets(top: 00, left: 20, bottom: 0, right: 20)
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.textColor = UIColor.black
        
        
        dismissButton.addTarget(self, action: #selector(touchUpDismissView), for: .touchUpInside)
    }
    

    
    @objc func touchUpDismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
