//
//  UserProfileManager.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation

struct UserProfileManager {
    
    private var _employedBy: UserStructureProtocol
    private var _selectedUserStructure: UserStructureProtocol

    var selectedUserStructure: UserStructureProtocol {
        return _selectedUserStructure
    }
    
    var employedBy: UserStructureProtocol {
        return _employedBy
    }
    
    init(employedBy: UserStructureProtocol, selectedUserStructure: UserStructureProtocol) {
        _employedBy = employedBy
        _selectedUserStructure = selectedUserStructure
    }
    
    //testable
    func getUserAccessLevel(completion: @escaping (ViewController.UserAccessLevel) -> Void) {
        
        if _employedBy.id == _selectedUserStructure.id {
            completion(.current)
            return
        }else {
            _employedBy.checkIfFollowing(userId: _selectedUserStructure.id, completion: { (isFollowing) in
                if isFollowing {
                    completion(.full)
                }else {
                    if self._selectedUserStructure.visibility {
                        completion(.full)
                    }else {
                        completion(.noAccess)
                    }
                }
                return
            })
        }
    }
    
    //
    func getFollowState(completion: @escaping (UserStructure.FollowState) -> Void) {
        if _employedBy.id == _selectedUserStructure.id {
            completion(.current)
            return
        }else {
            _employedBy.checkIfPending(userId: _selectedUserStructure.id, completion: { (isPending) in
                if isPending {
                    completion(.pending)
                    return
                }else {
                    
                    self._employedBy.checkIfFollowing(userId: self._selectedUserStructure.id, completion: { (isFollowing) in
                        if isFollowing {
                            completion(.following)
                            return
                        }else {
                            
                            self._employedBy.checkIfRequested(userId: self._selectedUserStructure.id, completion: { (isRequested) in
                                if isRequested {
                                    completion(.requested)
                                }else {
                                    completion(.follow)
                                }
                                
                                return
                            })
                        }
                    })
                }
            })
        }
    }
    
    func initiateFollow(completion: @escaping (Feedback, UserStructure.FollowState) -> Void) {
        
        employedBy.follow(selectedUserStructure: selectedUserStructure) { (feedback, error) in
            self.getFollowState(completion: { (followState) in
                completion(feedback, followState)
                return
            })
        }
    }
    
    func initiateUnFollow(completion: @escaping (Feedback, UserStructure.FollowState) -> Void) {
        
        employedBy.unfollow(selectedUserStructure: selectedUserStructure) { (feedback, error) in
            if feedback == .successful {
                completion(feedback, .follow)
            }else {
                completion(feedback, .following)
            }
            
            return
        }
    }
    
    func initiateAcceptPending(completion: @escaping (Feedback, UserStructure.FollowState) -> Void){
        
        employedBy.acceptPending(selectedUserStructure: selectedUserStructure) { (feedback, error) in
            if feedback == .successful {
                self.getFollowState(completion: { (followState) in
                    completion(feedback, followState)
                    return
                })
            }else {
                completion(feedback, .pending)
                return
            }
            
            
        }
    }
    
    func initiateCancelPending(completion: @escaping (Feedback, UserStructure.FollowState) -> Void){
        
        employedBy.cancelPending(selectedUserStructure: selectedUserStructure) { (feedback, error) in
            if feedback == .successful {
                self.getFollowState(completion: { (followState) in
                    completion(feedback, followState)
                    return
                })
            }else {
                completion(feedback, .pending)
                return
            }
        }
    }
    
    func initiateWithdrawRequest(completion: @escaping (Feedback, UserStructure.FollowState) -> Void){
        
        employedBy.withdrawRequest(selectedUserStructure: selectedUserStructure) { (feedback, error) in
            if feedback == .successful {
                completion(feedback, .follow)
            }else {
                completion(feedback, .requested)
            }
            
            return
        }
    }
}
