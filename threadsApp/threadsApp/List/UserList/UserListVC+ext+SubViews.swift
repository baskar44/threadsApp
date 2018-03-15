//
//  UserListVC+ext+SubViews.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 31/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension UserListVC {
    
    //TEST
    //fetching the frc for the listVC
    //The function is dependent on the list manager and the selectedSegmentIndex
    //returns a feedback
    func fetchFRC(manager: UserListManager) -> Feedback {
        
        let fetch = manager.getFRC(selectedSegmentIndex: segmentedControl.selectedSegmentIndex)
        let frc = fetch.0
        
        if frc == nil {
            return fetch.1
        }else {
            self.frc = frc
            self.frc?.delegate = self
            tableView.reloadData()
            
            return .successful
        }
    }
   
    //testable
    func setupSegmentControl(listType: User.ListType) -> Bool {
        
        segmentedControl.removeAllSegments()

        if listType == .followers || listType == .following || listType == .requested || listType == .pending || listType == .feed || listType == .journal {
            segmentedControl.removeAllSegments()
        }else {
            segmentedControl.insertSegment(withTitle: "Alphabetical", at: 0, animated: false)
            segmentedControl.insertSegment(withTitle: "Date", at: 1, animated: false)
            segmentedControl.selectedSegmentIndex = 0
        }
       
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(handleChangeInSegment), for: .valueChanged)
        
        return true

    }
    
    @objc private func handleChangeInSegment(){
        
        guard let manager = manager else {
            return
        }
        
        let feedback = fetchFRC(manager: manager)
        
    }

}
