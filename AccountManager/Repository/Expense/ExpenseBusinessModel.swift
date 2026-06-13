//
//  ExpenseRepository.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation
import FirebaseFirestore

class ExpenseBusinessModel: ExpenseRepositoryProtocol {
    func list(completion: @escaping (Result<[AccountModel], AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("expenses").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Erro ao buscar as despesas: \(err)")
                completion(.failure(.badRequest))
            } else {
                
                let objects = querySnapshot?.documents.compactMap({ snapshot in
                    
                    let value = snapshot.data()["value"] as? Double
                    let date = (snapshot.data()["date"] as? Timestamp)?.dateValue()
                    let paid = snapshot.data()["paid"] as? Bool
                    let description = snapshot.data()["description"] as? String
                    let isExpense = snapshot.data()["isExpense"] as? Bool
                    let isIncome = snapshot.data()["isIncome"] as? Bool
                    
                    return AccountModel(documentID: snapshot.documentID, value: value ?? 0, description: description ?? "", date: date ?? Date(), paid: paid ?? false, isExpense: isExpense ?? true, isIncome: isIncome ?? false)
                    
                }) ?? []
                
                completion(.success(objects as? [AccountModel] ?? []))
            }
            
        }
        
    }
    
    func delete(object: AccountModel, completion: @escaping (Result<Void, AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("expenses").document(object.documentID).delete() { err in
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
        db.collection("expenses").document(object.documentID).updateData( [
        
            "value": object.value,
            "date": object.date,
            "paid": object.paid,
            "description": object.description,
            "isExpense": object.isExpense,
            "isIncome": object.isIncome
            
        ]) { err in
            if let err = err {
                print("Errot: \(err)")
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
        ref = db.collection("expenses").addDocument(data: [
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
