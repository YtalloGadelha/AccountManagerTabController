//
//  MyTableViewCell.swift
//  AccountManager
//
//  Created by Ytallo on 01/08/21.
//

import UIKit

class MyTableAccountViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: MyTableAccountViewCellViewModel?
    
    func setupCell(viewModel: MyTableAccountViewCellViewModel){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
    
        self.valueLabel.text = "Valor: \(viewModel.value)"
        
        self.dateLabel.text = "Data: \(dateFormatter.string(from: viewModel.date ?? Date()))"
        
        self.descriptionLabel.text = "Descrição: \(viewModel.description)"
        
        if(viewModel.paid){
            self.paidLabel.text = "Pago: Sim."
        }else{
            self.paidLabel.text = "Pago: Não."
        }        
        
        self.viewModel = viewModel
        
    }
}
