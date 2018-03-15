//
//  User+ext+Object_Relationships.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 23/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

extension UserStructure {

    enum ShareState: String {
        case share = "Share"
        case shared = "Shared"
        case failed = "Failed"
    }
    
    enum BookmarkState: String {
        case bookmark = "Bookmark"
        case bookmarked = "Bookmarked"
        case failed = "Failed"
    }
    
    //comments
    func getShareState(for mediaStructure: MediaStructureProtocol, completion: @escaping (UserStructure.ShareState) -> Void) {
        
        var path: String?
        
        if mediaStructure is ThreadStructure {
            path = strings._SharedThreads
        }else if mediaStructure is BodyStructure {
            path = strings._SharedBodies
        }else if mediaStructure is PhotoStructure {
            path = strings._SharedPhotos
        }else if mediaStructure is FilmStructure {
            path = strings._SharedVideos
        }else if mediaStructure is AudioStructure {
            path = strings._SharedAudio
        }
        
        guard let pathString = path else {
            completion(.failed)
            return
        }
        
        var count = 0
         Database.database().reference().child(pathString).child(id).child(mediaStructure.id).observeSingleEvent(of: .value) { (snapshot) in
            
            count = count + 1
            
            if count > 0 && count < 2 {
                
                if let _ = snapshot.value as? Bool {
                    //sharing
                    completion(.shared)
                }else {
                    completion(.share)
                }
            }
            
            return
        }
    }
    
    //comments
    func getBookmarkState(for mediaStructure: MediaStructureProtocol, completion: @escaping (UserStructure.BookmarkState) -> Void){
        
        var path: String?
        
        if mediaStructure is ThreadStructure {
            path = strings._BookmarkedThreads
        }else if mediaStructure is BodyStructure {
            path = strings._BookmarkedBodies
        }else if mediaStructure is PhotoStructure {
            path = strings._BookmarkedPhotos
        }else if mediaStructure is FilmStructure {
            path = strings._BookmarkedVideos
        }else if mediaStructure is AudioStructure {
            path = strings._BookmarkedAudio
        }
        
        guard let pathString = path else {
            completion(.failed)
            return
        }
        
        database.child(pathString).child(id).child(mediaStructure.id).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? Bool {
                //bookmared
                completion(.bookmarked)
            }else {
                //no bookmarked
                completion(.bookmark)
            }
            return
        }
    }
    
    //comments
    func bookmark(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileSavingToContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.bookmark, object: mediaStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                var path: String?
                
                if mediaStructure is ThreadStructure {
                    path = self.strings._BookmarkedThreads
                }else if mediaStructure is BodyStructure {
                    path = self.strings._BookmarkedBodies
                }else if mediaStructure is PhotoStructure {
                    path = self.strings._BookmarkedPhotos
                }else if mediaStructure is FilmStructure {
                    path = self.strings._BookmarkedVideos
                }else if mediaStructure is AudioStructure {
                    path = self.strings._BookmarkedAudio
                }
                
                guard let pathString = path else {
                    completion(.failedWithChangingBookmarkState, error)
                    return
                }
                
                self.database.child(pathString).child(self.id).child(mediaStructure.id).setValue(true)
                
                completion(.successful, nil)
            }else {
                completion(.failedWithChangingBookmarkState, error)
                return
            }
        }
    }
    
    //comments
    func removeBookmark(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.removeBookmark, object: mediaStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                var path: String?
                
                if mediaStructure is ThreadStructure {
                    path = self.strings._BookmarkedThreads
                }else if mediaStructure is BodyStructure {
                    path = self.strings._BookmarkedBodies
                }else if mediaStructure is PhotoStructure {
                    path = self.strings._BookmarkedPhotos
                }else if mediaStructure is FilmStructure {
                    path = self.strings._BookmarkedVideos
                }else if mediaStructure is AudioStructure {
                    path = self.strings._BookmarkedAudio
                }
                
                guard let pathString = path else {
                    completion(.failedWithChangingBookmarkState, error)
                    return
                }
                
                self.database.child(pathString).child(self.id).child(mediaStructure.id).removeValue()
                
                completion(.successful, nil)
                return
            }else {
                completion(.failedWithChangingBookmarkState, error)
                return
            }
        }
    }
    
    //comments
    func share(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
       
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
       
        let dictionary = getLogRelatedItemValuesAndId(.share, object: mediaStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem], let feedItemValues = dictionary[strings._FeedItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                self.performUpdate(itemValuesAndId: feedItemValues, type: .feed, context: context, completion: { (feedback, error) in
                    
                    if feedback == .successful {
                        var path: String?
                        
                        if mediaStructure is ThreadStructure {
                            path = self.strings._SharedThreads
                        }else if mediaStructure is BodyStructure {
                            path = self.strings._SharedBodies
                        }else if mediaStructure is PhotoStructure {
                            path = self.strings._SharedPhotos
                        }else if mediaStructure is FilmStructure {
                            path = self.strings._SharedVideos
                        }else if mediaStructure is AudioStructure {
                            path = self.strings._SharedAudio
                        }
                        
                        guard let pathString = path else {
                            completion(.failedWithChangingShareState, nil)
                            return
                        }
                        
                        self.database.child(pathString).child(self.id).child(mediaStructure.id).setValue(true)
                        
                        completion(.successful, nil)
                    }else {
                        completion(.failedWithChangingShareState, error)
                    }
                    return
                })
            }else {
                completion(.failedWithChangingShareState, error)
                return
            }
        }

        
    }
    
    
    //comments
    func removeShare(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void){
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.removeShare, object: mediaStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                var path: String?
                
                if mediaStructure is ThreadStructure {
                    path = self.strings._SharedThreads
                }else if mediaStructure is BodyStructure {
                    path = self.strings._SharedBodies
                }else if mediaStructure is PhotoStructure {
                    path = self.strings._SharedPhotos
                }else if mediaStructure is FilmStructure {
                    path = self.strings._SharedVideos
                }else if mediaStructure is AudioStructure {
                    path = self.strings._SharedAudio
                }
                
                guard let pathString = path else {
                    completion(.failedWithChangingShareState, nil)
                    return
                }
                
                self.database.child(pathString).child(self.id).child(mediaStructure.id).removeValue()
                completion(.successful, nil)
            }else {
                completion(.failedWithChangingShareState, error)
                return
            }
        }
    }
}
