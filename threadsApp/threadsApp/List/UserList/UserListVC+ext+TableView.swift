//
//  UserListVC+ext+TableView.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 31/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension UserListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let listType = manager?.listType else {
            return 0
        }
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return 0
        }
        
        if listType == .followers || listType == .following || listType == .pending || listType == .requested {
            return 80
        }
        
        let frcCount = frc?.sections?.count ?? 0
        
        if listType == .feed && indexPath.section != frcCount {
            
            if let feedItem = frc?.sections?[indexPath.section].objects?[indexPath.row] as? FeedItem {
                if let target = feedItem.target as? Body {
                    
                    let width = keyWindow.frame.width - 64
                    let size = CGSize(width: width, height: 1000)
                    let bodyText = target.bodyText ?? s_._emptyString
                    let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
                    let estimatedFrame = NSString(string: bodyText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                    
                    if estimatedFrame.height > 240 {
                        
                        return 240
                    }else {
                        return estimatedFrame.height
                    }
                }else if let _ = feedItem.target as? Photo {
                    return 300
                }
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let manager = manager else {
            return
        }
        
        let frcCount = frc?.sections?.count
        
        let section = indexPath.section
        let row = indexPath.row
        
        if (manager.listType == .followers || manager.listType == .following) && indexPath.section != frcCount {
            
            if let selectedUser = frc?.sections?[section].objects?[row] as? User {
                if let selectedUserStructure = selectedUser.createStructure() {
                    let userProfileManager = UserProfileManager(employedBy: manager.employedBy, selectedUserStructure: selectedUserStructure)
                    let userProfileVC = ProfileVC(manager: userProfileManager)
                    navigationController?.pushViewController(userProfileVC, animated: true)
                }
            }
            
        }else if (manager.listType == .createdThreads) && indexPath.section != frcCount {
            guard let selectedThread = frc?.sections?[section].objects?[row] as? Thread_  else {
                //error handle
                return
            }
            
            guard let selectedThreadStructure = selectedThread.createStructure() else {
                //error handle
                return
            }
        
            //todo later
            let manager = ThreadProfileManager(selectedThreadStructure: selectedThreadStructure, employedBy: selectedThreadStructure.creatorStructure)
            
            let threadProfileVC = ThreadProfileVC(manager: manager)
            
            navigationController?.pushViewController(threadProfileVC, animated: true)
        
        }else if manager.listType == .feed && indexPath.section != frcCount {
            //todo later
        }else if manager.listType == .journal && indexPath.section != frcCount {
            //todo later
        }else if indexPath.section == frcCount {
    
            var totalNumberOfObjects = 0
            
            if let frcSections = frc?.sections {
                for section in frcSections {
                    totalNumberOfObjects = totalNumberOfObjects + section.numberOfObjects
                }
            }
            
            let toFirst = UInt(totalNumberOfObjects + 1)
            
            
            manager.observe(action: .add, toFirst: toFirst, completion: { (feedback, error) in
                return
            })
        }
        
        return
    }
}

extension UserListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let frcCount = frc?.sections?.count ?? 0
        return frcCount + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let frcCount = frc?.sections?.count ?? 0
        
        if section == frcCount {
            return 1
        }else {
           
            return frc?.sections?[section].numberOfObjects ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let listType = manager?.listType else {
            return UITableViewCell()
        }
        
        let frcCount = frc?.sections?.count ?? 0
        
        if listType == .createdThreads && indexPath.section != frcCount {
            if let thread = frc?.sections?[indexPath.section].objects?[indexPath.row] as? Thread_ {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: s_._ThreadTVC, for: indexPath) as? ThreadTVC {
    
                    guard let title = thread.title, let username = thread.creator?.username, let createdDate = thread.createdDate else {
                        return UITableViewCell()
                    }
                    
                    
                    let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
                    cell.configure(threadTitle: title, username: username, createdDateString: createdDateString)
                    return cell
                }
            }
        }else if (listType == .followers || listType == .following || listType == .pending || listType == .requested) && indexPath.section != frcCount {
            if let user = frc?.sections?[indexPath.section].objects?[indexPath.row] as? User {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: s_._UserTVC, for: indexPath) as? UserTVC {
                    
                    guard let username = user.username, let selectedUserStructure = user.createStructure(), let employedBy = manager?.employedBy else {
                        return UITableViewCell()
                    }
                    
                    cell.configure(fullname: user.fullname, username: username, userImageURL: user.profileImageURL)
                    
                    cell.userFollowStateButton.setTitle(s_._Loading, for: .normal)
                    cell.userFollowStateButton.accessibilityIdentifier = "\(indexPath.section)"
                    cell.userFollowStateButton.tag = indexPath.row
                    
                    let userProfileManager = UserProfileManager(employedBy: employedBy, selectedUserStructure: selectedUserStructure)
                    
                    userProfileManager.getFollowState(completion: { (followState) in
                        cell.userFollowStateButton.setTitle(followState.rawValue, for: .normal)
                        cell.userFollowStateButton.addTarget(self, action: #selector(self.userFollowStateButtonTapped), for: .touchUpInside)
                    })
                    
                    return cell
                }
            }
        }else if listType == .journal && indexPath.section != frcCount {
            
        }else if listType == .feed && indexPath.section != frcCount {
            
            if let feedItem = frc?.sections?[indexPath.section].objects?[indexPath.row] as? FeedItem {
            
                if let target = feedItem.target as? Thread_ {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: s_._ThreadFeedTVC, for: indexPath) as? ThreadFeedTVC {
                        
                        if let feedCreatedDate = feedItem.createdDate, let threadCreatedDate = target.createdDate, let message = feedItem.message, let targetTitle = target.title, let targetUsername = target.creator?.username {
                            
                            let threadCreatedDateString = ThreadsData.getCurrentDateString(date: threadCreatedDate)
                            
                            let feedCreatedDateString = ThreadsData.getCurrentDateString(date: feedCreatedDate)
                            cell.configure(threadTitle: targetTitle, username: targetUsername, threadCreatedDateString: threadCreatedDateString, message: message, feedCreatedDateString: feedCreatedDateString)

                            return cell
                        }
                    }
                }else if let target = feedItem.target as? Body {
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: s_._FeedBodyTVC, for: indexPath) as? FeedBodyTVC {
                        
                        if let feedCreatedDate = feedItem.createdDate, let threadCreatedDate = target.createdDate, let message = feedItem.message, let targetUsername = target.creator?.username {
                            
                            let feedCreatedDateString = ThreadsData.getCurrentDateString(date: feedCreatedDate)
                            let text = target.bodyText ?? s_._emptyString
                            
                            cell.configure(message: message, bodyText: text, creatorUsername: targetUsername, responsiveTime: feedCreatedDateString)
                            
                            return cell
                        }
                    }
                }else if let target = feedItem.target as? Photo {
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: s_._FeedPhotoTVC, for: indexPath) as? FeedPhotoTVC {
                        
                        if let feedCreatedDate = feedItem.createdDate, let message = feedItem.message, let targetUsername = target.creator?.username, let imageURL = target.imageURL {
                            
                            let feedCreatedDateString = ThreadsData.getCurrentDateString(date: feedCreatedDate)
                            cell.configure(message: message, imageURL: imageURL, creatorUsername: targetUsername, responsiveTime: feedCreatedDateString)
                            
                            return cell
                        }
                    }
                }
            }
            
            let cell = UITableViewCell()
            cell.backgroundColor = .blue
            return cell
            
        }else if indexPath.section == frcCount {
            if let cell = tableView.dequeueReusableCell(withIdentifier: s_._TypicalTVCell, for: indexPath) as? TypicalTVCell {
                
                cell.configure(mainLabel: s_._Load_More)
                return cell
            }
        }
    
        return UITableViewCell()
    }
    
    
    @objc private func userFollowStateButtonTapped(sender: UIButton) {
        
        guard let sectionInString = sender.accessibilityIdentifier else {
            return
        }
        
        guard let section = Int(sectionInString) else {
            return
        }
        
        let row = sender.tag
        
        if let user = frc?.sections?[section].objects?[row] as? User {
            guard let selectedUserStructure = user.createStructure() else {
                return
            }
            
            guard let employedBy = self.manager?.employedBy else {
                return
            }
            
            guard let senderTitle = sender.titleLabel?.text else {
                return
            }
            
            let manager = UserProfileManager(employedBy: employedBy, selectedUserStructure: selectedUserStructure)
           
            handleFollowState(senderTitle: senderTitle, manager: manager, completion: { (feedback, followState) in
                sender.setTitle(followState.rawValue, for: .normal)
            })
        }
    }
}


