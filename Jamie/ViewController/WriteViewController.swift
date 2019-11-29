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
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.text = "What is your highlight of the day"
        textView.textColor = UIColor.lightGray
        
        dismissButton.addTarget(self, action: #selector(touchUpDismissView), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tap)
    }
    
    @objc func touchUpDismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension WriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("시작")
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("끝")
        
        if textView.text.isEmpty {
            textView.text = "What is your highlight of the day"
            textView.textColor = UIColor.lightGray
        }
    }
}
