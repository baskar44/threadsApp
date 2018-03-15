//
//  InstanceTemplate.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 2/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation

struct ThreadTemplate {
    
    private var _id: String
    var id: String {
        return _id
    }
    
    private var _title: String
    var title: String {
        return _title
    }
    
    private var _createdDate: Date
    var createdDate: Date {
        return _createdDate
    }
    
    private var _createdDateString: String
    var createdDateString: String {
        return _createdDateString
    }
    
    private var _visibility: Bool
    var visibility: Bool {
        return _visibility
    }

    private var _about: String
    var about: String {
        return _about
    }
    
    private var _createdBy: String
    var createdBy: String {
        return _createdBy
    }
   
    init(id: String, title:String, visibility: Bool, createdDate: Date, about: String, createdBy: String) {
        
        _id = id
        _title = title
        _visibility = visibility
        _createdDate = createdDate
        _createdBy = createdBy
        _about = about
       
        let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
        _createdDateString = createdDateString
    }
}
