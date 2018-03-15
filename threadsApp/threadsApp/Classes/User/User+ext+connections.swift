//
//  User+ext+connections.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 10/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase
import CoreData

enum UserArrayType {
    case threads
    case following
    case followers
    case requested
    case pending
    case sharing
    case bookmarked
    case moderating
    case journal
    case draftedPages
}

/*
extension User {
    
    
    func connect(for arrayType: UserArrayType, container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        
        refreshReference(for: arrayType)
        
        switch arrayType {
            
        case .bookmarked:
            //todo
            break
        case .following:
            
            connectFollowingSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            break
        case .followers:
            
            connectFollowersSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            break
            
        case .requested:
            
            connectRequestedSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            break
            
        case .pending:
            connectPendingSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            
            break
        case .threads:
            //todo
            /*
            connectInstancesSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            */
            break
        case .sharing:
            //todo
            
            break
        case .moderating:
            
            connectModeratingSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    
                    
                    
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            
            break
            
        case .journal:
            connectJournalSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    
                    
                    
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            break
            
        case .draftedPages:
            
            connectPagesSection(container: container, completion: { (didConnect, error) in
                if didConnect {
                    completion(true, nil)
                }else {
                    if let error = error {
                        completion(false, error)
                    }else {
                        completion(false, nil)
                    }
                }
            })
            
            break
        default:
            break
            
        }
        
    }
    
    func connectBlockedSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        blockedRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    self.mutableSetValue(forKey: "blocked").add(user)
                    
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                             
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
            })
            
            
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        
        blockedRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    self.mutableSetValue(forKey: "blocked").remove(user)
                    
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
               
            })
            
            
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
    }
    
    
    
    
    private func connectJournalSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        journalRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            Log.get(logId: childKey, container: container, completion: { (log, error) in
                if let log = log {
                    self.mutableSetValue(forKey: "journal").add(log)
                    
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        
        journalRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
 
            
            Log.get(logId: childKey, container: container, completion: { (log, error) in
                if let log = log {
                    
                    self.mutableSetValue(forKey: "journal").remove(log)
                    container.performBackgroundTask({ (context) in
                        
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
    }
    
    private func connectFollowersSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        followersRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
    
            
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                 
                    
                    self.mutableSetValue(forKey: "followers").add(user)
                    
                    container.performBackgroundTask({ (context) in
                        
                        context.perform {
                            do {
                                try context.save()
                             
                                
                            }catch {
                               
                                
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
             
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        
        followersRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
          
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    self.mutableSetValue(forKey: "followers").remove(user)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
           
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        
    }
    
    
    private func connectFollowingSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        
        
        
        followingRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    self.mutableSetValue(forKey: "following").add(user)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                }
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        followingRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    self.mutableSetValue(forKey: "following").remove(user)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                }
            })
            
        }, withCancel: { (error) in
            completion(false, error)
        })
    }
    
    private func connectPendingSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        pendingRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    
                    
                    
                    self.mutableSetValue(forKey: "pending").add(user)
                    
                    container.performBackgroundTask({ (context) in
                        
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        
        pendingRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    self.mutableSetValue(forKey: "Pending").remove(user)
                    
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
    }
    
    private func connectRequestedSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        requestedRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    
                    self.mutableSetValue(forKey: "requested").add(user)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        
        requestedRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            
            User.get(userId: childKey, container: container, completion: { (user, error) in
                if let user = user {
                    
                    self.mutableSetValue(forKey: "requested").remove(user)
                    
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                completion(false, error)
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
    }
    
    private func connectPagesSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        let context = container.viewContext
        
        
        pagesRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key

            
            
            Page.get(pageId: childKey, container: container, completion: { (page, error) in
                
                if let page = page {
                    self.mutableSetValue(forKey: "pages_created").add(page)
               
                    
                    
                    context.perform {
                        do {
                            try context.save()
                            
                            completion(true, nil)
                        }catch {
                            completion(false, error)
                            //later
                            //error
                        }
                    }
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
                
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        pagesRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
  
            
            Page.get(pageId: childKey, container: container, completion: { (page, error) in
                
                if let page = page {
                    self.mutableSetValue(forKey: "pages").remove(page)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                        
                    })
                }
                
                if let error = error {
                    completion(false, error)
                    return
                }
              
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        
    }
    
    
    private func connectInstancesSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        /*
        instancesRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            
            
            Instance.get(instanceId: childKey, container: container, completion: { (instance, error) in
                
                if let instance = instance {
                    
                    
                    self.mutableSetValue(forKey: "instances").add(instance)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                
                                try context.save()
                                
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                    })
                    
                    
                    
                }else {
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
                
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        instancesRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            
            
            Instance.get(instanceId: childKey, container: container, completion: { (instance, error) in
                
                if let instance = instance {
                    self.mutableSetValue(forKey: "instances").remove(instance)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                        
                    })
                }
                
                if let error = error {
                    completion(false, error)
                    return
                }
                
                
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        */
    }
    
    private func connectModeratingSection(container: NSPersistentContainer, completion: @escaping (Bool, Error?) -> Void){
        
        moderatingRef?.observe(.childAdded, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            
            Instance.get(instanceId: childKey, container: container, completion: { (instance, error) in
                
                if let instance = instance {
                    
                    instance.connectModeratorsSection(container: container, completion: { (didConnect, error) in
                        if didConnect {
                            //...maybelater
                        }
                    })
                    
                    
                    
                    self.mutableSetValue(forKey: "moderating").add(instance)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                
                                
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                        
                    })
                    
                    
                    
                    
                }
                
                if let error = error {
                    
                    completion(false, error)
                }
                
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
        moderatingRef?.observe(.childRemoved, with: { (snapshot) in
            
            let childKey = snapshot.key
            
            
            
            Instance.get(instanceId: childKey, container: container, completion: { (instance, error) in
                
                if let instance = instance {
                    self.mutableSetValue(forKey: "moderating").remove(instance)
                    
                    container.performBackgroundTask({ (context) in
                        context.perform {
                            do {
                                try context.save()
                                completion(true, nil)
                            }catch {
                                
                                completion(false, error)
                                //later
                                //error
                            }
                        }
                        
                    })
                    
                }
                
                if let error = error {
                    completion(false, error)
                    
                }
                
                
                
            })
            
        }, withCancel: { (error) in
            //later error
            
            completion(false, error)
        })
        
    }
    
    
    
    
}
*/
