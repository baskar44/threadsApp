//
//  ThreadProfileVC+ext+SubViews.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 5/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation

extension ThreadProfileVC {
    //MARK:- Functions to set sub views
    internal func setupSegmentedControl(){
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: s_._Photos, at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: s_._Film, at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: s_._Audio, at: 2, animated: false)
        
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
    }
    
    func setupThreadTitleLabel(text: String){
        threadTitleLabel.text = text
    }
    
    func setupThreadAboutLabel(text: String){
        aboutLabel.text = text
    }
    
    func setupAboutLabel(text: String){
        aboutLabel.text = text
    }
    
    func setupCreatedDateString(text: String) {
        createdDateLabel.text = text
    }
    
    func setupThreadInformationView(manager: ThreadProfileManager){
        threadInformationView.layoutIfNeeded()
        threadInformationView.layer.cornerRadius = 12
        
        let constant = aboutLabel.frame.maxY + 16
        
        if constant < 120 {
            threadInformationViewHeight.constant = 120
        }else {
            threadInformationViewHeight.constant = constant
        }
        
        threadInformationEditIcon.layer.cornerRadius = threadInformationEditIcon.frame.width/2
        threadInformationEditIcon.addTarget(self, action: #selector(editThreadButtonTapped), for: .touchUpInside)
    }
    
}
