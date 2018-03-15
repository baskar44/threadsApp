//
//  Object.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 30/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase


protocol ObjectStructure {
    
    var id: String {get}
    var createdDate: Date {get}
    var createdDateString: String {get}
    var visibility: Bool {get}
    
 
   
}



extension ObjectStructureProtocol {
   
    /*
    func getLogRelatedItemValuesAndId(_ action: LogAction, objectType: ObjectType) -> [String: ([String:Any], String)]{
        //will return journal and feed (if feed is applicable)
        //this will be called when:
        
        //1 body is updated by bodystructure - update = body and update
        //2 body is removed by threadstructure - remove = body and remove
        //3 body is added by threadstructure - add = body and add
        
        //4 photo is updated by photostructure - update
        //5 photo is removed by threadstructure - remove
        //6 photo is added by threadstructure - add
        
        //7 thread is updated by threadstructure - update
        //8 thread is removed by userstructure - remove
        //9 thread is added by userstructure - add
        
        //user related
        //10 user is updated by userstructure - update
        
        //11 user shares a media item - thread/body/photo/video/audio - share
        //12 user bookmarks a media item - thread/body/photo/video/audio - bookmark
        
        //13 user A follows user B - follow
        //14 user A requests user B - request
    }
    */
   
    
    func getItemPath(_ type: ItemType) -> String {
        var path = Constants.sharedInstance._emptyString
        
        if type == .feed {
            path = Constants.sharedInstance._FeedItem
        }else if type == .journal {
            path = Constants.sharedInstance._JournalItem
        }
        
        return path
    }
    
    func getListPath(_ type: ItemType) -> String {
        var path = Constants.sharedInstance._emptyString
        
        if type == .feed {
            path = Constants.sharedInstance._Feed
        }else if type == .journal {
            path = Constants.sharedInstance._Journal
        }
        
        return path
    }
}

class Object: NSManagedObject {
    
    var coreReference: DatabaseReference?
    
    let database = Database.database().reference()
    let s_ = Constants.sharedInstance
    
    func saveToContext(context:NSManagedObjectContext, onCompletion: @escaping (Bool, Error?) -> Void){
       
        context.perform {
            do {
                try context.save()
                onCompletion(true, nil)
                return
            }catch {
                onCompletion(false, error)
                return
            }
        }
    }
}
