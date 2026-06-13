//
//  MyTableViewCell.swift
//  AccountManager
//
//  Created by Ytallo on 01/08/21.
//

import UIKit

class MyTableExpenseViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: MyTableExpenseViewCellViewModel?
    
    func setupCell(viewModel: MyTableExpenseViewCellViewModel){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
    
        self.valueLabel.text = "Valor: \(viewModel.value)"
        self.valueLabel.textColor = .systemRed
        
        self.dateLabel.text = "Data: \(dateFormatter.string(from: viewModel.date ?? Date()))"
        self.dateLabel.textColor = .systemRed
        
        self.descriptionLabel.text = "Descrição: \(viewModel.description)"
        self.descriptionLabel.textColor = .systemRed
        
        self.paidLabel.textColor = .systemRed
        if(viewModel.paid){
            self.paidLabel.text = "Pago: Sim."
        }else{
            self.paidLabel.text = "Pago: Não."
        }        
        
        self.viewModel = viewModel
        
    }
}
