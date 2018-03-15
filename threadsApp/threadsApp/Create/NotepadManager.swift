//
//  NotepadManager.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 26/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

//1 check to make sure photo add/remove leaves proper feed and journal trails - done
//2 add journal to follow states 
//3 add journal to share states

import UIKit
import Firebase

protocol BodyStructureProtocol: MediaChildStructureProtocol {
    var content: String {get}
}

protocol PhotoStructureProtocol: MediaChildStructureProtocol {
    var imageURL: String {get}
}

enum NotepadType {
    case thread
    case instance
    case body
}

enum NotepadTextViewType {
    case title
    case content
}

struct NotepadManager {
    
    enum NotepadSaveFeedback: String {
        case successful = "Successful"
        case invalidParentObject = "Manager has an invalid parent object"
        case invalidChildObject = "Invalid media structure"
        case addFailed = "Failed when attempting to add item"
        case titleUpdateFailed = "Failed when attempting to update title of item"
        case contentUpdateFailed = "Failed when attempting to update content of item"
        case visibilityUpdateFailed = "Failed when attempting to update visibility of item"
        case updateFailed = "Update failed."
    }
    
    enum NotepadTrashFeedback: String {
        case notOnEditMode = "Feature not available - must be on edit mode."
        case hasExistingChildren = "Item has existing children. Please remove the existing children before attempting to trash item."
        case invalidParentObject = "Manager has an invalid parent object"
        case successful = "Successfully trashed item"
        case failed = "Failed"
    }
    
    
    //creates and updates media
    private var _mode: NotepadVC.NotepadMode
    private var _employedBy: UserStructureProtocol
    private var _parentObject: ObjectStructureProtocol?
    private var _initialTitle: String
    private var _initialContent: String
    private var _workingUnder: ViewController
    
    var selectedMedia: Any?
    
    var mode: NotepadVC.NotepadMode {
        return _mode
    }
    
    var initialTitle: String {
        return _initialTitle
    }
    
    var initialContent: String {
        return _initialContent
    }
    
    var workingUnder: ViewController {
        return _workingUnder
    }
    
    init(mode: NotepadVC.NotepadMode, employedBy: UserStructureProtocol, workingUnder: ViewController, selectedMedia: Any?) {
        
        typealias Title = String
        typealias Content = String
        
        func getInitialValues(mode: NotepadVC.NotepadMode) -> (Title, Content) {
            if mode.0 {//edit mode
                if let bodyStructure = mode.1 as? BodyStructureProtocol { //protocol
                    return (bodyStructure.title, bodyStructure.content)
                }else if let threadStructure = mode.1 as? ThreadStructureProtocol { //protocol
                    return (threadStructure.title, threadStructure.about)
                }else if let photoStructure = mode.1 as? PhotoStructureProtocol {
                    return (Constants.sharedInstance._emptyString, photoStructure.about)
                }
            }
            
            let string = Constants.sharedInstance
            return (string._emptyString, string._emptyString)
        }
        
        func getParentObject(mode: NotepadVC.NotepadMode) -> ObjectStructureProtocol? {
            
            if mode.0 {//edit mode //updating
            
                if let bodyStructure = mode.1 as? BodyStructureProtocol { //protocol
                    return bodyStructure.parentStructure
                }else if let photoStructure = mode.1 as? PhotoStructureProtocol { //protocol
                    return photoStructure.parentStructure
                }else if let threadStructure = mode.1 as? ThreadStructureProtocol { //protocol
                    return threadStructure.creatorStructure
                }
                
                
            }else {
                if let workingUnder = workingUnder as? UserListVC {
                    return workingUnder.manager?.selectedUserStructure
                }else if let workingUnder = workingUnder as? ThreadProfileVC {
                    return workingUnder.manager?.getSelectedThread()
                }else {
                    //fail
                }
            }
            
            return nil
        }
        
        let initialValues = getInitialValues(mode: mode)
        let parentObject = getParentObject(mode: mode)
        
        _mode = mode
        _employedBy = employedBy
        _parentObject = parentObject
        _initialTitle = initialValues.0
        _initialContent = initialValues.1
        _workingUnder = workingUnder
        self.selectedMedia = selectedMedia
    }
    
