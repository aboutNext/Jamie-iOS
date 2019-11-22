//
//  HomeViewController.swift
//  Jamie
//
//  Created by apple on 2019/11/20.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

enum MainTab: Int {
    case home = 0
    case list
    case setting
}

class HomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    //textView
    @IBOutlet weak var highlightTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //evaluableView
    @IBOutlet weak var evaluableView: UIView!
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
    @IBOutlet weak var bottomMenuView: UIView!
    @IBOutlet weak var homeTapButton: UIButton!
    @IBOutlet weak var listTapButton: UIButton!
    @IBOutlet weak var settingTapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    
    }
    
    private func setupUI() {
        evaluableView.isHidden = true
        memoView.isHidden = true
        
//        highlightTextView.becomeFirstResponder()
        highlightTextView.delegate = self
        memoTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tap)
        
        homeTapButton.addTarget(self, action: #selector(bottomMenuTouched(_:)), for: .touchUpInside)
        listTapButton.addTarget(self, action: #selector(bottomMenuTouched(_:)), for: .touchUpInside)
        settingTapButton.addTarget(self, action: #selector(bottomMenuTouched(_:)), for: .touchUpInside)
        
    
        doButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
    }
 
    @objc private func bottomMenuTouched(_ sender: UIButton) {
        print(sender)
        
        let type = sender.tag
        switch MainTab(rawValue: type) {
        case .home:
            break
        case .list:
            let vc = ListViewController.init()
        case .setting:
            break
        case .none:
            break
        }
    }
    
    private func showEvaluableView(isEvaluabled : Bool) {
        if isEvaluabled {
            doButton.isHidden = false
            undoButton.isHidden = false
            return
        }
        doButton.isHidden = true
        undoButton.isHidden = true
    }

    
    @objc func evaluableButtonTouched(_ sender: UIButton) {
           //버튼 선택하면 일단 메모 노출 한다.
           memoView.isHidden = false
           
           if sender === doButton {
               doImageView.isHidden = false
               undoImageView.isHidden = true
               return
           }
           doImageView.isHidden = true
           undoImageView.isHidden = false
       }
    
    private func bottomMenuTap(_ sender: UIButton) {
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension HomeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("시작")
        if textView == highlightTextView {
            evaluableView.isHidden = true
            showEvaluableView(isEvaluabled: false)
            memoView.isHidden = true
        }
        
        if textView == memoTextView {
            memoView.isHidden = false
            
            let height = textView.frame.size.height + evaluableView.frame.size.height
            let offset = CGPoint(x:0, y:height)
            scrollView.setContentOffset(offset, animated: true)
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("끝")

        if textView == highlightTextView {
            evaluableView.isHidden = false
            showEvaluableView(isEvaluabled: true)
        }
        
        if textView == memoTextView {
            let offset = CGPoint(x:0, y:0)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
}
