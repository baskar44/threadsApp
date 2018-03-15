//
//  ThreadProfileVC+ext+TableView.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension ThreadProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let body = frcForInstanceBody?.sections?[indexPath.section].objects?[indexPath.row] as? Body {
            
            guard let selectedBodyStructure = body.createStructure() else {
                return
            }
            
            guard let employedBy = manager?.getEmployer() else {
                return
            }
            
            if editMode {
                let manager = NotepadManager(mode: (true, selectedBodyStructure), employedBy: employedBy, workingUnder: self, selectedMedia: nil)
                let notepadVC = NotepadVC(manager: manager)
                self.navigationController?.pushViewController(notepadVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actions: [UITableViewRowAction] = []
        
        guard let manager = manager else {
            return actions
        }
        
        if editMode {
            
             if let body = frcForInstanceBody?.sections?[indexPath.section].objects?[indexPath.row] as? Body {
                
                if let selectedBodyStructure = body.createStructure() {
                    let editAction = UITableViewRowAction(style: .normal, title: Constants.sharedInstance._Edit) { (action, indexPath) in
                        
                        let notepadManager = NotepadManager(mode: (true, selectedBodyStructure), employedBy: manager.getEmployer(), workingUnder: self, selectedMedia: nil)
                        let notepadVC = NotepadVC(manager: notepadManager)
                        self.navigationController?.pushViewController(notepadVC, animated: true)
                    }
                    
                    actions.append(editAction)
                }
            }
            
        }
        
        return actions
    }
}

extension ThreadProfileVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return frcForInstanceBody?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return frcForInstanceBody?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let body = frcForInstanceBody?.sections?[indexPath.section].objects?[indexPath.row] as? Body {
            if let cell = tableView.dequeueReusableCell(withIdentifier: s_._TextTVC, for: indexPath) as? TextTVC {
                //sample text
                var text: String = ""
                
                
                if let body = body.bodyText {
                    text = body
                }
                
                cell.configure(text: text)
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
}
