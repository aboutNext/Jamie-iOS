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
    }
    
    private func setupUI() {
        //buttons
        doButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        
        //textView
        highlightTextView.text = Constant.highlightTextViewPlaceHolder
        highlightTextView.textColor = Colors.playholderGray
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedTextView))
        highlightTextView.addGestureRecognizer(tapRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMemoView))
        memoTextView.addGestureRecognizer(tap)
        
        //evaluationView
        showEvaluableViews(isEvaluabled: false)
        
        //memoTextView
        memoTextView.text = Constant.memoTextViewPlaceHolder
        memoTextView.textColor = Colors.playholderGray
    }
    
    @objc func tappedTextView(tapGesture:
        UIGestureRecognizer) {
        showModal(isFeedbackMemo: false)
    }

    @objc func tappedMemoView(tapGesture:
           UIGestureRecognizer) {
           showModal(isFeedbackMemo: true)
       }
    
    func showEvaluableViews(isEvaluabled : Bool) {
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
        guard var newContent = content else {
            return
        }
        
        newContent = data
        content = data
     
        //TODO : date 따로 정리
        guard let date = newContent.targetDate else { return }
        let dateString = chageDateToString(date)
        dateLabel.text = dateString

        setDataToTextView()
        showEvaluableViews(isEvaluabled: true)
        showFeedback()
        
    }
    
    private func showFeedback() {
        guard let data = content, let status = data.status else { return }
        guard let statusType = evaluationState(rawValue: status) else { return }
        switch statusType {
          case .none:
              return
          case .success:
              doImageView.isHidden = false
              undoImageView.isHidden = true
          case .fail:
              doImageView.isHidden = true
              undoImageView.isHidden = false
        }
    }
    
    //TODO: text nil check
    private func setDataToTextView() {
        //date
        guard let newContent = content, let date = newContent.targetDate else { return }
        dateLabel.text = chageDateToString(date)
        
        //textView
        //TODO: text "" 일 경우 처리

        highlightTextView.textColor = UIColor.black
        memoTextView.textColor = UIColor.black
        
        highlightTextView.text = newContent.highlight
        memoTextView.text = newContent.memo
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
            content = data
            return
        }
        evaluationImageView.image = UIImage(named: "character-fail")!
        doImageView.isHidden = true
        undoImageView.isHidden = false
        data.status = evaluationState.fail.rawValue
        content = data
    }
   
    func showModal(isFeedbackMemo: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let writeVC = storyboard.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        writeVC.modalPresentationStyle = .overCurrentContext
        writeVC.delegate = self
        
        guard let data = content else { return }
        writeVC.content = data
        writeVC.isFeedbackMemo = isFeedbackMemo
        present(writeVC, animated: true, completion: nil)
        
    }
}
