//
//  TabViewController+extension.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension UITabBar {
    /// Function will setup the tab bar controller and tab bar for the view controller. The parameters will ensure all the required attributes are set for the tab bar controller.
    
    /// - Parameter tabBarController: The selected tab bar controller
    /// - Parameter accessibilityIdentifier: The accessibility identifier for the tab bar controller. (Used for testing purposes.)
    /// - Parameter backgroundColor: Background color of the tab bar controller.
    
    func setup(accessibilityIdenfitier: String, isHidden: Bool, backgroundColor: UIColor?) {
        self.isHidden = isHidden
        self.accessibilityIdentifier = accessibilityIdenfitier
        self.backgroundColor = backgroundColor
    }
}
