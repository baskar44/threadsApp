//
//  EditUserVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 15/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//


import UIKit
import Firebase
import CoreData

class EditUserVC: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
/*
    enum EditUserBranch {
        case username
        case fullname
        case bio
        case visibility
        case changePassword
    }
    
    //Local Enum
    enum EditUserFailedType: String {
        case usernameIsEmpty = "Username field is empty"
        case usernameAlreadyExists = "Username already exists"
        case currentUserIsNoLongerActive = "Lost connection with active user. Reload Application and try again."
        case currentUsernameIsNil = "Lost connection with active user's username. Reload Application and try again."
        case profileImageUpdateFailed = "Profile image failed to update. Try again."
        case editProcessFailed = "Failed to complete edit process. Try again"
    }
    
    enum WarningType: String {
        case currentUsernameOrVisibilityIsNil = "Lost connection with active user's username. Reload Application and try again."
        case profileImageHasBeenChanged = "Cancel without saving changes to profile image?"
        case unsavedDataExists = "Cancel without saving changes?"
        case errorWhileProcessingCancel = "Error while processing cancel"
    }
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var profileImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var curtainView: UIView!
    @IBOutlet weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
    
    
    //Table View Outlets Variables
    weak var usernameTextField: UITextField!
    weak var fullnameTextField: UITextField!
    weak var bioTextView: UITextView!
    weak var visibilitySwith: UISwitch!
    
    //Main Constants
    let tableViewDisplay: [[EditUserBranch]] = [[.username], [.fullname], [.bio], [.visibility], [.changePassword]]
    let picker = UIImagePickerController()
    
    //Main Variables
    internal var didChangeProfileImage: Bool = false
    
    //View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        run()
    }
    
    private func run(){
        
        guard toggle(curtainView: curtainView, to: .open) else {
            //error handle
            return
        }
        
        
        //getting bar button items
        //left: cancel and right: save
        
        //1 Setting up navigation bar
        let leftBarButtonItems = [UIBarButtonItem(title: s_._Cancel, style: .plain, target: self, action: #selector(handleCancelButtonTapped))]
        let rightBarButtonItems = [UIBarButtonItem(title: s_._Save, style: .plain, target: self, action: #selector(handleSaveButtonTapped))]
        
        guard setupNavigationController(isNavigationBarHidden: false, prefersLargeTitles: true, title: s_._Edit_User, leftBarButtonItems: leftBarButtonItems, rightBarButtonItems: rightBarButtonItems) else {
            //error handle
            return
        }
        
        //2 Setting up tab bar controller
        guard setupTabBarController(isHidden: true) else {
            //error handle
            return
        }
        
        //3 Setting up table view
        guard setupTableView(tableView: tableView, delegate: self, dataSource: self, register: [.textField, .textView, .switchType, .typical]) else {
            //error handle
            return
        }
        
        addNotifications()
        setupProfileImageView { (didSetup, error) in
            if didSetup {
                guard self.toggle(curtainView: self.curtainView, to: .closed) else {
                    //error handle
                    return
                }
            }else {
                //error handle
                if let error = error {
                    
                }
            }
        }
        
        
    }
    
    
    
    private func setupProfileImageView(completion: @escaping (Bool, Error?) -> Void){
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUIImageViewTapped))
        userProfileImageView.addGestureRecognizer(tap)
        
        if let profileImageURL = currentUserStructure?.profileImageURL {
            userProfileImageView.loadImageUsingCacheWithURLString(imageURL: profileImageURL, completion: { (didLoadImage, error) in
               completion(didLoadImage, error)
            })
        }else {
            userProfileImageView.backgroundColor = .blue
            completion(true, nil)
        }
        
    }
    
    
    @objc private func handleUIImageViewTapped(){
        
        self.view.isUserInteractionEnabled = false
        
        let alertViewController = UIAlertController(title: s_._Edit_Profile_Image, message: "Change or remove profile image", preferredStyle: .actionSheet)
        
        let changeAction = UIAlertAction(title: s_._Change, style: .default) { (alert) in
            self.picker.delegate = self
            self.picker.allowsEditing = false
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let removeAction = UIAlertAction(title: s_._Remove, style: .default) { (alert) in
            self.currentUserStructure?.removeProfileImage(completion: { (didRemove, error) in
                if didRemove {
                    //maybe later
                    //handle
                }else {
                    //error handle
                    if let error = error {
                        
                    }
                }
                
                alertViewController.dismiss(animated: true, completion: {
                    self.view.isUserInteractionEnabled = true
                })
            })
        }
        
        let cancelAction = UIAlertAction(title: s_._Cancel, style: .cancel) { (alert) in
            self.view.isUserInteractionEnabled = true
        }
        
        alertViewController.addAction(changeAction)
        alertViewController.addAction(removeAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
        
        
    }
    
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func updateTableView(notifcation: Notification) {
        if let info = notifcation.userInfo, let keyWindow = UIApplication.shared.keyWindow {
            if let keyboardEndFrameCoordinates = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let rectVal = keyboardEndFrameCoordinates.cgRectValue
                let keyboardEndFrame = self.view.convert(rectVal, to: view.window)
                let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
                //let height = keyWindow.frame.height - keyboardEndFrame.height - userProfileImageView.frame.height - navBarHeight - 50
                tableViewBottomLayoutConstraint.constant = -(keyboardEndFrame.height)
                
                //let frame = CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.frame.width, height:height)
                
                //tableView.frame = frame
                view.layoutIfNeeded()
                
            }
        }
    }
  
   */
}



