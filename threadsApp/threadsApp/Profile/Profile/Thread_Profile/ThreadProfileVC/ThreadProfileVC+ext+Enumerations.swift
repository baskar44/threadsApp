//
//  ThreadProfileVC+ext+SubViews.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension ThreadProfileVC {
   
    internal enum ThreadAccessLevel: String {
        case moderator = "Moderator"
        case full = "Full"
        case noAccess = "No Access"
        case failed = "Failed"
        case creator = "Creator"
    }
}

