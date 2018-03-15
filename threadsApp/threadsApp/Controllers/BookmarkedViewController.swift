//
//  BookmarkedViewController.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 14/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase

class BookmarkedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        // Do any additional setup after loading the view.
    }
    
    private func setupTableView(){
        let accessibilityIdentifier = Constants.sharedInstance._ProfileVC
        let backgroundColor = UIColor.white
        
        let register: [TableViewCellType] = [.typical]
        
        tableView.setup(accessibilityIdentifier: accessibilityIdentifier, delegate: self, dataSource: self, backgroundColor: backgroundColor, register: register)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getCurrentUser { (user) in
            
            guard let userStructure = user?.createStructure() else {
                return
            }
            
            let threadsData = ThreadsData.sharedInstance
            
             let listTypes: [User.ListType] = [.bookmarkedBody, .bookmarkedThreads, .bookmarkedAudio, .bookmarkedPhotos, .bookmarkedVideo]
            
            for type in listTypes {
                let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: userStructure, employedBy: userStructure, listType: type)
                
                if let listManager = listManagerWithFeedback.0 {
                    listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                        if feedback == .successful {
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

}

extension BookmarkedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let threadsData = ThreadsData.sharedInstance
        
        getCurrentUser { (user) in
            if let userStructure = user?.createStructure() {
                switch indexPath.row {
                case 0:
                    //threads
                    
                    let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: userStructure, employedBy: userStructure, listType: .bookmarkedThreads)
                    
                    if let listManager = listManagerWithFeedback.0 {
                        listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                            if feedback == .successful {
                                let userListVC = UserListVC(manager: listManager)
                                self.navigationController?.pushViewController(userListVC, animated: true)
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
                    break
                case 1:
                    
                    //bodies
                    let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: userStructure, employedBy: userStructure, listType: .bookmarkedBody)
                    
                    if let listManager = listManagerWithFeedback.0 {
          
                        listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                            if feedback == .successful {
                               
                                let userListVC = UserListVC(manager: listManager)
                                self.navigationController?.pushViewController(userListVC, animated: true)
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
                    break
                case 2:
                    let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: userStructure, employedBy: userStructure, listType: .bookmarkedPhotos)
                    
                    if let listManager = listManagerWithFeedback.0 {
                        listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                            if feedback == .successful {
                                let userListVC = UserListVC(manager: listManager)
                                self.navigationController?.pushViewController(userListVC, animated: true)
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
                    //photos
                    break
                case 3:
                    let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: userStructure, employedBy: userStructure, listType: .bookmarkedVideo)
                    
                    if let listManager = listManagerWithFeedback.0 {
                        listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                            if feedback == .successful {
                                let userListVC = UserListVC(manager: listManager)
                                self.navigationController?.pushViewController(userListVC, animated: true)
                            }else {
                                //error handle
                            }
                        })
                        
                        listManager.observe(action: .remove, toFirst: nil, completion: { (feedback, error) in
                            if feedback == .successful {
                                let userListVC = UserListVC(manager: listManager)
                                self.navigationController?.pushViewController(userListVC, animated: true)
                            }else {
                                
                            }
                        })
                        
                    }else {
                        //error handle
                    }
                    //videos
                    break
                case 4:
                    //audio
                    let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: userStructure, employedBy: userStructure, listType: .bookmarkedAudio)
                    
                    if let listManager = listManagerWithFeedback.0 {
                        listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                            if feedback == .successful {
                                let userListVC = UserListVC(manager: listManager)
                                self.navigationController?.pushViewController(userListVC, animated: true)
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
                    break
                default:
                    return
                }
            }
        }
        
        
    }
}

extension BookmarkedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sharedInstance._TypicalTVCell, for: indexPath) as? TypicalTVCell {
            
            let strings = Constants.sharedInstance
            var mainLabel: String?
            
            switch indexPath.row {
            case 0:
                mainLabel = strings._Bookmarked_Threads
                break
            case 1:
                mainLabel = strings._Bookmarked_Bodies
                break
            case 2:
                mainLabel = strings._Bookmarked_Photos
                break
            case 3:
                mainLabel = strings._Bookmarked_Videos
                break
            case 4:
                mainLabel = strings._Bookmarked_Audio
                break
            default:
                break
            }
            
            if let mainLabel = mainLabel {
                cell.configure(mainLabel: mainLabel)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}
