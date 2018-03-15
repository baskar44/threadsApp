//
//  UILabel+ext.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 2/11/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

enum LabelType {
    case mainHeading
    case subHeading
    case contentText
    case mainHeadingOnCell
    case subHeadingOnCell
    case contentTextOnCell
    case sideSubHeading
}

extension UILabel {
    
    func setTo(labelType: LabelType){
   
        switch labelType {
        case .mainHeading:
            textColor = .black
            font = UIFont.boldSystemFont(ofSize: 28)
            break
        case .subHeading:
            textColor = .black
            font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)
            break
        case .contentText:
            textColor = .black
            font = UIFont.systemFont(ofSize: 18)
            break
        case .mainHeadingOnCell:
            font = UIFont.boldSystemFont(ofSize: 14)
            break
        case .subHeadingOnCell:
            textColor = .black
            font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
            break
        case .contentTextOnCell:
            textColor = .darkGray
            font = UIFont.systemFont(ofSize: 13)
            break
        case .sideSubHeading:
            textColor = .darkGray
            font = UIFont.systemFont(ofSize: 12)
            break
            
        }
    }
    
}
