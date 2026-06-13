//
//  DefaultViewController.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation

import UIKit

class DefaultViewController: UIViewController {

    var activityController: UIView? = nil
    var labelActivity: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 30.0))
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }else{
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupNavigation(_ title: String? = nil) {
        self.navigationItem.title = title ?? ""
        self.navigationItem.titleView?.tintColor = .white
    }
    
    func showActivity(){
        if activityController == nil {
            activityController = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            activityController?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
            let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activity.center = (activityController?.center)!
            activity.startAnimating()
            
            labelActivity.frame.size.width = (activityController?.bounds.width ?? 0.0) * 0.9
            labelActivity.center = (activityController?.center)!
            labelActivity.frame.origin.x = ((activityController?.bounds.width ?? 0.0) - labelActivity.bounds.width)/2
            labelActivity.frame.origin.y = activity.frame.origin.y + activity.bounds.height + 8
            labelActivity.text = "Carregando..."
            labelActivity.textAlignment = .center
            labelActivity.textColor = UIColor.white
            
            activityController?.addSubview(labelActivity)
            activityController?.addSubview(activity)
        }
        guard let navigationController = self.navigationController else {
            self.view.addSubview(self.activityController!)
            return
        }
        navigationController.view.addSubview(activityController!)
    }
    
    func hideActivity(){
        activityController?.removeFromSuperview()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        alert.preferredAction = action
        
        self.present(alert, animated: true, completion: nil)
    }
}
