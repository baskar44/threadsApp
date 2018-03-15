//
//  User+ext+Modify.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 23/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

extension UserStructure {
    
    //comments
    func updateProfileImage(with image: UIImage, completion: @escaping (Bool, Error?) -> Void){
    
        removeProfileImage { (didRemove, error) in
            if didRemove {
                let imageName = NSUUID().uuidString
                let storage = Storage.storage().reference().child(self.strings._Images).child("\(imageName).jpeg")
                
                if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
                    
                    storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            completion(false, error)
                        }else {
                            self.database.child(self.strings._User).child(self.id).child(self.strings._profileImage).setValue(imageName)
                            completion(true, nil)
                        }
                        
                        return
                        
                    }).resume() //why?
                }
                
            }else {
                if let error = error {
                    completion(false, error)
                }else {
                    completion(false, nil)
                }
                return
            }
        }
    }
    
    //comments
    func removeProfileImage(completion: @escaping (Bool, Error?) -> Void) {
      
        let ref = database.child(strings._User).child(id).child(strings._profileImage)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let profileImageId = snapshot.value as? String {
                
                let storage = Storage.storage().reference().child(self.strings._Images)
                
                storage.child("\(profileImageId).jpeg").delete(completion: { (error) in
                    if let error = error {
                        completion(false, error)
                    }else {
                        ref.removeValue()
                        completion(true, nil)
                    }
                    return
                })
            }else {
                completion(true, nil)
                return
            }
            
        }) { (error) in
            completion(false, error)
            return
        }
    }
    
    //comments
    func edit(editInfo: [String:Any]) -> Bool {
        //username, fullname, bio, visibility
        
        guard let _ = editInfo[strings._username] as? String, let _ = editInfo[strings._fullname] as? String, let _ = editInfo[strings._visibility] as? Bool, let _ = editInfo[strings._bio] as? String else {
            return false
        }
        
        database.child(strings._User).child(id).updateChildValues(editInfo)
        return true
    }
    
    
}
