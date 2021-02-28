//
//  MainNavigation.swift
//  audible
//
//  Created by HieuTong on 1/24/21.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if isLoggedIn() {
            //assume user is logged in
            let homeController = HomeController()
            viewControllers = [homeController]
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showLoginController() {
        let loginController = LoginController()
        loginController.modalPresentationStyle = .overFullScreen
        present(loginController, animated: true, completion: {
            //perhap we'll do something here later
        })
    }
}

