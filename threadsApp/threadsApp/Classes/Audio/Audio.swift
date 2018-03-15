//
//  Audio.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 18/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//


import CoreData
import Firebase

struct AudioStructure {
    
}

class Audio: MediaChild {
    
    private var coreRef: DatabaseReference?
    //private var moderatorsRef: DatabaseReference?
    
    class func get(audioId: String, context: NSManagedObjectContext, completion: @escaping (Thread_?, Error?) -> Void) {
        
        let newAudio = Audio(context: context)
        
    }
}

