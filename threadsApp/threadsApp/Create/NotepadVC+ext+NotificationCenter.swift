//
//  CreateMediaVC+ext+NotificationCenter.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 22/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension NotepadVC {
    //MARK:- Notifcation Center Related
    internal func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func updateTextView(notifcation: Notification) {
        if let info = notifcation.userInfo {
            if let keyboardSize = info[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
                bodyTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 20, right: 0)
            }
        }
    }
}
