//
//  HomeViewController.swift
//  Jamie
//
//  Created by apple on 2019/11/20.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //textView
    @IBOutlet weak var highlightTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //CheckView
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var mainCharacterView: UIImageView!
    @IBOutlet weak var evaluationImageView: UIImageView!
    @IBOutlet weak var doButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var doImageView: UIImageView!
    @IBOutlet weak var undoImageView: UIImageView!
    
    //MemoView
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoTextView: UITextView!
    
    
    //BottomTapView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        checkView.isHidden = true
        memoView.isHidden = true
        
        highlightTextView.becomeFirstResponder()
        highlightTextView.delegate = self
        memoTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension HomeViewController: UITextViewDelegate {
    
}
