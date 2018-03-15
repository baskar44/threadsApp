//
//  CreateUserVC+ext+TableView.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension CreateUserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 90
        }else {
            return 90
        }
    }
}

extension CreateUserVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDisplay.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplay[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowType = tableViewDisplay[indexPath.section][indexPath.row]
        let strings = Constants.sharedInstance
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: strings._TextFieldTVC, for: indexPath) as? TextFieldTVC {
            
            switch rowType {
            case .confirmPassword:
                confirmPasswordTextField = cell.textField
                break
            case .email:
                emailTextField = cell.textField
                break
            case .password:
                passwordTextField = cell.textField
                break
            case .username:
                usernameTextField = cell.textField
                break
            }
            
            cell.configure(textFieldText: strings._emptyString, headingLabelText: rowType.rawValue)
            return cell
        }
        
        return UITableViewCell()
    }
    
}
