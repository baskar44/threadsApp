//
//  MediaStructureProtocol.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase

protocol MediaStructureProtocol: ObjectStructureProtocol {
    //real one
    var creatorStructure: UserStructureProtocol {get}
    var title: String {get}
    var about: String {get}
}

extension MediaStructureProtocol {
    func createItemValuesAndId(_ type: ItemType, mediaType: MediaType, targetKey: String, message: String, strings: Constants) -> ([String:Any], String) {
      
        var target = strings._emptyString
        
        switch mediaType {
        case .audio:
            target = strings._targetAudio
            break
        case .body:
            target = strings._targetBody
            break
        case .film:
            target = strings._targetVideo
            break
        case .photo:
            target = strings._targetPhoto
            break
        case .thread:
            target = strings._targetThread
            break
        }
        
        let itemPath = getItemPath(type)
        let id = Database.database().reference().child(itemPath).childByAutoId().key
        let createdDate = Date()
        
        let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
        
        let itemValues = [
            strings._createdDate:createdDateString,
            strings._message: message,
            strings._createdBy: creatorStructure.id,
            target: targetKey,
            strings._visibility: visibility] as [String:Any]
        
        return (itemValues, id)
    }
    
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
