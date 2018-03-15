//
//  UserListManager.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation
import CoreData
import Firebase

struct UserListManager {
    
    //has a type - look above
    private var _listType: User.ListType
    var listType: User.ListType {
        return _listType
    }
    
    private var _addReference: DatabaseReference?
    weak var addReference: DatabaseReference? {
        return _addReference
    }
    
    private var _removeReference: DatabaseReference?
    weak var removeReference: DatabaseReference? {
        return _removeReference
    }
    
    //the active user -
    private var _employedBy: UserStructureProtocol
    var employedBy: UserStructureProtocol {
        return _employedBy
    }
    
    //the selectedObject
    private var _selectedUserStructure: UserStructureProtocol
    var selectedUserStructure: UserStructureProtocol {
        return _selectedUserStructure
    }
    
    private weak var _context: NSManagedObjectContext?
    weak var context: NSManagedObjectContext? {
        return _context
    }
    
    init(_ listType: User.ListType, employedBy: UserStructureProtocol, selectedUserStructure: UserStructureProtocol, context: NSManagedObjectContext?) {
        _listType = listType
        _employedBy = employedBy
        _selectedUserStructure = selectedUserStructure
        _context = context
        
        let ref = Database.database().reference()
        let strings = Constants.sharedInstance
        let id = selectedUserStructure.id
        
        switch listType {
        case .bookmarkedAudio:
            let reference = ref.child(strings._BookmarkedAudio).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .bookmarkedBody:
            let reference = ref.child(strings._BookmarkedBodies).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .bookmarkedPhotos:
            let reference = ref.child(strings._BookmarkedPhotos).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .bookmarkedThreads:
            let reference = ref.child(strings._BookmarkedThreads).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .bookmarkedVideo:
            let reference = ref.child(strings._BookmarkedVideos).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .createdAudio:
            let reference = ref.child(strings._CreatedAudio).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .createdBody:
            let reference = ref.child(strings._CreatedBodies).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .createdPhotos:
            let reference = ref.child(strings._CreatedPhotos).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .createdThreads:
            let reference = ref.child(strings._Threads).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .createdVideo:
            let reference = ref.child(strings._CreatedVideos).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .feed:
            let reference = ref.child(strings._Feed).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .followers:
            let reference = ref.child(strings._Followers).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .following:
            let reference = ref.child(strings._Following).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .journal:
            let reference = ref.child(strings._Journal).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .sharedAudio:
            let reference = ref.child(strings._SharedAudio).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .sharedBody:
            let reference = ref.child(strings._SharedBodies).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .sharedVideo:
            let reference = ref.child(strings._SharedVideos).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .sharedPhotos:
            let reference = ref.child(strings._SharedPhotos).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .sharedThreads:
            let reference = ref.child(strings._SharedThreads).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .requested:
            let reference = ref.child(strings._Requested).child(id)
            _addReference = reference
            _removeReference = reference
            break
        case .pending:
            let reference = ref.child(strings._Pending).child(id)
            _addReference = reference
            _removeReference = reference
            break
        }
    }
    
    func observe(action: Action, toFirst: UInt?, completion: @escaping (Feedback, Error?) -> Void) {
        //only looks for items that have been added to firebase. The function can also observe remove, but it is not
        //necessary here.
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        guard let reference = addReference else {
            completion(.failedToGetDatabaseReference, nil)
            return
        }
        
        self.getTotalNumberOfItems(completion: { (itemsCount, error) in
            if let error = error {
                completion(.failedWhileGettingTotalNumberOfObjects, error)
                return
            }else {
                
                let itemsCount = UInt(itemsCount)
                if let toFirst = toFirst {
                    
                    if itemsCount < toFirst {
                        self.selectedUserStructure.observe(self.listType, reference: reference, action: action, toFirst: itemsCount, context: context) { (feedback, error) in
                            completion(feedback, error)
                            return
                        }
                    }else {
                        self.selectedUserStructure.observe(self.listType, reference: reference, action: action, toFirst: toFirst, context: context) { (feedback, error) in
                            completion(feedback, error)
                            return
                        }
                    }
                }else {
                    self.selectedUserStructure.observe(self.listType, reference: reference, action: action, toFirst: itemsCount, context: context) { (feedback, error) in
                        completion(feedback, error)
                        return
                    }
                }
            }
        })
    }

