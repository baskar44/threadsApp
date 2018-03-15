//
//  LoginVC+ext+TableView.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 4/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase

extension LoginVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension LoginVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDisplay.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplay[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowDisplay = tableViewDisplay[indexPath.section][indexPath.row]
        let strings = Constants.sharedInstance
        
        
        if rowDisplay == .loginButton {
            if let cell = tableView.dequeueReusableCell(withIdentifier: strings._ButtonTVC, for: indexPath) as? ButtonTVC {
                cell.cellButton.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
                cell.configure(buttonTitle: strings._Login)
                return cell
            }
        }else if rowDisplay == .email || rowDisplay == .password {
            if let cell = tableView.dequeueReusableCell(withIdentifier: strings._TextFieldTVC, for: indexPath) as? TextFieldTVC {
                
                if indexPath.row == 0 {
                    emailTextField = cell.textField
                    cell.textField.becomeFirstResponder()
                    cell.configure(textFieldText: strings._emptyString, headingLabelText: strings._Email)
                }else if indexPath.row == 1 {
                    passwordTextField = cell.textField
                    cell.configure(textFieldText: strings._emptyString, headingLabelText: strings._Password)
                }else {
                    return UITableViewCell()
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    //MARK:- Button Handle Functions
    
    /// Function is triggered when 'Login' is called.
    //need to create a login assistant //todo
    @objc private func handleLoginButtonTapped() {
        let loginAssistant = LoginAssistant(email: emailTextField, password: passwordTextField)
       
        loginAssistant.login { (failedType) in
            if failedType == nil {
                self.navigationController?.popToRootViewController(animated: true)
            }else {
                self.loadLocalAlertController(failedType: failedType)
            }
            
            self.view.isUserInteractionEnabled = true
            return
        }
    }
}


