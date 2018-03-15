//
//  User+ext+setup+e.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 10/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

enum UserActionType {
    case draft
    case remove
}

/*
extension User {
    
    func action(type: UserActionType, instanceMedia: InstanceMedia, mediaInfo: [String:Any?]){
        
        if let createdBy = id, let mediaId = mediaInfo["id"] as? String, let title = mediaInfo["title"] as? String {
            
            var createdDate: String?
            
            if let _createdDate = mediaInfo["createdDate"] as? String {
                createdDate = _createdDate
            }else {
                let date = Date()
                createdDate = ThreadsData.getCurrentDateString(date: date)
            }
            
            if let createdDate = createdDate {
                
                let pathString = "Created\(instanceMedia.rawValue)s"
                switch type {
               
                case .draft:
                    let text = mediaInfo["text"] as? String ?? ""
            
                    let values = ["createdDate":createdDate,
                                  "createdBy":createdBy,
                                  "title":title,
                                  "text":text,
                                  "draftMode":true,
                                  "visibility":false] as [String:Any]
                    
                    //adding data to drafted
                    database.child(pathString).child(createdBy).child(mediaId).setValue(true)
                    //adding data to media item (i.e. page/image/video/audio)
                    database.child(instanceMedia.rawValue).child(mediaId).updateChildValues(values)
                    
                    //adding data to log
                    
                    //user just drafted a media item
                    let logText = "Saved '\(title)' as a draft."
                    log(text: logText, logInside: [.journal])
                    
                    break
                    
                case .remove:
                    database.child(pathString).child(createdBy).child(mediaId).removeValue()
                    database.child(instanceMedia.rawValue).child(mediaId).removeValue()
                    
                    let logText = "Removed '\(title)'."
                    log(text: logText, logInside: [.journal])
                    
                    break
                }
            }
        }else {
            
        }
    }
    
    enum LogInside {
        case journal
        case feed
    }
    
    private func log(text: String, imageURL: String? = nil, logInside: [LogInside]){
        
        let date = Date()
        let createdDate = ThreadsData.getCurrentDateString(date: date)
        
        if let currentUserId = id {
            let logValues = ["createdDate":createdDate,
                             "createdBy":currentUserId,
                             "text":text,
                             "visibility":true] as [String:Any]
            
            let logId = database.child("Log").childByAutoId().key
            //added to log and journal
            
            database.child("Log").child(logId).setValue(logValues)
            
            for inside in logInside {
                switch inside {
                case .feed:
                    //feed of all followers and current user
                    database.child("Followers").child(currentUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let followers = snapshot.value as? NSDictionary {
                            for followerKey in followers.allKeys {
                                if let followerKey = followerKey as? String {
                                    self.database.child("Feed").child(followerKey).child(logId).setValue(true)
                                }
                            }
                        }
                    })
                    break
                    
                case .journal:
                    database.child("Journal").child(currentUserId).child(logId).setValue(true)
                    break
                }
            }
            
            
        }
    }
    
    func follow(selected user: User) -> Bool {
        if let selectedUserId = user.id, let currentUserId = id, let currentUser_username = username, let selectedUser_username = user.username {
            
            //1) check if selected user is visibile
            if user.visibility {
                
                //2) if visibile
                //add currentUserId in selectedUser's followers list
                database.child("Followers").child(selectedUserId).child(currentUserId).setValue(true)
                //add selectedUserId in currentUser's following list
                database.child("Following").child(currentUserId).child(selectedUserId).setValue(true)
                //logging it
                let text = "\(currentUser_username) started following \(selectedUser_username)"
                log(text: text, logInside: [.journal])
                user.log(text: text, logInside: [.journal])
        
            }else {
                //add currentUserId in selectedUser's requested list
                database.child("Requested").child(currentUserId).child(selectedUserId).setValue(true)
                //add selectedUserId in currentUser's pending list
                database.child("Pending").child(selectedUserId).child(currentUserId).setValue(true)
                
                //logging it
                let text = "\(currentUser_username) requested to follow \(selectedUser_username)"
                log(text: text, logInside: [.journal])
                user.log(text: text, logInside: [.journal])
            }
            return true
        }else {
            return false
        }
    }
    
    func unfollow(selected user: User) -> Bool {
        
        if let selectedUserId = user.id, let currentUserId = id, let selectedUser_username = user.username {
            //remove currentUserId from selectedUser's followers list
            database.child("Followers").child(selectedUserId).child(currentUserId).removeValue()
            
            //remove selectedUserId from currentUser's following list
            database.child("Following").child(currentUserId).child(selectedUserId).removeValue()
            
            //logging it
            let text = "You removed \(selectedUser_username) from followers list."
            log(text: text, logInside: [.journal])
            
            return true
        }else {
            return false
        }
        
    }
    
    func cancelRequest(selected user: User) -> Bool {
        
        if let selectedUserId = user.id, let currentUserId = id, let selectedUser_username = user.username {
            //remove currentUserId from selectedUser's Pending list
            database.child("Pending").child(selectedUserId).child(currentUserId).removeValue()
            
            //remove selectedUserId from currentUser's Requested list
            database.child("Requested").child(currentUserId).child(selectedUserId).removeValue()
            
            //logging it
            let text = "You removed \(selectedUser_username) from requested list."
            log(text: text, logInside: [.journal])
            
            return true
        }else {
            return false
        }
    }
    
    func cancelPending(selected user: User) -> Bool{
        
        if let selectedUserId = user.id, let currentUserId = id, let selectedUser_username = user.username {
            //remove selectedUser from currentUser's Requested list
            database.child("Pending").child(currentUserId).child(selectedUserId).removeValue()
            
            //remove selectedUserId from currentUser's Pending list
            database.child("Requested").child(selectedUserId).child(currentUserId).removeValue()
            
            //logging it
            let text = "You removed \(selectedUser_username) from pending list."
            log(text: text, logInside: [.journal])
            return true
        }else {
            return false
        }
        
    }
    
    func acceptPending(selected user: User) -> Bool {
        if let currentUser_username = username, let selectedUser_username = user.username {
            if cancelPending(selected: user) {
                if user.follow(selected: self) {
                    let text = "\(currentUser_username) started following \(selectedUser_username)"
                    log(text: text, logInside: [.journal])
                    user.log(text: text, logInside: [.journal])
                    return true
                }
            }
        }
        return false
    }
    
    func share(selected media: Media){
        
        if let mediaId = media.id, let currentUserId = id, let currentUser_username = username {
            
            var pathString: String?
            
            if media is Instance {
                pathString = "Instance"
            }else if media is Page {
                pathString = "Page"
            }//...
            
            if let pathString = pathString {
                database.child(pathString).child(mediaId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let mediaInfo = snapshot.value as? NSDictionary {
                        
                        let title = mediaInfo["title"] as? String
                        let imageURL = mediaInfo["imageURL"] as? String
                        
                        var text: String?
                        
                        if let title = title {
                            if media is Instance {
                                self.database.child("SharedInstances").child(currentUserId).child(mediaId).setValue(true)
                                
                                
                                text = "\(currentUser_username) started sharing instance '\(title)'"
                                
                                
                            }
                            
                            if media is Page {
                                self.database.child("SharedPages").child(currentUserId).child(mediaId).setValue(true)
                                text = "\(currentUser_username) started sharing page '\(title)'"
                                
                            }
                        }
                        
                        if let imageURL = imageURL {
                            if media is Photo {
                                self.database.child("SharedPhoto").child(currentUserId).child(mediaId).setValue(true)
                                text = "\(currentUser_username) started sharing photo"
                            }
                        }
                        
                        if let text = text {
                            self.log(text: text, imageURL: imageURL,  logInside: [.journal, .feed])
                        }
                    }
                })
            }
        }
    }
    
    func unshare(selected media: Media){
        
        if let mediaId = media.id, let currentUserId = id, let currentUser_username = username {
            
            var pathString: String?
            
            if media is Instance {
                database.child("SharedInstances").child(currentUserId).child(mediaId).removeValue()
                pathString = "Instance"
            }
            
            if media is Page {
                database.child("SharedPages").child(currentUserId).child(mediaId).removeValue()
                pathString = "Page"
            }
            
            if media is Photo {
                database.child("SharedPhoto").child(currentUserId).child(mediaId).removeValue()
                pathString = "Photo"
            }
            
            
            if let pathString = pathString {
                
                database.child(pathString).child(mediaId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let mediaInfo = snapshot.value as? NSDictionary {
                        
                        let title = mediaInfo["title"] as? String
                        let imageURL = mediaInfo["imageURL"] as? String
                        
                        var text: String?
                        
                        
                       
                        
                        if let title = title {
                            if media is Instance {
                                text = "\(currentUser_username) removed shared instance '\(title)'"
                                
                                
                            }
                            
                            if media is Page {
                                text = "\(currentUser_username) removed shared page '\(title)'"
                                
                            }
                        }
                        
                        if let _ = imageURL {
                            if media is Photo {
                                text = "\(currentUser_username) removed shared photo"
                            }
                        }
                        
                        if let text = text {
                            self.log(text: text, imageURL: imageURL,  logInside: [.journal, .feed])
                    
                        }
                        
                    }
                    
                })
            }
            
            
         
           
        }else {
    
        }
        
    }

    
    func bookmark(selected media: Media){
        if let mediaId = media.id, let currentUserId = id, let currentUser_username = username {
            
            var pathString: String?
            
            if media is Instance {
                database.child("BookmarkedInstances").child(currentUserId).child(mediaId).setValue(true)
                pathString = "Instance"
            }
            
            if media is Page {
                database.child("BookmarkedPages").child(currentUserId).child(mediaId).setValue(true)
                pathString = "Page"
                
            }
            
            if media is Photo {
                database.child("BookmarkedPhoto").child(currentUserId).child(mediaId).setValue(true)
                pathString = "Photo"
            }
            
            if let pathString = pathString {
                
                database.child(pathString).child(mediaId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let mediaInfo = snapshot.value as? NSDictionary {
                        
                        let title = mediaInfo["title"] as? String
                        let imageURL = mediaInfo["imageURL"] as? String
                        
                        var text: String?
                    
                        if let title = title {
                            if media is Instance {
                                text = "\(currentUser_username) bookmarked instance '\(title)'"
                            }
                            
                            if media is Page {
                                text = "\(currentUser_username) bookmarked page '\(title)'"
                            }
                        }
                        
                        if let _ = imageURL {
                            if media is Photo {
                                text = "\(currentUser_username) bookmarked photo"
                            }
                        }
                        
                        if let text = text {
                            self.log(text: text, imageURL: imageURL, logInside: [.journal, .feed])
    
                        }
                        
                    }
                    
                })
            }
            
            
        }else {
          
        }
        
    }
    
    func removeBookmark(selected media: Media){
        if let mediaId = media.id, let currentUserId = id, let currentUser_username = username {
            
            var pathString: String?
            
            if media is Instance {
                database.child("BookmarkedInstances").child(currentUserId).child(mediaId).removeValue()
                pathString = "Instance"
            }
            
            if media is Page {
                database.child("BookmarkedPages").child(currentUserId).child(mediaId).removeValue()
                pathString = "Page"
            }
            
            if media is Photo {
                database.child("BookmarkedPhoto").child(currentUserId).child(mediaId).removeValue()
                pathString = "Photo"
            }
            if let pathString = pathString {
                
                database.child(pathString).child(mediaId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let mediaInfo = snapshot.value as? NSDictionary {
                        
                        let title = mediaInfo["title"] as? String
                        let imageURL = mediaInfo["imageURL"] as? String
                        
                        var text: String?
                        
                        if let title = title {
                            if media is Instance {
                                text = "\(currentUser_username) removed instance '\(title)' from bookmarked"
                            }
                            
                            if media is Page {
                                text = "\(currentUser_username) removed page '\(title)' from bookmarked"
                            }
                        }
                        
                        if let _ = imageURL {
                            if media is Photo {
                                text = "\(currentUser_username) removed photo from bookmarked"
                            }
                        }
                        
                        if let text = text {
                            self.log(text: text, imageURL: imageURL,  logInside: [.journal, .feed])
        
                        }
                        
                    }
                    
                })
            }
        }
    }
    
    /*
    func remove(instance: Instance){
        if let instanceId = instance.id, let currentUserId = id {
            database.child("Instance").child(instanceId).removeValue()
            
            if let instanceImageURL = instance.instanceImageURL {
                //delete image later.. todo
            }
            
            if let mods = thread.moderators {
                for mod in mods {
                    if let mod = mod as? User {
                        if let modId = mod.id {
                            database.child("Moderating").child(modId).child(instanceId).removeValue()
                        }
                    }
                   
                    
                }
            }
        
            database.child("Moderators").child(instanceId).removeValue()
            database.child("Instances").child(currentUserId).child(instanceId).removeValue()
        }
        
    }
    */
    /*
    func createThread(threadInfo: [String:Any]) {
        
        if let currentUserId = id, let title = threadInfo["title"] as? String, let visibility = threadInfo["visibility"] as? Bool, let currentUser_username = username {
        
            let newThreadId = database.child("Instance").childByAutoId().key
            let about = threadInfo["about"] as? String
            //image
            let date = Date()
            let createdDate = ThreadsData.getCurrentDateString(date: date)
            
            let childValues = ["title":title,
                               "visibility":visibility,
                               "createdDate":createdDate,
                               "about":about ?? "",
                               "createdBy":currentUserId] as [String:Any]
            
            database.child("Instance").child(newThreadId).setValue(childValues)
            
            
            //logging
            let logText = "\(currentUser_username) created Thread '\(title)'"
            
           
            if let selectedImage = threadInfo["selectedImage"] as? UIImage {
                
                let imageName = NSUUID().uuidString
                let storage = Storage.storage().reference().child("Instance").child("\(imageName).png")
                
                if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.1) {
                    
                    let uploadTask = storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil {
                            
                            print(error)
                            return
                        }
                        
                        print(metadata)
                        
                        if let imageURL = metadata?.downloadURL()?.absoluteString {
                            self.database.child("Instance").child(newThreadId).child("instanceImage").setValue(imageURL)
                            self.log(text: logText, imageURL: imageURL, logInside: [.feed, .journal])
                  
                        }
                        
                    })
                }
            }else {
                log(text: logText, logInside: [.feed, .journal])
            }
            
            
            //save the mods
            if let selectedModerators = threadInfo["selectedModerators"] as? [(User,IndexPath)] {
                
                for object in selectedModerators {
                    if let modId = object.0.id {
                        
                        if let moderator_username = object.0.username {
                            database.child("Moderators").child(newThreadId).child(modId).setValue(true)
                            database.child("Moderating").child(modId).child(newThreadId).setValue(true)
                            
                            let logText = "\(moderator_username) started moderating Instance '\(title)'"
                            
                            let logText_ModPOV = "You started moderating Instance '\(title)'"
                           
                            log(text: logText,logInside: [.feed, .journal])
                            object.0.log(text: logText_ModPOV, logInside: [.journal])
                        }
                        
                            
                        
                        
                    }
                }
            }
            
            //save under creator
            database.child("Instances").child(currentUserId).child(newThreadId).setValue(true)
            
        }
    }
    
    
    
    func edit(with userInfo: [String:Any]) -> Bool {
        if let id = id {
            database.child("User").child(id).updateChildValues(userInfo)
            return true
        }
        
        return false
    }
    
    func getUserFollowStateButtonTitle(selectedUserId: String, container: NSPersistentContainer, completion: @escaping (String) -> Void) {
        
        if let userId = id {
            print("getUserFollowStateButtonTitle:\(selectedUserId)-1-\(userId)")

            
            if selectedUserId == userId {
                print("getUserFollowStateButtonTitle:\(selectedUserId)-2-\(userId)")
                completion("")
                return
            }else {
                
                checkIfRequesting(selectedUserId: selectedUserId, container: container, completion: { (isRequesting) in
                    if isRequesting {
                        completion("Requested")
                        return
                    }else {
                        if self.checkIfPending(selectedUserId: selectedUserId, container: container) {
                            completion("Pending")
                            return
                        }else {
                            if self.checkIfFollowing(selectedUserId: selectedUserId, container: container) {
                                completion("Following")
                                return
                            }else {
                                completion("Follow")
                                return
                            }
                        }
                    }
                })
               
            }
        }
        
    
        
    }
    
    private func checkIfPending(selectedUserId: String, container: NSPersistentContainer) -> Bool {
        
        if let userId = id {
            let context = container.viewContext
            let request: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", userId)
            let predicateTwo = NSPredicate(format: "ANY pending.id == %@", selectedUserId)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateTwo])
            do {
                let matches = try context.fetch(request)
                let count = matches.count
                
                if count == 1 {
                    //try next predicate
                    
                    return true
                }
                
            }catch {
                //...
                return false
            }
        }
       
       
        return false
        
        
    }
    
    private func checkIfRequesting(selectedUserId: String, container: NSPersistentContainer, completion: @escaping (Bool) -> Void) {
        
        if let userId = id {
             database.child("Requested").child(userId).child(selectedUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let _ = snapshot.value as? Bool{
                   
                    completion(true)
                }else {
                    
                  
                    completion(false)
                }
            })
           
    
        }else {
            completion(false)
        }
   
        
        
    }
    
    private func checkIfFollowing(selectedUserId: String, container: NSPersistentContainer) -> Bool {
        if let userId = id {
            let context = container.viewContext
            let request: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", userId)
            let predicateTwo = NSPredicate(format: "ANY following.id == %@", selectedUserId)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateTwo])
            do {
                let matches = try context.fetch(request)
                let count = matches.count
                
                if count == 1 {
                    //try next predicate
                    
                    return true
                }
                
            }catch {
                //...
                return false
            }
            
            
        }
        
        
        return false
    }
    
    func checkIfFollowing(userWithId selectedUserId: String, completion: @escaping (Bool) -> Void){
        database.child("Following").queryOrdered(byChild: selectedUserId).queryEqual(toValue: true).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.value as? NSDictionary{
                completion(true)
            }else {
                
                completion(false)
            }
        })
    }
     */
}


*/
