//
//  MainViewModel.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation

protocol MainExpenseViewModelDelegate: AnyObject {
    func didFinishWithSuccess()
    func didFail(message: String?)
    func didSignout()
}

class MainExpenseViewModel {
    
    private var data: [AccountModel] = []
    let authBusinessModel: LoginProtocol
    let expenseBusinessModel: AccountRepositoryProtocol
    weak var delegate: MainExpenseViewModelDelegate?
    
    var tableViewNumberOfLines: Int {
        return self.data.count
    }
    
    init(authBusinessModel: LoginProtocol = LoginBusinessModel(),
         expenseBusinessModel: AccountRepositoryProtocol = ExpenseBusinessModel()){
        
        self.authBusinessModel = authBusinessModel
        self.expenseBusinessModel = expenseBusinessModel
        
    }
    
    func logout() {
        
        self.authBusinessModel.fetchCoreDataLoggedUser()
        self.authBusinessModel.logout { [weak self] result in
            switch result{
                
            case .success():
                self?.delegate?.didSignout()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
            
        }
    }
    
    func getTableViewCellViewModel(from indexPath: IndexPath) -> MyTableAccountViewCellViewModel? {
        
        if(indexPath.row > data.count){
            return nil
        }
        
        let model = data[indexPath.row]
        
        return MyTableAccountViewCellViewModel(accountModel: model)
        
    }
    
    func getData(from indexPath: IndexPath) -> AccountModel? {
        
        let model = data[indexPath.row]
        
        return AccountModel(documentID: model.documentID, value: model.value, description: model.description, date: model.date, paid: model.paid, isExpense: model.isExpense, isIncome: model.isIncome)
        
    }
    
    func deleteData(from indexPath: IndexPath) {
        data.remove(at: indexPath.row)
    }
    
    func listExpense() {
        self.expenseBusinessModel.list { [weak self] result in
            
            switch result{
                
            case .success(let objects):
                
                for object in objects {
                    
                    if let hasObject = self?.data.contains(where: { $0.documentID == object.documentID }), !hasObject {
                        self?.data.append(object)
                    }
                    
                    if let indice = self?.data.firstIndex(where: { $0.documentID == object.documentID }) {
                        
                        self?.data[indice].value = object.value;
                        self?.data[indice].description = object.description;
                        self?.data[indice].date = object.date;
                        self?.data[indice].paid = object.paid
                        
                    }
                    
                }
                
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
                
            }
        }
    }
    
    func deleteExpense(object: AccountModel) {
        
        self.expenseBusinessModel.delete(object: object) { [weak self] result in
            
            switch result{
                
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
    
}
