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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tap)
        
        doButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        
        //textView
        highlightTextView.text = "What is your highlight of the day"
        highlightTextView.textColor = UIColor.lightGray
        
        //evaluationView
        showEvaluableView(isEvaluabled: true)
    }
    
    private func showEvaluableView(isEvaluabled : Bool) {
        if isEvaluabled {
            mainCharacterView.isHidden = true
            doButton.isHidden = false
            undoButton.isHidden = false
            return
        }
        mainCharacterView.isHidden = false
        doButton.isHidden = true
        undoButton.isHidden = true
    }
    
    
    @objc func evaluableButtonTouched(_ sender: UIButton) {
        if sender === doButton {
            evaluationImageView.image = UIImage(named: "character-done")!
            doImageView.isHidden = false
            undoImageView.isHidden = true
            return
        }
        evaluationImageView.image = UIImage(named: "character-fail")!
        doImageView.isHidden = true
        undoImageView.isHidden = false
    }
    
    private func bottomMenuTap(_ sender: UIButton) {
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let writeVC = storyboard.instantiateViewController(withIdentifier: "WriteViewController")
        
        writeVC.modalPresentationStyle = .overCurrentContext
        present(writeVC, animated: true, completion: nil)
        
        
    }
}

extension HomeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("시작")
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
        if textView == highlightTextView {
            showModal()
            
            //            evaluableView.isHidden = true
            //            showEvaluableView(isEvaluabled: false)
            //            memoView.isHidden = true
        }
        
        if textView == memoTextView {
            let height = textView.frame.size.height + evaluableView.frame.size.height
            let offset = CGPoint(x:0, y:height)
            scrollView.setContentOffset(offset, animated: true)
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("끝")
        
        if textView.text.isEmpty {
            textView.text = "What is your highlight of the day"
            textView.textColor = UIColor.lightGray
        }
        
        if textView == memoTextView {
            let offset = CGPoint(x:0, y:0)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //
    //        return false
    //    }
}
