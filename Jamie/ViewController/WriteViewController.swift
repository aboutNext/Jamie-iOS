//
//  WriteViewController.swift
//  Jamie
//
//  Created by USER on 2019/11/24.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseFirestore

protocol writeViewControllerDelegate {
    func showWrittenContent(data: Content)

}

class WriteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var updateDoneButton: UIButton!
    
    var docRef: DatabaseReference!
    var firebaseAPIControllerHandle: FirebaseAPI?
    var delegate: writeViewControllerDelegate?
    var content: Content?
    var uid: String?
    var isUpdatedMode: Bool = false
    var isMemoEditing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        dismissButton.addTarget(self, action: #selector(touchUpDismissView), for: .touchUpInside)
        updateDoneButton.addTarget(self, action: #selector(touchUpDoneButton), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tap)
        
        //text view
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.textColor = Colors.playholderGray
        
        guard let data = content else { return }
        if data.highlight == nil {
            //TODO : 1. 메모와 하이라이트 텍스트 문구 다르게 변경 2. 번역어 - What is your highlight of the day
            textView.text = Constant.highlightTextViewPlaceHolder
            return
        }
        
        if isMemoEditing {
            textView.text = data.memo
        } else {
            textView.text = data.highlight
        }
    }
    
    @objc func touchUpDismissView(_ sender: UIButton) {
        showAlert(style: .alert)
    }
    
    @objc func touchUpDoneButton(_ sender: UIButton) {
        
        guard var newContent = content else { return }
        if !isMemoEditing {
            newContent.highlight = textView.text
        } else {
            newContent.memo = textView.text
        }
        
        delegate?.showWrittenContent(data: newContent)
        if textView.text == "오늘 하이라이트 어땠어요?" {
            print("저장할 내용이 없습니다")
            return
        }

        let firebaseHandle = FirebaseAPI()
        //TODO: 저장 시도하는 동안 버튼 비활성화

        //isUpdatedMode
        firebaseHandle.addNewHighlightAtDocument(collectionName: Constant.firebaseContentsCollectionName, content: textView.text) { result in
            if result {
                self.dismissKeyboard()
                self.dismiss(animated: true, completion: nil)

            } else {
                //저장되었다고 토스트로 알리고 닫힘
            }
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(style: UIAlertController.Style) {
        let alert = UIAlertController(title: Constant.writeViewAlertTitle, message: Constant.writeViewAlertMessage, preferredStyle: style)
        let success = UIAlertAction(title: Constant.writeViewConfirm, style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
        let cancel = UIAlertAction(title: Constant.writeViewCancel, style: .default, handler: nil)
        
        alert.addAction(success)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}


extension WriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Colors.playholderGray {
            if textView.text == Constant.highlightTextViewPlaceHolder {
                textView.text = ""
            }
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.highlightTextViewPlaceHolder
            textView.textColor = Colors.playholderGray
        }
    }
}
