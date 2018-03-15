//
//  Film.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 18/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

struct FilmStructure {
    
}

class Film: MediaChild {
    
    private var coreRef: DatabaseReference?
    //private var moderatorsRef: DatabaseReference?
    
    class func get(filmId: String, context: NSManagedObjectContext, completion: @escaping (Film?, Error?) -> Void) {
        
        let newFilm = Film(context: context)
        
    }
}

