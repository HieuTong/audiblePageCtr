//
//  HomeController.swift
//  audible
//
//  Created by HieuTong on 1/24/21.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "We're logged in"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleSignOut))
        
        let imageView = UIImageView(image: UIImage(named: "home"))
        view.addSubview(imageView)
        _ = imageView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        let loginController = LoginController()
        loginController.modalPresentationStyle = .overFullScreen
        present(loginController, animated: true, completion: nil)
    }
}
