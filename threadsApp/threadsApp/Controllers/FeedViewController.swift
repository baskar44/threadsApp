//
//  FeedViewController.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 14/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getCurrentUser { (user) in
            
            guard let userStructure = user?.createStructure() else {
                return
            }
            
            let threadsData = ThreadsData.sharedInstance
            
            let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: userStructure, employedBy: userStructure, listType: User.ListType.feed)
            
            if let listManager = listManagerWithFeedback.0 {
                listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                    if feedback == .successful {
                        let feedListVC = UserListVC(manager: listManager)
                        self.navigationController?.pushViewController(feedListVC, animated: true)
                    }else {
                        //error handle
                    }
                })
                
                listManager.observe(action: .remove, toFirst: nil, completion: { (feedback, error) in
                    if feedback == .successful {
                    }else {
                        //error handle
                    }
                })
                
            }else {
                //error handle
            }
        }
    }
    
    
    func getCurrentUser(completion: @escaping (User?) -> Void){
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let context = ThreadsData.sharedInstance.container?.viewContext else {
            return
        }
        
        User.get(userId: userId, context: context, strings: Constants.sharedInstance) { (user, error) in
            if let user = user.0 {
                completion(user)
            }else {
                completion(nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
