//
//  LoginViewModel.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation
import CoreData

protocol LoginViewModelDelegate: AnyObject {
    func didFinishWithSuccess(email: String, password: String)
    func didFail(message: String?)
    func didFinishVerificationLoggedUser()
}

class LoginViewModel {
    
    private let businessModel: LoginProtocol
    weak var delegate: LoginViewModelDelegate?
    
    init(businessModel: LoginProtocol = LoginBusinessModel()) {
        self.businessModel = businessModel
    }
    
    func Login(email: String, password: String) {
        self.businessModel.login(credentials: LoginCredentials(email: email, password: password)) { [weak self] result in
            switch result {
                
            case .success(_):
                self?.delegate?.didFinishWithSuccess(email: email, password: password)
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
    
    func silentLogin() {
        
        self.businessModel.fetchCoreDataLoggedUser()
        
        if LoginBusinessModel.isLogged() {
            self.delegate?.didFinishVerificationLoggedUser()
        }
        
    }
    
    func saveUserCoreData(email: String, password: String){
        self.businessModel.saveUserCoreData(email: email, password: password)
    }
    
}
