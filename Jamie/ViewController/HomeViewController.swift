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

class HomeViewController: UIViewController, writeViewControllerDelegate {

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
    
    var highlights = [Highlight]()
    var content: Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: 오늘 날짜 확인해서 없으면 새로 생성하도록 변경
        content = Content.init(targetDate: Date(), highlight: nil, memo: nil, status: nil)
        setupUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataToTextView()
    }
    
    private func setupUI() {
        //buttons
        doButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        
        //textView
        highlightTextView.text = "What is your highlight of the day"
        highlightTextView.textColor = UIColor.lightGray
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedTextView))
        highlightTextView.addGestureRecognizer(tapRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMemoView))
        memoTextView.addGestureRecognizer(tap)
        
        //evaluationView
        showEvaluableView(isEvaluabled: false)
        
 
    }
    
    @objc func tappedTextView(tapGesture:
        UIGestureRecognizer) {
        showModal(isFeedbackMemo: false)
    }

    @objc func tappedMemoView(tapGesture:
           UIGestureRecognizer) {
           showModal(isFeedbackMemo: true)
       }
    
    func showEvaluableView(isEvaluabled : Bool) {
        if isEvaluabled {
            mainCharacterView.isHidden = true
            evaluationImageView.isHidden = false
            doButton.isHidden = false
            doImageView.isHidden = true
            undoButton.isHidden = false
            undoImageView.isHidden = true
            return
        }
        mainCharacterView.isHidden = false
        evaluationImageView.isHidden = true
        doButton.isHidden = true
        doImageView.isHidden = true
        undoButton.isHidden = true
        undoImageView.isHidden = true
    }
    
    //Delegate
    func showWrittenContent(data: Content) {
//        guard let newData = data else {
//            showEvaluableView(isEvaluabled: false)
//            return
//        }
        guard var newContent = content else {
            return
        }
        
        newContent = data

        showEvaluableView(isEvaluabled: true)
        highlightTextView.text = newContent.highlight
        memoTextView.text = newContent.memo
        
        //TODO : date 따로 정리
        guard let date = newContent.targetDate else { return }
        let dateString = chageDateToString(date)
        dateLabel.text = dateString

        if newContent.status != "none" {

        }
    }
    
    //TODO: text nil check
    private func setDataToTextView() {
        
        //date
        guard let newContent = content, let date = newContent.targetDate else { return }
        dateLabel.text = chageDateToString(date)
        
        //textView
        highlightTextView.text = newContent.highlight
        memoTextView.text = newContent.memo
    }
    
    
    private func showFeedBack(isSuccess: Bool) {
        if isSuccess {
            
        }
    }
    
    func chageDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        //TODO : 한국에만 아래 해당 (eng: EE - Tue 로)
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "MM DD EEEE"
        let dateString =  formatter.string(from: date)
        return dateString
    }
    
    @objc func evaluableButtonTouched(_ sender: UIButton) {
        guard var data = content else { return }
        
        if sender === doButton {
            evaluationImageView.image = UIImage(named: "character-done")!
            doImageView.isHidden = false
            undoImageView.isHidden = true
            data.status = evaluationState.success.rawValue
            return
        }
        evaluationImageView.image = UIImage(named: "character-fail")!
        doImageView.isHidden = true
        undoImageView.isHidden = false
        data.status = evaluationState.fail.rawValue
    }
   
    func showModal(isFeedbackMemo: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let writeVC = storyboard.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        writeVC.modalPresentationStyle = .overCurrentContext
        writeVC.delegate = self
        
        guard let data = content else { return }
        writeVC.content = content
        writeVC.isFeedbackMemo = isFeedbackMemo
        present(writeVC, animated: true, completion: nil)
        
    }
}
