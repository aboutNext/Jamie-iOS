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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leftDateButton: UIButton!
    @IBOutlet weak var rightDateButton: UIButton!
    @IBOutlet weak var topLeftDateButtonImageView: UIImageView!
    @IBOutlet weak var topRightDateButtonImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    //textView
    @IBOutlet weak var highlightTextView: UITextView!

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
    var content: Highlight?
    var isUpdatedMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setup() {
        
        //buttons
        leftDateButton.addTarget(self, action: #selector(changeDate), for: .touchUpInside)
        rightDateButton.addTarget(self, action: #selector(changeDate), for: .touchUpInside)
        doButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(evaluableButtonTouched), for: .touchUpInside)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedTextView))
        highlightTextView.addGestureRecognizer(tapRecognizer)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMemoView))
        memoTextView.addGestureRecognizer(tap)
        
        //evaluationView
        showEvaluableViews(isEvaluabled: isUpdatedMode)
        setDataToViews()
    }
    
    func findTodayData() {
        //TODO: 오늘 날짜 확인해서 없으면 새로 생성하도록 변경
        let manager = HighlightManager.sharedInstance
        highlights = manager.contents
        
        let isHighlightEmpty = highlights.count == 0
        if isHighlightEmpty {
            makeHighlightOfToday()
            return
        }
        guard let lastTargetDate = highlights.first?.targetDate else { return }
        let DoesTodayExist = Calendar.current.isDate(lastTargetDate, inSameDayAs:Date())
        if DoesTodayExist {
            content = highlights.first
        } else {
            makeHighlightOfToday()
        }
        
        showEvaluableViews(isEvaluabled: isUpdatedMode)
        setDataToViews()
    }
    
    private func makeHighlightOfToday() {
        content = Highlight.init(uid: nil, createdDate: Date(), updatedDate: Date(), targetDate: Date(), highlight: nil, memo: nil, status: nil)
    }
    
    @objc func tappedTextView(tapGesture:
        UIGestureRecognizer) {
        showModal(isTitleEditing: true)
    }
    
    @objc func tappedMemoView(tapGesture:
        UIGestureRecognizer) {
        showModal(isTitleEditing: false)
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
    
    func showTopDateView(isUpdatedMode : Bool) {
        if isUpdatedMode {
            leftDateButton.isHidden = true
            rightDateButton.isHidden = true
            topLeftDateButtonImageView.isHidden = true
            topRightDateButtonImageView.isHidden = true
            cancelButton.isHidden = false
            return
        }
        leftDateButton.isHidden = false
        rightDateButton.isHidden = false
        topLeftDateButtonImageView.isHidden = false
        topRightDateButtonImageView.isHidden = false
        cancelButton.isHidden = true
    }
    
    //Delegate
    func showWrittenContent(data: Highlight) {
        content = data
        guard let newContent = content else {
            return
        }
        //TODO : date 따로 정리
        guard let date = newContent.targetDate else { return }
        let dateString = chageDateToString(date)
        dateLabel.text = dateString

        setDataToViews()
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
    private func setDataToViews() {
        //date
        guard let newContent = content, let date = newContent.targetDate else { return }
        dateLabel.text = chageDateToString(date)
        
        //textView
        //TODO: text "" 일 경우 처리
        let isHighlightEmpty = newContent.highlight == Constant.highlightTextViewPlaceHolder
        let isMemoEmpty = newContent.memo == Constant.memoTextViewPlaceHolder

        if !isHighlightEmpty || newContent.highlight != nil {
            highlightTextView.textColor = UIColor.black
            highlightTextView.text = newContent.highlight
        }
        
        if !isMemoEmpty || newContent.memo != nil {
            memoTextView.textColor = UIColor.black
            memoTextView.text = newContent.memo
        }
        
        //TODO: 임시
        if newContent.highlight == nil {
            highlightTextView.text = Constant.highlightTextViewPlaceHolder
            highlightTextView.textColor = Colors.playholderGray
        }
        
        if newContent.memo == nil {
            memoTextView.text = Constant.memoTextViewPlaceHolder
            memoTextView.textColor = Colors.playholderGray
        }
    }
    
    func chageDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        //TODO : 한국에만 아래 해당 (eng: EE - Tue 로)
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        let dateString =  formatter.string(from: date)
        return dateString
    }
    
    @objc func changeDate(_ sender: UIButton) {
        if sender === leftDateButton {
            
            return
        }
        
    }
    
    @objc func evaluableButtonTouched(_ sender: UIButton) {
        guard var data = content else { return }
        let firebaseHandle = FirebaseAPI()
        var isFeedbackSuccessful: Bool
        
        if sender === doButton {
            evaluationImageView.image = UIImage(named: "character-done")!
            doImageView.isHidden = false
            undoImageView.isHidden = true
            data.status = evaluationState.success.rawValue
            isFeedbackSuccessful = true
        } else {
            evaluationImageView.image = UIImage(named: "character-fail")!
            doImageView.isHidden = true
            undoImageView.isHidden = false
            data.status = evaluationState.fail.rawValue
            isFeedbackSuccessful = false
        }
        content = data

        //firebase update
        firebaseHandle.updateFeedback(collectionName: Constant.firebaseContentsCollectionName, content: data, isFeedbackSuccessful: isFeedbackSuccessful) { result in
            print(result)
//
        }
    }
   
    func showModal(isTitleEditing: Bool) {
        let manager = HighlightManager.sharedInstance
        let isLoggedIn = manager.isLoggedIn
        if isLoggedIn {
            let writeVC = self.switchToWritePage(isTitleEditing)
            self.present(writeVC, animated: true, completion: nil)

        } else {
            //로그인 화면 연결 후 글 작성 가능
            let vc = self.switchToLoginPage()
            self.present(vc, animated: true, completion: {
                let writeVC = self.switchToWritePage(isTitleEditing)
                self.present(writeVC, animated: true, completion: nil)
            })
        }
    }
    
    private func switchToLoginPage() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        return controller
    }
    
    private func switchToWritePage(_ isTitleEditing: Bool) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let writeVC = storyboard.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        writeVC.modalPresentationStyle = .overCurrentContext
        writeVC.delegate = self
        writeVC.isTitleEditing = isTitleEditing

        if let data = content {
            writeVC.content = data
        }
        return writeVC
    }
}
