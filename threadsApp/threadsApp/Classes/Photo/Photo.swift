//
//  Photo.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 12/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit
import CoreData
import Firebase

//id, about, createdDate, parentKey, createdBy

class Photo: MediaChild {

    private var coreRef: DatabaseReference?
    //private var moderatorsRef: DatabaseReference?
    
    class func get(photoId: String, context: NSManagedObjectContext, completion: @escaping (Photo?, Error?) -> Void) {
        let s_ = Constants.sharedInstance
        
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", photoId)
        
        do {
            let photos = try context.fetch(request)
            let count = photos.count
            
            var photo: Photo?
            
            if count > 0 && count < 2 {
                photo = photos.first
                completion(photo, nil)
                return
            }else {
                if count > 1 {
                    for photo in photos {
                        context.delete(photo)
                    }
                }
                
                let newPhoto = Photo(context: context)
                newPhoto.setValue(photoId, forKey: s_._id)
                
                newPhoto.connectCore(context: context, completion: { (didConnectCore, error) in
                    
                    if didConnectCore {
                        completion(newPhoto, nil)
                    }else {
                        if let error = error {
                            completion(nil, error)
                            return
                        }else {
                            completion(nil, nil)
                            return
                        }
                    }
                    
                    
                })
            }
   
    
        }catch {
            completion(nil, error)
            return
        }
    }
    
    func createStructure() -> PhotoStructure? {
        guard let id = id, let createdDate = createdDate, let about = about, let imageURL = imageURL, let creator = creator, let parent = parent else {
            return nil
        }
        
        guard let creatorStructure = creator.createStructure() else {
            return nil
        }
        
        guard let parentStructure = parent.createStructure() else {
            return nil
        }
        
        let photoStructure = PhotoStructure(id: id, imageURL: imageURL, about: about, createdDate: createdDate, visibility: visibility, parentStructure: parentStructure, creatorStructure: creatorStructure)
        
        return photoStructure
    }
    
    func updateAbout(about: String) -> Bool {

        guard let id = id else {
            return false
        }
    Database.database().reference().child(Constants.sharedInstance._Photo).child(id).child(Constants.sharedInstance._about).setValue(about)
        
        return true
        
    }
    
    func update(image: UIImage, completion: @escaping (Bool, Error?) -> Void){
        guard let id = id else {
            return
        }
        
        let ref = Database.database().reference().child(Constants.sharedInstance._Photo).child(Constants.sharedInstance._imageName)
        let strings = Constants.sharedInstance
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let imageName = snapshot.value else {
                return
            }
            
            let imageNodeInStorage = Storage.storage().reference().child(strings._Images).child("\(imageName).jpeg")
            imageNodeInStorage.delete(completion: { (error) in
                if let error = error {
                    //error handle
                    completion(false, error)
                    return
                }else {
                    ref.removeValue()
                    
                    if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
                        imageNodeInStorage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                completion(false, error)
                            }else {
                            Database.database().reference().child(strings._User).child(id).child(strings._profileImage).setValue(imageName)
                                completion(true, nil)
                            }
                            return
                        })
                    }else {
                        completion(false, nil)
                        return
                    }
                }
            })
        }
    }
    
    func addCore(coreInfo: [String:String]) -> Bool {
        //core info must have: createdBy, createdDate, and about*
        
        guard let id = coreInfo[s_._id], let createdBy = coreInfo[s_._createdBy], let createdDate = coreInfo[s_._createdDate] else {
            return false
        }
        
        let about = coreInfo[s_._about] ?? s_._emptyString
        
        let updatedCoreInfo = [s_._createdBy:createdBy,
                               s_._createdDate:createdDate,
                               s_._about:about] as [String:String]
        
        database.child(s_._Photo).child(id).updateChildValues(updatedCoreInfo)
        
        return true
    }
}

