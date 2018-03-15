//
//  CreateMediaVC+ext+Enumerations.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 21/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension NotepadVC {
    
    enum SaveFeedback: String {
        case requiredFieldsAreEmpty = "One more required fields is empty."
        case requiredFieldsAreAboveAllowedWordCount = "One more fields has more words than allowed."
    }
    

}
