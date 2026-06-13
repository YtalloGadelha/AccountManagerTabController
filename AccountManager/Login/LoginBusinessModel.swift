//
//  LoginBusinessModel.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation
import FirebaseAuth
import CoreData

fileprivate var globalUser: User? = nil
fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
fileprivate var context: NSManagedObjectContext!
fileprivate var loggedUser: [NSManagedObject] = []

class LoginBusinessModel: LoginProtocol {
    
    static func isLogged() -> Bool{
        
        if loggedUser.isEmpty {
            return false
        }
        
        return true
        
    }
    
    func login(credentials: LoginCredentials, completion: @escaping(Result<Void, AccountManagerError>) -> Void) {
        //Autenticar usuário no Firebase
        let autenticacao = Auth.auth()
        autenticacao.signIn(withEmail: credentials.email, password: credentials.password, completion: { (user, error) in
            
            if error == nil {
                
                if let email = user?.user.email {
                    
                    globalUser = User(email: email)
                    completion(.success(()))
                    
                }else{
                    globalUser = nil
                    completion(.failure(.auth))
                }
                
            }else{
                globalUser = nil
                completion(.failure(.auth))
            }
        })
    }
    
    func logout(completion: @escaping(Result<Void, AccountManagerError>) -> Void) {
        
        let firebaseAuth = Auth.auth()
        
        context = appDelegate.persistentContainer.viewContext
        
        do {
            try firebaseAuth.signOut()
            globalUser = nil
            
            if !loggedUser.isEmpty, let usuario = loggedUser.first {
                context.delete(usuario)
                loggedUser = []
            }
            
            do{
                try context.save()
                
            }catch let erro as NSError{
                print("Erro ao remover dado no coredata: \(erro)")
                
            }
            
            completion(.success(()))
        } catch {
            completion(.failure(.signout))
        }
    }
    
    func fetchCoreDataLoggedUser(){
        
        context = appDelegate.persistentContainer.viewContext
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCoreData")
        
        do {
            
            let recoveredUser = try context.fetch(requisicao)
            loggedUser = recoveredUser as! [NSManagedObject]
            
        } catch let erro {
            print("Erro ao recuperar do usuario: \(erro.localizedDescription)")
        }
        
    }
    
    func saveUserCoreData(email: String, password: String) {
        
        //cria objeto no coredata
        let userCoreData = NSEntityDescription.insertNewObject(forEntityName: "UserCoreData", into: context)
        
        //configura, no core data, o usuário logado
        userCoreData.setValue(email, forKey: "email")
        userCoreData.setValue(password, forKey: "password")
        
        do {
            try context.save()
            print("Sucesso ao salvar usuário logado!")
        } catch let erro {
            print("Erro ao salvar usuário logado: \(erro.localizedDescription)")
        }
        
    }
    
}
