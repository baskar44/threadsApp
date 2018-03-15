//
//  ClearAssistant.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData

struct MockClearAssistant: ClearAssistantProtocol {
    
    private var _expectedFeedback: ClearAssistantFeedback
    var expectedFeedback: ClearAssistantFeedback {
        return _expectedFeedback
    }

    init(expectedFeedback: ClearAssistantFeedback) {
        _expectedFeedback = expectedFeedback
    }
    
    func clear(completion: @escaping (ClearAssistantFeedback) -> Void) {
        completion(expectedFeedback)
    }
}

struct MockError: Error {
    
}

protocol ClearAssistantProtocol {
    func clear(completion: @escaping (ClearAssistantFeedback) -> Void)
}

enum ClearAssistantFeedback: String {
    case failedToGetContainer = "Failed to get container (Core Data)."
    case failedToMatchRequestWithObject = "Failed to match request and object type."
    case clearCompleted = "Clear completed"
    case contextFailedToComplete = "Context failed to complete"
    case contextFetchFailed = "Context fetch of all Object(s) failed"
    case contextSaveFailed = "Context save failed."
    case clearedCounterFailed = "Cleared counter failed"
}

struct ClearAssistant: ClearAssistantProtocol {
    
    
    //The clear assistant is in charge of clearing all data in the core data container.
    //It will initialise with 'objectTypes', which is an array of Enum of type: [ObjectType]
    //Once the func clear() is called, all the object types stated during initialising will have all of its data removed from the core data container.
    
    private var _objectTypes: [ObjectType]
    var objectTypes: [ObjectType] {
        return _objectTypes
    }
    
    private var _container: NSPersistentContainer?
    var container: NSPersistentContainer? {
        return _container
    }
    
    init(objectTypes: [ObjectType], container: NSPersistentContainer?) {
        _objectTypes = objectTypes
        _container = container
    }
    
    //Need to test...
    func clear(completion: @escaping (ClearAssistantFeedback) -> Void){
        guard let context = container?.viewContext else {
            //error handle- failed to get container (Core Data).
            completion(.failedToGetContainer)
            return
        }
        
        handleClear(context: context) { (feedback) in
            completion(feedback)
            return
        }
    }
    
    //Need to test...
    private func getFetchRequest(for objectType: ObjectType) -> NSFetchRequest<NSFetchRequestResult>? {
        
        var request: NSFetchRequest<NSFetchRequestResult>?
        
        switch objectType {
        case .audio:
            request = Audio.fetchRequest()
            break
            
        case .video:
            request = Film.fetchRequest()
            break
            
        case .photo:
            request = Photo.fetchRequest()
            break
            
        case .thread:
            request = Thread_.fetchRequest()
            break
            
        case .user:
            request = User.fetchRequest()
            break
        case .body:
            request = Body.fetchRequest()
            break
        case .feedItem:
            request = FeedItem.fetchRequest()
            break
        case .journalItem:
            request = Journal.fetchRequest()
            break
        }
        
        return request
    }
    
    //Need to test...
    private func handleClear(context: NSManagedObjectContext, completion: @escaping (ClearAssistantFeedback) -> Void){

        var cleared = 0
        
        for objectType in objectTypes {
            guard let request: NSFetchRequest<NSFetchRequestResult> = getFetchRequest(for: objectType) else {
                completion(.failedToMatchRequestWithObject)
                return
            }
            
            do {
                let matches = try context.fetch(request)
                
                for match in matches {
                    if let match = match as? NSManagedObject {
                        context.delete(match)
                    }
                }
                
                context.perform {
                    do {
                        try context.save()
                        
                        if self.objectTypes.first == objectType {
                            if cleared != 0 {
                                completion(.clearedCounterFailed)
                                return
                            }
                        }
                        
                        cleared = cleared + 1
                        
                        if cleared == self.objectTypes.count {
                            //error handle- clear completed
                            completion(.clearCompleted)
                            return
                        }
                    }catch {
                        //error handle- context failed to complete
                        completion(.contextSaveFailed)
                        return
                    }
                }
                
            }catch {
                //error handle- context fetch of all Object(s) failed
                completion(.contextFetchFailed)
                return
            }
        }
    }
    
}
