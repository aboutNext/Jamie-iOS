//
//  HighlightManager.swift
//  Jamie
//
//  Created by yunseo on 2/3/20.
//  Copyright © 2020 yunseo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class HighlightManager {
    static let sharedInstance : HighlightManager = {
        
        let instance = HighlightManager()
        //setup code
    
        return instance
        
    }()
    
    //firebase
    var docRef: DatabaseReference!
    var contents = [Highlight]()
    var isLoggedIn: Bool = false
    
    func showLoginGuide(completion: @escaping(_ isLogin: Bool) -> Void) {
        
        FirebaseAPI.checkLoginStatus { (result) in
            if result {
                //membership 조회 결과
                completion(true)
                return
            } else {
                //membership 없으면 생성
                FirebaseAPI.joinMembership()
                completion(false)
            }
        }
    }
    
    
    func getHighlights(completion: @escaping(_ isFinished: Bool) -> Void){
        let firebaseHandle = FirebaseAPI()
        firebaseHandle.getContentsData { highlights in
            self.contents = highlights
//            print(self.contents)
            completion(true)
        }
    }
    
}
