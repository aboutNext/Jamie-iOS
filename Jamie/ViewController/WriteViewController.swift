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

class WriteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var updateDoneButton: UIButton!
    
    var docRef: DatabaseReference!
    var firebaseAPIControllerHandle: FirebaseAPI?
    var contents = [Highlight]()
    var uid: String?
    var isUpdatedMode: Bool = false
    
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
        updateDoneButton.addTarget(self, action: #selector(touchUpDoneButton), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tap)
    }
    
    @objc func touchUpDismissView(_ sender: UIButton) {
        showAlert(style: .alert)
    }
    
    @objc func touchUpDoneButton(_ sender: UIButton) {
        if textView.text == "What is your highlight of the day" {
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
        let alert = UIAlertController(title: "정말 취소할까요?", message: "내용은 저장되지 않습니다", preferredStyle: style)
        let success = UIAlertAction(title: "확인", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alert.addAction(success)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
