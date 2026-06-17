//
//  ExpenseViewModel.swift
//  AccountManager
//
//  Created by Ytallo on 01/08/21.
//

import Foundation

protocol ExpenseViewModelDelegate: AnyObject {
    func didFinishWithSuccess()
    func didFinishWithError(message: String?)
}

class ExpenseViewModel {
    
    let expenseBusinessModel: AccountRepositoryProtocol
    weak var delegate: ExpenseViewModelDelegate?
    
    init(expenseBusinessModel: AccountRepositoryProtocol = ExpenseBusinessModel()) {
        self.expenseBusinessModel = expenseBusinessModel
    }
    
    func create(object: AccountModel) {
        
        self.expenseBusinessModel.create(object: object) { [weak self] result in
            
            switch result{
            
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFinishWithError(message: error.getMessage())
            }
        }
    }
        
    func update(object: AccountModel) {
        
        self.expenseBusinessModel.update(object: object) { [weak self] result in
            
            switch result{
            
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFinishWithError(message: error.getMessage())
            }
        }
    }
    
}
