//
//  ObjectStructureProtocol.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation

protocol ObjectStructureProtocol {
    var id: String {get}
    var visibility: Bool {get}
    var createdDate: Date {get}
}
