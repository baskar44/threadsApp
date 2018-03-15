//
//  ThreadsData+ext+Welcome.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 21/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

extension ThreadsData {

    func login(email: String, password: String, on completion: @escaping (Bool, Error?, String?) -> Void){
        
        var message:String?
        
        if email != "" && password != "" {
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    //... user exists...
                    completion(true, nil, message)
                }else {
                    message = "Invalid username or wrong password."
                    completion(false, error, message)
                }
            }
            
        }else {
            message = "Not all required fields are filled in."
            completion(false, nil, message)
        }
    }
    
    func signOut(on completion: @escaping (Bool, Error?) -> Void){
        do {
            try Auth.auth().signOut()
            completion(true, nil)
            return
        }catch {
            completion(false, nil)
            return
        }
    }
    
    func register(email: String, password: String, username: String, on completion: @escaping (Bool, Error?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                completion(true, error)
                return
            }else {
                if let user = user {
           
                    let date = Date()
                    
                    let createdDate = ThreadsData.getCurrentDateString(date: date)
                    
                    let childValues = [
                        self.strings._createdDate: createdDate,
                        self.strings._visibility:true,
                        self.strings._username:username
                        ] as [String:Any]
                     Database.database().reference().child(self.strings._User).child(user.uid).updateChildValues(childValues)
                    
                    completion(true, nil)
                    return
                }
            }
        })
    }
}
