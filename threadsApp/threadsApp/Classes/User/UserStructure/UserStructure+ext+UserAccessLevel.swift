//
//  UserStructure+ext+UserAccessLevel.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 2/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase

//User Access Level
extension UserStructure {
    
    enum FollowState: String {
        case current = "Current"
        case following = "Following"
        case pending = "Pending"
        case requested = "Requested"
        case follow = "Follow"
        case internalError = "Internal Error"
    }
    
    func checkIfFollowing(userId: String, completion: @escaping (Bool) -> Void) {
         ThreadsData.sharedInstance.dbRef.child(Constants.sharedInstance._Following).child(id).child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? Bool {
                completion(true)
            }else {
                completion(false)
            }
            return
        }
    }
    
    func checkIfPending(userId: String, completion: @escaping (Bool) -> Void){
        ThreadsData.sharedInstance.dbRef.child(Constants.sharedInstance._Pending).child(id).child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? Bool {
                completion(true)
            }else {
                completion(false)
            }
            return
        }
        
    }
    
    func checkIfRequested(userId: String, completion: @escaping (Bool) -> Void){
        ThreadsData.sharedInstance.dbRef.child(Constants.sharedInstance._Requested).child(id).child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? Bool {
                completion(true)
            }else {
                completion(false)
            }
            return
        }
        
    }
}
