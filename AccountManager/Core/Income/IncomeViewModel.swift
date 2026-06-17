//
//  ExpenseViewModel.swift
//  AccountManager
//
//  Created by Ytallo on 27/05/26.
//

import Foundation

protocol IncomeViewModelDelegate: AnyObject {
    func didFinishWithSuccess()
    func didFinishWithError(message: String?)
}

class IncomeViewModel {
    
    let incomeBusinessModel: AccountRepositoryProtocol
    weak var delegate: IncomeViewModelDelegate?
    
    init(incomeBusinessModel: AccountRepositoryProtocol = IncomeBusinessModel()) {
        self.incomeBusinessModel = incomeBusinessModel
    }
    
    func create(object: AccountModel) {
        
        self.incomeBusinessModel.create(object: object) { [weak self] result in
            
            switch result{
            
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFinishWithError(message: error.getMessage())
            }
        }
    }
        
    func update(object: AccountModel) {
        
        self.incomeBusinessModel.update(object: object) { [weak self] result in
            
            switch result{
            
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFinishWithError(message: error.getMessage())
            }
        }
    }
    
}
