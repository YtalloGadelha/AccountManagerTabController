//
//  MyTableViewCellViewModel.swift
//  AccountManager
//
//  Created by Ytallo on 01/08/21.
//

import Foundation
import UIKit

class MyTableExpenseViewCellViewModel {
    
    private var model: AccountModel
    
    var value: Double {
        return self.model.value
    }
    
    var date: Date? {
        return self.model.date
    }
    
    var description: String {
        return self.model.description
    }
    
    var paid: Bool {
        return self.model.paid
    }
    
    init(expenseModel: AccountModel) {
        self.model = expenseModel        
    }
    
}
