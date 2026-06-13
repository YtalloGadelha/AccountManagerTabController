//
//  Expense.swift
//  AccountManager
//
//  Created by Ytallo on 27/05/26.
//

import UIKit

class IncomeViewController: DefaultViewController {
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var paidSwitch: UISwitch!
    
    var viewModel: IncomeViewModel = IncomeViewModel()
    
    var income: AccountModel?
    
    func configLayout() {
        self.cancelButton.clipsToBounds = true
        self.cancelButton.layer.cornerRadius = 12.0
        self.cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        self.cancelButton.layer.borderWidth = 0.5
        
        self.saveButton.clipsToBounds = true
        self.saveButton.layer.cornerRadius = 12.0
        self.saveButton.layer.borderColor = UIColor.lightGray.cgColor
        self.saveButton.layer.borderWidth = 0.5
        
        self.valueTextField.clipsToBounds = true
        self.valueTextField.layer.cornerRadius = 12.0
        self.valueTextField.layer.borderWidth = 0.2
        
        self.dateTextField.clipsToBounds = true
        self.dateTextField.layer.cornerRadius = 12.0
        self.dateTextField.layer.borderWidth = 0.2
        
        self.descriptionTextField.clipsToBounds = true
        self.descriptionTextField.layer.cornerRadius = 12.0
        self.descriptionTextField.layer.borderWidth = 0.2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        configLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let tempIncome = self.income{
            
            self.valueTextField.text = String(tempIncome.value)
            self.dateTextField.text = dateFormatter.string(from: tempIncome.date)
            self.descriptionTextField.text = tempIncome.description
            self.paidSwitch.isOn = tempIncome.paid
            
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if(self.valueTextField.text == ""){
            self.showAlert(message: "Valor Inválido!")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let objDateFormate = dateFormatter.date(from: self.dateTextField.text ?? "")
        
        let objValue = ((self.valueTextField.text ?? "") as NSString).doubleValue
        let objDate = objDateFormate ?? Date()
        var objDescription = ""
        let objPaid = self.paidSwitch.isOn
        
        if(self.descriptionTextField.text == ""){
            objDescription = "Sem observação."
        }else{
            objDescription = self.descriptionTextField.text ?? ""
        }
        
        if(self.income == nil){// new expense
            
            let income = AccountModel(documentID: "", value: objValue, description: objDescription, date: objDate, paid: objPaid, isExpense: false, isIncome: true)
            self.viewModel.create(object: income)
        
        }else{// update expense
            
            let income = AccountModel(documentID: self.income?.documentID ?? "", value: objValue, description: objDescription, date: objDate, paid: objPaid, isExpense: false, isIncome: true)
            self.viewModel.update(object: income)
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
