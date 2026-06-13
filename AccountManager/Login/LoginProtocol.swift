//
//  LoginProtocol.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation

protocol LoginProtocol{    
    func login(credentials: LoginCredentials, completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    func logout(completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    func fetchCoreDataLoggedUser()
    func saveUserCoreData(email: String, password: String)
}

struct LoginCredentials {
    let email: String
    let password: String
}

struct User {
    let email: String
}

enum AccountManagerError: Error {
    case auth
    case badRequest
    case signout
            
    func getMessage() -> String?{
        
        switch self {
        case .auth:
            return "Email ou senha incorreta!"
            
        case .badRequest:
            return "Erro na requisição."
        
        case .signout:
            return "Erro ao tentar deslogar."
        }
    }
}


