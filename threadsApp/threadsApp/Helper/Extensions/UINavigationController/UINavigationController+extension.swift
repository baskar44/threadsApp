//
//  NavigationController+extension.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setup(accessibilityIdenfitier: String, backgroundColor: UIColor?, barTintColor: UIColor? = nil, prefersLargeTitles: Bool) {
        
        self.accessibilityIdentifier = accessibilityIdenfitier
        self.backgroundColor = backgroundColor
        self.barTintColor = barTintColor
        self.prefersLargeTitles = prefersLargeTitles
    }
}

extension UINavigationController {
    func setup(isNavigationBarHidden: Bool) {
        self.isNavigationBarHidden = isNavigationBarHidden
    }
}
extension UINavigationItem {
    func setup(title: String?, rightBarButtonItems: [UIBarButtonItem]? = nil, leftBarButtonItems: [UIBarButtonItem]? = nil) -> Bool {
        
        var titleVariable: String?
        
        if let title = title  {
            titleVariable = title
            
            if let rightBarButtonItems = rightBarButtonItems {
                self.rightBarButtonItems = []
                for item in rightBarButtonItems {
                    self.rightBarButtonItems?.append(item)
                }
            }
            
            if let leftBarButtonItems = leftBarButtonItems {
                self.leftBarButtonItems = []
                for item in leftBarButtonItems {
                    self.leftBarButtonItems?.append(item)
                }
            }
        }else {
            titleVariable = Constants.sharedInstance._emptyString
        }
        
        
        guard let title = titleVariable else {
            return false
        }
        
        self.title = title
        return true
    }
}


extension UINavigationController {
    
    /// Function will setup the navigation controller, navigation bar and navigation item for the view controller. The parameters will ensure all the required attributes are set for the navigation controller.
    /// Should be placed in the run() function in the view controller. (Best practise).
    /// - Parameter navigationController: The selected navigation controller.
    /// - Parameter accessibilityIdenfitier: The accessibility identifier for the navigation bar. (Used for testing purposes.)
    /// - Parameter title: Title for the navigation item.
    /// - Parameter isNavigationBarHidden: Show or hide the navigation bar.
    /// - Parameter backgroundColor: Background color of the navigation bar.
    /// - Parameter prefersLargeTitles: Preference of large title display.
    /// - Parameter rightBarButtonItems: Bar button items will be added to the navigation item's rightBarButtonItems array.
    /// - Parameter leftBarButtonItems: Bar button items will be added to the navigation item's leftBarButtonItems array.
    /// - Parameter titleView: Any required view can be added to the navigation item's title view. UISegmentController mainly uses this option in this application.
    
    func setup(accessibilityIdenfitier: String, title: String?, isNavigationBarHidden: Bool, backgroundColor: UIColor?, backgroundImage: UIImage? = nil, prefersLargeTitles: Bool) {
        
       
        self.isNavigationBarHidden = isNavigationBarHidden
        
        if backgroundColor != nil {
           navigationBar.backgroundColor = backgroundColor
        }
        
        navigationBar.barTintColor = nil
        
        if title != nil {
           navigationItem.title = title
        }
        
        navigationBar.prefersLargeTitles = prefersLargeTitles
       
    }
    
    func setupBackButtonButtonItem(navigationItem: UINavigationItem){
        let hidesBackButton = navigationItemHidesBackButton()
        
        switch hidesBackButton {
        case .failed:
            navigationItem.leftBarButtonItems = []
            navigationItem.leftBarButtonItems?.append(UIBarButtonItem(title: Constants.sharedInstance._Failed, style: .plain, target: self, action: nil))
            break
        case .hidden:
            navigationItem.hidesBackButton = true
            break
        case .isNotHidden:
            navigationItem.hidesBackButton = false
            break
        }
    }
    
    private enum HidesBackButton {
        case hidden
        case isNotHidden
        case failed
    }
    
    private func navigationItemHidesBackButton() -> HidesBackButton {
        
        let noOfNavigationControllers = viewControllers.count
        
        let indexOfCurrentNavigationController = ((noOfNavigationControllers) - 1)
        
        if indexOfCurrentNavigationController == 1 {
            
            return .hidden
        }
        
        return .isNotHidden
    }
    
}
