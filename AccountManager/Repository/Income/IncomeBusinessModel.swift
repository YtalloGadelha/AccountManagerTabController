//
//  IncomeRepository.swift
//  AccountManager
//
//  Created by Ytallo on 27/05/26.
//

import Foundation
import FirebaseFirestore

class IncomeBusinessModel: IncomeRepositoryProtocol {
    
    func list(completion: @escaping (Result<[AccountModel], AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("incomes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Erro ao buscar as receitas: \(err)")
                completion(.failure(.badRequest))
            } else {
                
                let objects = querySnapshot?.documents.compactMap({ snapshot in
                    
                    let value = snapshot.data()["value"] as? Double
                    let date = (snapshot.data()["date"] as? Timestamp)?.dateValue()
                    let paid = snapshot.data()["paid"] as? Bool
                    let description = snapshot.data()["description"] as? String
                    let isExpense = snapshot.data()["isExpense"] as? Bool
                    let isIncome = snapshot.data()["isIncome"] as? Bool
                    
                    return AccountModel(documentID: snapshot.documentID, value: value ?? 0, description: description ?? "", date: date ?? Date(), paid: paid ?? false, isExpense: isExpense ?? false, isIncome: isIncome ?? true)
                    
                }) ?? []
                
                completion(.success(objects as? [AccountModel] ?? []))
            }
            
        }
        
    }
    
    func delete(object: AccountModel, completion: @escaping (Result<Void, AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("incomes").document(object.documentID).delete() { err in
            if let err = err {
                print("Erro: \(err)")
                completion(.failure(.badRequest))
            } else {
                print("Removido com sucesso!")
                completion(.success(()))
            }
        }
        
    }
    
    func update(object: AccountModel, completion: @escaping (Result<Void, AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("incomes").document(object.documentID).updateData( [
        
            "value": object.value,
            "date": object.date,
            "paid": object.paid,
            "description": object.description,
            "isExpense": object.isExpense,
            "isIncome": object.isIncome
            
        ]) { err in
            if let err = err {
                print("Error: \(err)")
                completion(.failure(.badRequest))
            } else {
                print("Atualizado com sucesso")
                completion(.success(()))
            }
        }
        
    }
    
    func create(object: AccountModel, completion: @escaping (Result<Void, AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        ref = db.collection("incomes").addDocument(data: [
            "value": object.value,
            "date": object.date,
            "paid": object.paid,
            "description": object.description,
            "isExpense": object.isExpense,
            "isIncome": object.isIncome
            
        ]) { err in
            if let err = err {
                print("Error: \(err)")
                completion(.failure(.badRequest))
            } else {
                print("Adição finalizado com ID: \(ref!.documentID)")
                completion(.success(()))
            }
        }
    }
}
