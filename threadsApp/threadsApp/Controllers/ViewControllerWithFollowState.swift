//
//  CoreViewControllerWithFollowState.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 8/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class ViewControllerWithFollowState: ViewController {

    /*
    //Need to test...
    internal func handleFollowState(with followStateAssistant: FollowStateAssistantProtocol, senderTitle: String, completion: @escaping (UserStructure.FollowState?) -> Void){
        
        let strings = Constants.sharedInstance
        var message: String?
        var initialFollowState: UserStructure.FollowState = .follow
        
        switch senderTitle {
        case strings._Following:
            //1 ask if user is sure of un following
            message = "Are you sure you want to unfollow user?"
            initialFollowState = .following
            break
        case strings._Pending:
            message = "Make a decision."
            initialFollowState = .pending
            break
        case strings._Requested:
            message = "Withdraw request?."
            initialFollowState = .requested
            break
        default:
            break
        }
        
        if let message = message {
            let alertController = UIAlertController(title: strings._Warning, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: strings._Cancel, style: .cancel, handler: { (alert) in
                completion(initialFollowState)
                alertController.dismiss(animated: true, completion: nil)
            })
            
            switch senderTitle {
                
            case strings._Following:
                //1 ask if user is sure of un following
                let unFollowAction = UIAlertAction(title: strings._Un_Follow, style: .default, handler: { (alert) in
                    followStateAssistant.initiateUnFollow(completion: { (followState) in
                        completion(followState)
                        alertController.dismiss(animated: true, completion: nil)
                    })
                })
                
                alertController.addAction(unFollowAction)
                break
            case strings._Pending:
                let acceptPendingAction = UIAlertAction(title: strings._Accept_Pending, style: .default, handler: { (alert) in
                    followStateAssistant.initiateAcceptPending(completion: { (followState) in
                        completion(followState)
                        alertController.dismiss(animated: true, completion: nil)
                    })
                })
                
                let cancelPendingAction = UIAlertAction(title: strings._Cancel_Pending, style: .default, handler: { (alert) in
                    followStateAssistant.initiateCancelPending(completion: { (followState) in
                        completion(followState)
                        alertController.dismiss(animated: true, completion: nil)
                    })
                })
                
                alertController.addAction(acceptPendingAction)
                alertController.addAction(cancelPendingAction)
                break
            case strings._Requested:
                let withdrawAction = UIAlertAction(title: strings._Withdraw, style: .default, handler: { (alert) in
                    followStateAssistant.initiateAcceptPending(completion: { (followState) in
                        completion(followState)
                        alertController.dismiss(animated: true, completion: nil)
                    })
                })
                alertController.addAction(withdrawAction)
                break
            default:
                return
            }
            
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: {
                self.view.isUserInteractionEnabled = false
            })
            
        }else {
            
            if senderTitle == strings._Follow {
                followStateAssistant.initiateFollow(completion: { (followState) in
                    completion(followState)
                    return
                })
                
            }
            
        }
    }
*/
}
