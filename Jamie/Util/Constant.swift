//
//  UIConstant.swift
//  Jamie
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

class Constant: NSObject {

    //homeViewController
    
    
    //firebaseAPI
    static let firebaseContentsCollectionName: String = "contents"
    static let firebaseUserCollectionName: String = "users"

    //HomeViewController
    static let highlightTextViewPlaceHolder: String = "오늘의 하이라이트는 무엇인가요?"
    static let memoTextViewPlaceHolder: String = "오늘 하이라이트 어땠어요?"

    //SettingViewController
    static let settingViewHeightForHeader: CGFloat = 46.0
    
    //ListViewController
    static let listViewHeightForHeader: CGFloat = 97.0

    //WriteViewController
    static let writeViewAlertTitle: String = "정말 취소할까요?"
    static let writeViewAlertMessage: String = "오늘 하이라이트 어땠어요?"
    static let writeViewConfirm: String = "확인"
    static let writeViewCancel: String = "취소"

    
}
