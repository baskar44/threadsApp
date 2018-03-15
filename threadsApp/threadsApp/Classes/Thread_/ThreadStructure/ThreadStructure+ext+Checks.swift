//
//  Instance+ext+CreateObject.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 29/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

enum MediaType {
    case body
    case photo
    case film
    case audio
    case thread
}

extension ThreadStructure {
    
    enum MediaChildType {
        case body
        case photo
        case film
        case audio
    }

    func isReadyForRemove(mediaType: MediaChildType, completion: @escaping (Bool) -> Void ) {
        
        var path = Constants.sharedInstance._emptyString
        
        switch mediaType {
        case .audio:
            path = Constants.sharedInstance._Audio
            break
        case .body:
            path = Constants.sharedInstance._Bodies
            break
        case .film:
            path = Constants.sharedInstance._Film
            break
        case .photo:
            path = Constants.sharedInstance._Photo
            break
        }
        
        databaseReference.child(path).child(id).observeSingleEvent(of: .value) { (snapshot) in
            
            if let snapshot = snapshot.value as? NSDictionary {
                if snapshot.allKeys.count > 0 {
                    completion(false)
                    return
                }
            }
            
            completion(true)
            return
        }
    }
}




