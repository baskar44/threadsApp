//
//  CreateUserFailedType.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 13/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

extension CreateUserVC {
    internal enum CreateUserFailedType: String {
        case invalidRequiredFields = "One or more required fields are empty."
        case passwordMismatch = "Passwords don't match."
        case failedToLoadTextFieldUI = "Failed to load TextField UIs"
        case failedToRegister = "Failed to register"
    }
}


