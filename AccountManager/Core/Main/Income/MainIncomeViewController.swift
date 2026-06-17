//
//  MainViewController.swift
//  AccountManager
//
//  Created by Ytallo on 30/07/21.
//

import UIKit
import FirebaseAuth

class MainIncomeViewController: DefaultViewController{
    
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var viewModel: MainIncomeViewModel = MainIncomeViewModel()
    
    func configLayout() {
        self.addIncomeButton.clipsToBounds = true
        self.addIncomeButton.layer.cornerRadius = 12.0
        self.addIncomeButton.layer.borderColor = UIColor.lightGray.cgColor
        self.addIncomeButton.layer.borderWidth = 0.5
        
        self.logoutButton.clipsToBounds = true
        self.logoutButton.layer.cornerRadius = 12.0
        self.logoutButton.layer.borderColor = UIColor.lightGray.cgColor
        self.logoutButton.layer.borderWidth = 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        configLayout()
        
        self.viewModel.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.listIncome()
        self.showActivity()
        
        guard let tabBar = tabBarController?.tabBar else { return }
        tabBar.tintColor = .systemGreen
        
    }
    
    @IBAction func incomeAddButton(_ sender: Any) {
        
        let story = UIStoryboard.init(name: "Income", bundle: nil)
        if let vc = story.instantiateInitialViewController(){
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        self.viewModel.logout()
        self.showActivity()
    }
}

extension MainIncomeViewController: MainIncomeViewModelDelegate{
    
    func didSignout() {
        self.hideActivity()
        self.dismiss(animated: true, completion: nil)
    }
    
    func didFinishWithSuccess() {
        self.hideActivity()
        self.tableView.reloadData()
    }
    
    func didFail(message: String?) {
        self.showAlert(message: message ?? "")
    }
    
}

//MARK:- Extension TableView
extension MainIncomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tableViewNumberOfLines
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let selectedData = self.viewModel.getData(from: indexPath), selectedData.isIncome,
           let cell = tableView.dequeueReusableCell(withIdentifier: "myAccountCell") as? MyTableAccountViewCell{
            
            if let myTableViewCellViewModel = self.viewModel.getTableViewCellViewModel(from: indexPath){
                cell.setupCell(viewModel: myTableViewCellViewModel)
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let selectedData = self.viewModel.getData(from: indexPath), selectedData.isIncome{
            
            let story = UIStoryboard.init(name: "Income", bundle: nil)
            if let vc = story.instantiateInitialViewController() as? IncomeViewController{
                
                vc.income = selectedData
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            if let selectedData = self.viewModel.getData(from: indexPath), selectedData.isIncome{
                
                self.viewModel.deleteIncome(object: selectedData)
                self.viewModel.deleteData(from: indexPath)
                self.viewModel.listIncome()
                
                return
                
            }
            
        }
        
    }
    
}
