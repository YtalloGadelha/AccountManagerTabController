//
//  LoginViewController.swift
//  AccountManager
//
//  Created by Ytallo on 30/07/21.
//

import UIKit
import CoreData

class LoginViewController: DefaultViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passWordLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        
        overrideUserInterfaceStyle = .light
        configLayout()
        self.viewModel.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.silentLogin()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        //Recuperar dados digitados
        if let email = self.userTextField.text {
            if let password = self.passWordTextField.text {                
                self.viewModel.Login(email: email, password: password)
            }
        }
    }
    
    func configLayout() {
        self.loginButton.clipsToBounds = true
        self.loginButton.layer.cornerRadius = 12.0
        self.loginButton.layer.borderColor = UIColor.lightGray.cgColor
        self.loginButton.layer.borderWidth = 0.5
        
        self.userTextField.clipsToBounds = true
        self.userTextField.layer.cornerRadius = 12.0
        self.userTextField.layer.borderWidth = 0.2
        
        self.passWordTextField.clipsToBounds = true
        self.passWordTextField.layer.cornerRadius = 12.0
        self.passWordTextField.layer.borderWidth = 0.2
    }
    
}

extension LoginViewController: LoginViewModelDelegate{
    
    func didFinishVerificationLoggedUser() {
        self.performSegue(withIdentifier: "loggedUser", sender: nil)
    }
    
    func didFinishWithSuccess(email: String, password: String) {
        self.viewModel.saveUserCoreData(email: email, password: password)
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    func didFail(message: String?) {
        self.showAlert(message: message ?? "")
    }
    
}