    func getTotalNumberOfItems(completion: @escaping (Int, Error?) -> Void){
        _addReference?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let objectKeys = snapshot.value as? NSDictionary {
                completion(objectKeys.count, nil)
                return
            }
        }, withCancel: { (error) in
            completion(0, error)
            return
        })
    }
    
    func getFRC(selectedSegmentIndex: Int) -> (NSFetchedResultsController<NSFetchRequestResult>?, Feedback) {
        
        guard let context = context else {
            return (nil, .failedWhileGettingContext)
        }
        
        let strings = Constants.sharedInstance
        
        //1) get the associated request
        var request: NSFetchRequest<NSFetchRequestResult>?
        var sortDescriptor: NSSortDescriptor?
        var sectionNameKeyPath: String?
        var decidingPredicate: NSPredicate?
        
        if listType == .feed {
            request = FeedItem.fetchRequest()
            sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
            decidingPredicate = NSPredicate(format: "borrowedBy.id == %@", selectedUserStructure.id)
            
        }else if listType == .followers || listType == .following || listType == .pending || listType == .requested {
            
            request = User.fetchRequest()
            sortDescriptor = NSSortDescriptor(key: strings._username, ascending: true)
            sectionNameKeyPath = #keyPath(User.username)
            
            switch listType {
            case .followers: //user
                decidingPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "ANY following.id == %@", selectedUserStructure.id), NSPredicate(format: "username != nil")])
                
            case .pending: //user
                decidingPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "ANY requested.id == %@", selectedUserStructure.id), NSPredicate(format: "username != nil")])
                
                break
            case .following: //user
                decidingPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "ANY followers.id == %@", selectedUserStructure.id), NSPredicate(format: "username != nil")])
                
                break
            case .requested: //user
                decidingPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "ANY pending.id == %@", selectedUserStructure.id), NSPredicate(format: "username != nil")])
                
                break
            default:
                break
            }
        }else if listType == .createdThreads || listType == .sharedThreads || listType == .bookmarkedThreads {
            request = Thread_.fetchRequest()
            
            if selectedSegmentIndex == 0 || selectedSegmentIndex == -1 {
                sortDescriptor = NSSortDescriptor(key: strings._title, ascending: true)
            }else {
                sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
            }

            sectionNameKeyPath = #keyPath(Thread_.title)
            
            switch listType {
            case .createdThreads:
                decidingPredicate = NSPredicate(format: "creator.id == %@", selectedUserStructure.id)
                break
            case .sharedThreads:
                decidingPredicate = NSPredicate(format: "ANY sharedBy.id == %@", selectedUserStructure.id)
                break
            case .bookmarkedThreads:
                decidingPredicate = NSPredicate(format: "ANY bookmarkedBy.id == %@", selectedUserStructure.id)
                break
            default:
                break
            }
        }else if listType == .createdBody || listType == .sharedBody || listType == .bookmarkedBody {
            request = Body.fetchRequest()
            
            sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
            
            sectionNameKeyPath = #keyPath(Thread_.title)
            
            switch listType {
            case .createdBody:
                decidingPredicate = NSPredicate(format: "creator.id == %@", selectedUserStructure.id)
                break
            case .sharedBody:
                decidingPredicate = NSPredicate(format: "ANY sharedBy.id == %@", selectedUserStructure.id)
                break
            case .bookmarkedBody:
                decidingPredicate = NSPredicate(format: "ANY bookmarkedBy.id == %@", selectedUserStructure.id)
                break
            default:
                break
            }
        }else if listType == .createdPhotos || listType == .sharedPhotos || listType == .bookmarkedPhotos {
            request = Photo.fetchRequest()
            
            sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
            
            switch listType {
            case .createdPhotos:
                decidingPredicate = NSPredicate(format: "creator.id == %@", selectedUserStructure.id)
                break
            case .sharedPhotos:
                decidingPredicate = NSPredicate(format: "ANY sharedBy.id == %@", selectedUserStructure.id)
                break
            case .bookmarkedPhotos:
                decidingPredicate = NSPredicate(format: "ANY bookmarkedBy.id == %@", selectedUserStructure.id)
                break
            default:
                break
            }
        }else if listType == .createdVideo || listType == .sharedVideo || listType == .bookmarkedVideo {
            request = Film.fetchRequest()
            
            sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
            
            switch listType {
            case .createdVideo:
                decidingPredicate = NSPredicate(format: "creator.id == %@", selectedUserStructure.id)
                break
            case .sharedVideo:
                decidingPredicate = NSPredicate(format: "ANY sharedBy.id == %@", selectedUserStructure.id)
                break
            case .bookmarkedVideo:
                decidingPredicate = NSPredicate(format: "ANY bookmarkedBy.id == %@", selectedUserStructure.id)
                break
            default:
                break
            }
        }else if listType == .createdAudio || listType == .sharedAudio || listType == .bookmarkedAudio {
            request = Audio.fetchRequest()
            
            sortDescriptor = NSSortDescriptor(key: strings._createdDate, ascending: true)
            
            switch listType {
            case .createdAudio:
                decidingPredicate = NSPredicate(format: "creator.id == %@", selectedUserStructure.id)
                break
            case .sharedAudio:
                decidingPredicate = NSPredicate(format: "ANY sharedBy.id == %@", selectedUserStructure.id)
                break
            case .bookmarkedAudio:
                decidingPredicate = NSPredicate(format: "ANY bookmarkedBy.id == %@", selectedUserStructure.id)
                break
            default:
                break
            }
        }
      
        if let request = request, let sortDescriptor = sortDescriptor {
            
            if let decidingPredicate = decidingPredicate {
                
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [decidingPredicate])
                request.sortDescriptors = [sortDescriptor]
                request.predicate = predicate
                return (NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil), .successful)
            }
        }
        
        return (nil, .failedWhileGettingFRC)
    }
   
}