    //no test req.
    func save(title: String, content: String, image: UIImage?, isVisible: Bool, completion: @escaping (NotepadSaveFeedback) -> Void) {
        if mode.0 {//edit mode - update using child
            
            //a if body structure
            if let bodyStructure = mode.1 as? BodyStructure {
                
                var sections: [MediaChildSection] = []
                
                //get the core sections of the body structure and update them
                if title == initialTitle && content == initialContent {
                    sections = []
                }else if title == initialTitle && content != initialContent {
                    sections = [.content]
                }else if content == initialContent && title != initialTitle {
                    sections = [.title]
                }else if title != initialTitle && content != initialContent{
                    sections = [.title, .content]
                }
                
                //updating
                if !bodyStructure.updateVisibility(isVisible) {
                    completion(.visibilityUpdateFailed) //at visibility
                }else {
                    
                    bodyStructure.update(sections, title: title, content: content, isVisible: isVisible, completion: { (feedback, error) in
                        
                        if !(feedback == .successful) {
                            completion(.updateFailed)
                        }else {
                            completion(.successful)
                        }
                        
                        return
                        
                    })
                }
            
                //b if photostructure 
            }else if let photoStructure = mode.1 as? PhotoStructure {
                
                if !photoStructure.updateVisibility(isVisible: isVisible) {
                    completion(.visibilityUpdateFailed)
                    return
                }else {
                    if !(content == initialContent) {
                        photoStructure.updateAbout(text: content, isVisible: isVisible, completion: { (feedback, error) in
                            if !(feedback == .successful) {
                                completion(.updateFailed)
                            }else {
                                completion(.successful)
                            }
                            return
                        })
                    }
                }
                
            }else if let threadStructure = mode.1 as? ThreadStructure {
            
                var sections: [ThreadStructure.ThreadSection] = []
                
                //get the core sections of the body structure and update them
                if title == initialTitle && content == initialContent {
                    sections = []
                }else if title == initialTitle && content != initialContent {
                    sections = [.about]
                }else if content == initialContent && title != initialTitle {
                    sections = [.title]
                }else if title != initialTitle && content != initialContent{
                    sections = [.title, .about]
                }
                
                if !threadStructure.updateVisibility(isVisible) {
                    completion(.visibilityUpdateFailed)
                    return
                }else {
                    threadStructure.update(sections, title: title, content: content, isVisible: isVisible, completion: { (feedback, error) in
                        if !(feedback == .successful) {
                            completion(.updateFailed)
                        }else {
                            completion(.successful)
                        }
                        
                        return
                    })
                }
    
            }else {
                completion(.invalidChildObject)
                return
            }
            
        }else { //- add using parent
            
            let date = Date()
            let ref = Database.database().reference()
            
            if let threadStructure = _parentObject as? ThreadStructure {
                
                if let image = image {
                    let id = ref.child(Constants.sharedInstance._Photo).childByAutoId().key
                    
                    let photoTemplate = PhotoTemplate(id: id, image: image, parentKey: threadStructure.id, createdDate: date, createdBy: _employedBy.id, about: content, visibility: isVisible)
                    
                    threadStructure.addPhoto(with: photoTemplate, completion: { (feedback, error) in
                        if feedback == .successful {
                            completion(.successful)
                        }else {
                            completion(.addFailed)
                        }
                        return
                    })
                    
                    
                }else {
                    let id = ref.child(Constants.sharedInstance._Body).childByAutoId().key
                    
                    let bodyTemplate = BodyTemplate(id: id, bodyText: content, bodyTitle: title, createdDate: date, createdBy: _employedBy.id, parentKey: threadStructure.id, visibility: isVisible)
                    
                    threadStructure.addBody(with: bodyTemplate, completion: { (feedback, error) in
                        if feedback == .successful {
                            completion(.successful)
                        }else {
                            completion(.addFailed)
                        }
                        
                        return
                    })
                }
                
            }else if let userStructure = _parentObject as? UserStructure {
                
                let id = ref.child(Constants.sharedInstance._Thread_).childByAutoId().key
                
                let threadTemplate = ThreadTemplate(id: id, title: title, visibility: isVisible, createdDate: date, about: content, createdBy: _employedBy.id)
                
                userStructure.addThread(threadTemplate: threadTemplate, completion: { (feedback, error) in
                    if feedback == .successful {
                        completion(.successful)
                    }else {
                        completion(.addFailed)
                    }
                    
                    return
                })
            
            }else {
                //error handle
                completion(.invalidParentObject)
                return
            }
            
        }
        
    }
    
    //no test req.
    func trash(completion: @escaping (NotepadTrashFeedback) -> Void) {
        //1 make sure manager is on edit mode => mode.0 = editMode (Bool)
        if mode.0 {
         
        //instance with body item, thread with instance item or user with thread item.
            if let userStructure = _parentObject as? UserStructure, let threadStructure = mode.1 as? ThreadStructureProtocol {
                
                userStructure.removeThread(selectedThreadStructure: threadStructure, completion: { (feedback, error) in
                    if feedback == .successful {
                        completion(.successful)
                    }else if feedback == .threadHasExistingChildren {
                        completion(.hasExistingChildren)
                    }else {
                        completion(.failed)
                    }
                    return
                })
                
            }else if let threadStructure = _parentObject as? ThreadStructureProtocol, let bodyStructure = mode.1 as? BodyStructureProtocol {
                
                threadStructure.removeBody(bodyStructure: bodyStructure, completion: { (feedback, error) in
                    if feedback == .successful {
                        
                        completion(.successful)
                        return
                    }else {
                        completion(.failed)
                    }
                    
                    return
                })
               
            }else if let threadStructure = _parentObject as? ThreadStructureProtocol, let photoStructure = mode.1 as? PhotoStructure {
                
                threadStructure.removePhoto(photoStructure: photoStructure, completion: { (feedback, error) in
                    if feedback == .successful {
                        
                        completion(.successful)
                        return
                    }else {
                        completion(.failed)
                    }
                    
                    return
                })
                
            }else if let threadStructure = _parentObject as? ThreadStructureProtocol, let videoStructure = mode.1 as? FilmStructure {
                
                // todo later
                completion(.successful)
                return
                
            }else if let threadStructure = _parentObject as? ThreadStructure, let audioStructure = mode.1 as? AudioStructure {
                
                // todo later
                completion(.successful)
                return
                
            }else {
                //error handle
 
                completion(.invalidParentObject)
            }
        }else {
            completion(.notOnEditMode)
        }
    }
}

