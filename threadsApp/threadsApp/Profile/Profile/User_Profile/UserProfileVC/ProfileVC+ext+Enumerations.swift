//
//  ProfileVC+ext+Enumerations.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 7/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension ProfileVC {
    
    internal enum TableViewRowDisplay: String {
        case threads = "Threads"
        case feed = "Feed"
        case following = "Following"
        case followers = "Followers"
        case noAccess = "No Access"
        case block = "Block"
        case instances = "Instances"
        case report = "Report"
        case signOut = "Sign Out"
        case edit = "Edit"
        case followState = "Follow State"
    }
    
    internal enum ProfileVCFeedback: String {
        case successfullySetFollowStateTitle = "Follow state title did get set."
        case failedToRetrieveFollowStateButtonTitle = "Failed to retrieve follow state button title"
        case dataLoaderFailedWhileRetrievingObjects = "Data Loader failed"
        case dataLoaderFailedWhileRetrievingObjectsWithError = "Data Loader failed with error"
        case didLoadProfileImageURL = "Profile image url loaded successfully."
        case failedToLoadProfileImageURLWithErr = "Profile image load url failed with error(s)"
        case failedToLoadProfileImageURL = "Profile image load url failed with NO error(s)"
    }
    
    
}
