//
//  ProfileVC+ext+TableViewDataSource.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 22/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension ProfileVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDisplay.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplay[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let display = tableViewDisplay[indexPath.section][indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: s_._TypicalTVCell, for: indexPath) as? TypicalTVCell {
            
            cell.configure(mainLabel: display.rawValue)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let manager = manager else {
            return
        }
        
        let section = indexPath.section
        let row = indexPath.row
    
        let display = tableViewDisplay[section][row]
        
        var type: User.ListType?
        
        switch display {
        case .feed:
            type = .feed
            break
        case .followers:
            type = .followers
            break
        case .threads:
            type = .createdThreads
            break
        case .following:
            type = .following
            break
        case .signOut:
            ThreadsData.sharedInstance.signOut { (didSignOut, error) in
                if didSignOut {
                    guard let parent = self.parent as? ProfileViewController else {
                        return
                    }
                    
                    parent.shouldPop = true
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            return
        case .edit:
          //todo
            break
        default:
            return
        }
        
        guard let listType = type else {
            return
        }
        
        let listManagerWithFeedback = ThreadsData.sharedInstance.getUserListManager(selectedUserStruture: manager.selectedUserStructure, employedBy: manager.employedBy, listType: listType)
       
        if let listManager = listManagerWithFeedback.0 {
            
            listManager.observe(action: .add, toFirst: 1) { (feedback, error) in}
            
            listManager.observe(action: .remove, toFirst: nil) { (feedback, error) in
               
            }
            
            let userListVC = UserListVC(manager: listManager)
            self.navigationController?.pushViewController(userListVC, animated: true)
        }else {
           //error handle
        }
    }
}
