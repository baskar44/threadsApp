
//
//  MainTabBarController.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 16/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var currentUserStructure: UserStructure?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.viewControllers?.removeAll()
    }
}
