//
//  ThreadsData.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 7/11/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

final class ThreadsData {
    
    private var _strings: Constants
    var strings: Constants {
        return _strings
    }
    
    private var _userListManagers: [UserListManager] = []
    var userListManagers: [UserListManager] {
        return _userListManagers
    }
    
    private init(){
        _strings = Constants.sharedInstance
    }
    
    
    func addToUserListManagers(manager: UserListManager){
        _userListManagers.append(manager)
    }
    
    //this function returns the user list manager, if it exists. if it does not exists, then the function creates and returns a new list manager
    func getUserListManager(selectedUserStruture: UserStructureProtocol, employedBy: UserStructureProtocol, listType: User.ListType) -> (UserListManager?, Feedback) {
        
        guard let context = container?.viewContext else {
            return (nil, .failedWhileGettingContext)
        }
        
        let filteredManagers = _userListManagers.filter{($0.employedBy.id == employedBy.id) && ($0.selectedUserStructure.id == selectedUserStruture.id) && ($0.listType == listType)}
        
        if filteredManagers.count > 1 {
            //error
            //clear all and create new
            for manager in filteredManagers {
                //get index
                let arrayIndex = _userListManagers.index(where: { (listManager) -> Bool in
                    if (manager.selectedUserStructure.id == listManager.selectedUserStructure.id) && (manager.employedBy.id == listManager.employedBy.id) && (manager.listType == listManager.listType) {
                        return true
                    }else {
                        return false
                    }
                })
                
                if let index = arrayIndex {
                   _userListManagers.remove(at: index)
                }
            }
            
            let newListManager = UserListManager(listType, employedBy: employedBy, selectedUserStructure: selectedUserStruture, context: context)
            _userListManagers.append(newListManager)
            return (newListManager, .successful)
            
        }else if filteredManagers.count == 1 {
            return (filteredManagers.first, .successful)
            
        }else { //empty - create new user list manager
            
            let newListManager = UserListManager(listType, employedBy: employedBy, selectedUserStructure: selectedUserStruture, context: context)
            _userListManagers.append(newListManager)
            return (newListManager, .successful)
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    static func getCurrentDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = dateFormatter.string(from: date)
        return(dateString)
    }
    
    static func getDate(for date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let date = dateFormatter.date(from: date)
        return date
    }
    
    static let sharedInstance = ThreadsData()
    
    let dbRef = Database.database().reference()
    
    func loadImageUsingCacheWithURLString(imageURL: String?, onCompletion: @escaping (UIImage?, Error?) -> Void){
        guard imageURL != nil else {return}
        let imageURL = imageURL!
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                onCompletion(cachedImage, nil)
                return
            }
            
        }else {
            
            guard let url = URL(string: imageURL) else {
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    onCompletion(nil, error)
                    return
                }
                
                if let imageData = data {
                    if let downloadedImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            imageCache.setObject(downloadedImage, forKey: imageURL as AnyObject)
                            onCompletion(downloadedImage, nil)
                            return
                        }
                    }else {
                        onCompletion(nil, nil)
                        return
                    }
                }else {
                    onCompletion(nil, nil)
                    return
                }
                
                
                
            }).resume()
        }
        
    }
    
    
   
    
    
   
}


