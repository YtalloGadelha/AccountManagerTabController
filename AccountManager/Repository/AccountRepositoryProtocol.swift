//
//  ExpenseRepositoryProtocol.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation

protocol AccountRepositoryProtocol {
    
    func list(completion: @escaping(Result<[AccountModel], AccountManagerError>) -> Void)
    func delete(object: AccountModel, completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    func update(object: AccountModel, completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    func create(object: AccountModel, completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    
}
