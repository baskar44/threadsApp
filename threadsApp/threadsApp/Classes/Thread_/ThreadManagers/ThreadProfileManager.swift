//
//  ThreadProfileManager.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 1/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData

struct ThreadProfileManager {
    
    internal enum ThreadAccessLevel {
        case creator
        case full
        case noAccess
        case failed
    }
    
    enum ThreadProfileManagerFeedback {
        case successful
        case failed
    }
    
    private var selectedThreadStructure: ThreadStructureProtocol
    private var employedBy: UserStructureProtocol
    private var strings: Constants
    
    
    init(selectedThreadStructure: ThreadStructureProtocol, employedBy: UserStructureProtocol) {
        self.selectedThreadStructure = selectedThreadStructure
        self.employedBy = employedBy
        strings = Constants.sharedInstance
    }
    
    func getThreadTitle() -> String {
        return selectedThreadStructure.title
    }
    
    func getEmployer() -> UserStructureProtocol {
        return employedBy
    }
    
    func getThreadAbout() -> String {
        return selectedThreadStructure.about
    }

    func getThreadId() -> String {
        return selectedThreadStructure.id
    }
    
    func share(completion: @escaping (ThreadProfileManagerFeedback, Error?) -> Void) {
        
        employedBy.share(mediaStructure: selectedThreadStructure) { (feedback, error) in
            if feedback == .successful {
                completion(.successful, nil)
            }else {
                completion(.failed, error)
            }
        }
    }
    
    func removeShare(completion: @escaping (ThreadProfileManagerFeedback, Error?) -> Void) {
        
        employedBy.removeShare(mediaStructure: selectedThreadStructure) { (feedback, error) in
            if feedback == .successful {
                completion(.successful, nil)
            }else {
                completion(.failed, error)
            }
        }
    }
    
    func bookmark(completion: @escaping (ThreadProfileManagerFeedback, Error?) -> Void) {
        
        employedBy.bookmark(mediaStructure: selectedThreadStructure) { (feedback, error) in
            if feedback == .successful {
                completion(.successful, nil)
            }else {
                completion(.failed, error)
            }
        }
    }
    
    func removeBookmark(completion: @escaping (ThreadProfileManagerFeedback, Error?) -> Void){
        
        employedBy.removeBookmark(mediaStructure: selectedThreadStructure) { (feedback, error) in
            if feedback == .successful {
                
                completion(.successful, nil)
            }else {
                completion(.failed, error)
            }
        }
    }
    
    func getSelectedThread() -> ThreadStructureProtocol {
        return selectedThreadStructure
    }
    
    func getCreatedDateString() -> String {
        let createdDateString = ThreadsData.getCurrentDateString(date: selectedThreadStructure.createdDate)
        return createdDateString
    }
    
    func isCurrentUser() -> Bool {
        if employedBy.id == selectedThreadStructure.creatorStructure.id {
            return true
        }
        
        return false
    }
    
    func getThreadAccessLevel(completion: @escaping (ThreadAccessLevel) -> Void) {
        if employedBy.id == selectedThreadStructure.creatorStructure.id {
            completion(.creator)
            return
        }else {
            //3 check if thread is visibile
            if selectedThreadStructure.visibility {
                completion(.full)
                return
            }else {
                //4 check if following creator
                self.employedBy.checkIfFollowing(userId: selectedThreadStructure.creatorStructure.id, completion: { (isFollowing) in
                    if isFollowing {
                        //4a check if instance is visibile
                        if self.selectedThreadStructure.visibility {
                            completion(.full)
                        }else {
                            completion(.noAccess)
                        }
                    }else {
                        completion(.noAccess)
                    }
                    return
                })
            }
        }
    }
    
    func getShareState(completion: @escaping (UserStructure.ShareState) -> Void){
        employedBy.getShareState(for: selectedThreadStructure) { (shareState) in
            completion(shareState)
            return
        }
    }
    
    func getBookmarkState(completion: @escaping (UserStructure.BookmarkState) -> Void){
        employedBy.getBookmarkState(for: selectedThreadStructure) { (bookmarkState) in
            completion(bookmarkState)
            return
        }
    }
    
    func observe(_ observe: Observe, type: ObserveType, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void) {
        selectedThreadStructure.observe(observe, type: type, context: context) { (feedback, error) in
            completion(feedback, error)
        }
    }
    
    func getFRCForInstanceBody(context: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>? {
        
        var frc: NSFetchedResultsController<NSFetchRequestResult>?
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Body.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
        let decidingPredicate = NSPredicate(format: "parent.id == %@", selectedThreadStructure.id)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = decidingPredicate
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func getFRCForMedia(selectedSegmentIndex: Int, context: NSManagedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>? {
        
        var frc: NSFetchedResultsController<NSFetchRequestResult>?
    
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        let sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
        let decidingPredicate = NSPredicate(format: "parent.id == %@", selectedThreadStructure.id)
        
        switch selectedSegmentIndex {
        case 0: //photos
            fetchRequest = Photo.fetchRequest()
            break
        case 1: //film
            fetchRequest = Film.fetchRequest()
            break
        case 2: //audio
            fetchRequest = Audio.fetchRequest()
            break
        default:
            return frc
        }
        
        guard let request = fetchRequest else {
            return frc
        }
        
        request.sortDescriptors = [sortDescriptor]
        request.predicate = decidingPredicate
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
}

