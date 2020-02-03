//
//  FirebaseAPI.swift
//  Jamie
//
//  Created by apple on 2019/12/13.
//  Copyright © 2019 yunseo. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CodableFirebase

let db = Firestore.firestore()

//test
var userID: String?
var userInfo: User?
var member: Member?
var documentID: String?


private var documents: [DocumentSnapshot] = []
var contents: [Highlight] = []
private var listener : ListenerRegistration!

private var authListener: AuthStateDidChangeListenerHandle?

class FirebaseAPI {
    
    private func checkUserExistence(completion: (_ userId: String?) -> Void){
        guard let currentUser = Auth.auth().currentUser else {
            //currentUser 없음, 로그인 필요
            completion(nil)
            return
        }
        let userID = currentUser.uid
        completion(userID)
    }
}

//register user, setDatabase
extension FirebaseAPI {
    
    func checkLoginStatus(completion: @escaping(_ isLogin: Bool) -> Void){
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else {
                completion(false)
                return

            }
            if !user.isEmailVerified {
                print("please login or join membership")
                completion(false)

            } else {
                userInfo = user
                completion(true)
            }
        })
    }
    
    func removeCheckingLoginStatus() {
        guard let authListener = authListener else { return }
        Auth.auth().removeStateDidChangeListener(authListener)
    }
    
    //회원 조회
    //TODO: user 문서id는 불필요하여 수정 해야함
    func checkMembership() {
        guard let userInfo = userInfo else { return }
        let uid = userInfo.uid
    db.collection(Constant.firebaseUserCollectionName).whereField("uid", isEqualTo: uid)
        .getDocuments() { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
                return
                
            }
            
            guard let snapshot = querySnapshot else { return }
            let count = snapshot.documents.count
            
            if count == 0 {
                print("no used data, join member")
                self.joinMembership()
                return
            }
            
            if count > 2 {
                print("uid : \(uid), docs is more than 2")
            }
            
            
//            for document in snapshot.documents {
//                documentID = document.documentID
//                print("document.documentID : \(document.documentID) , document.data() :  \(document.data())")
//            }
//
        }
    }
    
    
    //회원가입
    //TODO : 덮어쓰지 않도록 처리
    func joinMembership() {
        guard let userInfo = userInfo else { return }
        let member = Member.init(uid: userInfo.uid, email: userInfo.email ?? "", displayName: userInfo.displayName, providerID: userInfo.providerID, createdDate: Date())

        let encodedUser: [String : Any]  = try! Firestore.Encoder().encode(member)
        
        let myRef = db.collection(Constant.firebaseUserCollectionName)
        let autoId = myRef.document().documentID
        
        myRef.document(autoId).setData(encodedUser)
    }
}


//Create, Read, Update, Delete Highlight
extension FirebaseAPI {
    
    //Create
    func makeNewCollection(collectionName: String, docName: String) -> Bool {
        db.collection(collectionName).document()
        return true
    }
    
    func addNewHighlightAtDocument(collectionName: String, content: String, completion: @escaping(_ result: Bool) -> Void) {
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                completion(false)
                return
            }
            
            let date = Date()
            let hightlight = Highlight.init(uid: userId, createdDate: date, updatedDate: date, targetDate: date, highlight: content, memo: nil, status: "none")
            
            let data = try! FirestoreEncoder().encode(hightlight)
            
            print(data)
            
            db.collection(collectionName).document().setData(data) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    completion(false)
                } else {
                    print("Document successfully written!")
                    completion(true)
                }
            }
        }
    }
    
    func addSnapshotListener(collectionName: String, data: Dictionary <String, AnyObject>) {
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
        db.collection(Constant.firebaseContentsCollectionName).document(userId).addSnapshotListener { snapshot, error in
                if error != nil {
                    
                    return
                }
                
//                if let snapshot = snapshot, let data = snapshot.data(){
//                    for doc in data {
//
//                    }
//                }
            }
        }
    }

    //Delete
    func updateDataAtDocument(collectionName: String) {
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
            db.collection(collectionName).document(userId).setData(["title" : 2021, "memo" : "test", "new" : "value"], merge: true)
            
        }
    }

    
    //Read
    func getDocumentIDs(collectionName: String, completion: @escaping(_ idArr: [String]) -> Void) {
        var documentIdArr = [String]()
        guard let user = userInfo else {
            print("no uid")
            completion(documentIdArr)
            return
        }
        db.collection(collectionName).whereField("uid", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    return
                }
                
                guard let snapshot = querySnapshot else { return }
                if snapshot.documents.count == 0 {
                    print("no documents")
                    return
                }
                
                for document in snapshot.documents {
                    documentIdArr.append(document.documentID)
//                    print("document IDs : \(documentIdArr)")
                }
                completion(documentIdArr)
        }
    }
  
    //TODO : [Highlight]일 때, completion call check 방법
    func getContentsData(completion: @escaping(_ highlightArr: [Highlight]) -> Void) {
        var highlightArr = [Highlight]()
        var total = 0
        self.getDocumentIDs(collectionName: Constant.firebaseContentsCollectionName) { documentIDs in
            for documentID in documentIDs {
                Firestore.firestore().collection(Constant.firebaseContentsCollectionName).document(documentID).getDocument(source: .cache) { document, error in
                    
                    if error != nil {
                        print("getContentsData Error \(String(describing: error))")
                        return
                    }
                    
                    if let document = document, var data = document.data() {
                        let createdDate = data["createdDate"] as! Timestamp
                        let updatedDate = data["updatedDate"] as! Timestamp
                        let targetDate = data["targetDate"] as! Timestamp
                        
                        let createdValue = createdDate.dateValue()
                        let updatedValue = updatedDate.dateValue()
                        let targetValue = targetDate.dateValue()
                        
                        data["createdDate"] = createdValue
                        data["updatedDate"] = updatedValue
                        data["targetDate"] = targetValue
                        
                        let highlight = try! FirestoreDecoder().decode(Highlight.self, from: data)
                        total += 1
                        highlightArr.append(highlight)
                        if total == documentIDs.count {
                            completion(highlightArr)
                        }
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    func getAllDataFromDocuments(collectionName: String) {
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
            
            db.collection(collectionName).document(userId).getDocument { document, error in
                if error != nil {
                    
                    return
                }

                if let doc = document, doc.exists {
                    let documentData = doc.data()
                    
                }
            }
        }
    }
    
    func getAllDocumentsFromCollecton(collectionName: String) {
        db.collection(collectionName).getDocuments { snapshot, error in
            if error != nil {
                
                return
            }
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    
                }
            }
        }
    }
    
    
    func getSubsetOfDocument(collectionName: String, FieldKey: String, target: String) {
        db.collection(collectionName).whereField(FieldKey, isEqualTo: target).getDocuments {  (snapshot, error) in
            if error != nil {
                
                return
            }
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    
                }
            }
        }
    }
    
    //Delete
    func deleteSpecificData(collectionName: String, FieldKey: String) {
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
            
            db.collection(collectionName).document(userId).updateData([FieldKey : FieldValue.delete()]) { error in
                if error != nil {
                    
                    return
                }
                //delete is success!
                
            }
        }
    }
    
    func deleteAllData(collectionName: String) {
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
            db.collection(collectionName).document(userId).delete(completion: { (error) in
                if error != nil {
                    
                } else {
                    //delete is success!
                    
                }
            })
        }
    }
}

//login, logout
extension FirebaseAPI {
    func userLogin() {
        
    }
    
    func userLogout() {
        
    }
    
    //    https://firebase.google.com/docs/auth/ios/manage-users?hl=ko
    func resetPassword() {
        
    }
}


extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

