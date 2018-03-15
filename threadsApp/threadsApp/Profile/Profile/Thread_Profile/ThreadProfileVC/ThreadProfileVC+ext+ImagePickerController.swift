//
//  ThreadProfileVC+ext+ImagePickerController.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 5/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension ThreadProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            //maybe later
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //did finish picking
        
        guard let manager = manager else {
            //error handle
            return
        }
        
        //either photo or video has been selected
        switch selectedPickerType {
            
        case .photo:
            if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                let notepadManager = NotepadManager(mode: (false, nil), employedBy: manager.getEmployer(), workingUnder: self, selectedMedia: originalImage)
                
                let notepadVC = NotepadVC(manager: notepadManager)
                navigationController?.pushViewController(notepadVC, animated: true)
                
                dismiss(animated: true, completion: {
                    
                })
            }
            break
        case .audio:
            break
        case .video:
            break
        }
    }
}
