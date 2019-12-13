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

let db = Firestore.firestore()
var userID: String?

class FirebaseAPI {

    //update 시에 document id("special-Doc")가 같으면 됨
//    let userId = Auth.auth().currentUser?.uid
    
    func setDatabase() {
        let user: User = User(name: "jasmine")
        
        let encodedUser: [String : Any]  = try! Firestore.Encoder().encode(user)
        
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
            
            db.collection("highlight").document("hoge").setData(encodedUser)
        }
    }
    
    func getDatabase() {
        let docRef: DocumentReference = db.collection("highlight").document("hoge")
        docRef.getDocument { (document, _) in
            if let document = document, document.exists {
                let user = try? Firestore.Decoder().decode(User.self, from: document.data()!)
                
            } else {
                print("Document does not exist")
            }
        }
    }
}


private func checkUserExistence(completion: (_ userId: String?) -> Void){
    guard let currentUser = Auth.auth().currentUser else {
        //currentUser 없음, 로그인 필요
        completion(nil)
        return
    }
    let userID = currentUser.uid
    completion(userID)
}


//Create, Read, Update, Delete,
extension FirebaseAPI {
    
    //Create
    func makeNewCollection(collectionName: String, docName: String) -> Bool {
        db.collection(collectionName).document()
        return true
    }
    
    func addDataAtDocument(collectionName: String, data: Dictionary <String, AnyObject>) {
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
            //            db.collection(collectionName).document(userId).setData(data)
            db.collection(collectionName).document(userId).setData(["title" : 2020, "memo" : "test", "new" : "value"])
        }
    }
    
    func addSnapshotListener(collectionName: String, data: Dictionary <String, AnyObject>) {
        
        checkUserExistence { userId in
            guard let userId = userId else {
                print("no userId")
                return
            }
            db.collection("highlight").document(userId).addSnapshotListener { snapshot, error in
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
                print(document?.data())
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
    
    func getUserData() {
        
    }
}
