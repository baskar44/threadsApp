//
//  BodyTemplate.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 1/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation

struct BodyTemplate: BodyTemplateProtocol {
    private var _id: String
    var id: String {
        return _id
    }
    
    private var _bodyText: String
    var bodyText: String {
        return _bodyText
    }
    
    private var _bodyTitle: String
    var bodyTitle: String {
        return _bodyTitle
    }
    
    private var _createdDate: Date
    var createdDate: Date {
        return _createdDate
    }
    
    private var _createdBy: String
    var createdBy: String {
        return _createdBy
    }
    
    private var _parentKey: String
    var parentKey: String {
        return _parentKey
    }
    
    private var _visibility: Bool
    var visibility: Bool {
        return _visibility
    }
    
    init(id: String, bodyText: String, bodyTitle: String, createdDate: Date, createdBy: String, parentKey: String, visibility: Bool) {
        _id = id
        _bodyTitle = bodyTitle
        _bodyText = bodyText
        _createdDate = createdDate
        _createdBy = createdBy
        _parentKey = parentKey
        _visibility = visibility
    }
}

struct MockBodyTemplate: BodyTemplateProtocol {
    var bodyText: String
    var bodyTitle: String
    var createdDate: Date
    var createdBy: String
    var parentKey: String
    var id: String
    var visibility: Bool
}

protocol BodyTemplateProtocol {
    var id: String {get}
    var bodyText: String {get}
    var bodyTitle: String {get}
    var createdDate: Date {get}
    var createdBy: String {get}
    var parentKey: String {get}
    var visibility: Bool {get}
    
}
