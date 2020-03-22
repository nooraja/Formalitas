//
//  LoginController.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin

class LoginController: UIViewController {

    // MARK:- Private Property
    
    private let manager = LoginManager()
    private let profileController = ProfileController()

    private lazy var loginButton: FBLoginButton = {
        let button = FBLoginButton(frame: .zero, permissions: [.publicProfile, .email])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(whenTappedLoginButton), for: .touchUpInside)
        return button
    }()

    // MARK:- Public Method

    override func viewDidAppear(_ animated: Bool) {
        
        if AccessToken.current != nil {
            self.navigateToProfile()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }

    @objc func whenTappedLoginButton() {
        if AccessToken.current != nil{
            navigateToProfile()
        } else {
            manager.logIn(permissions: [.email, .publicProfile, .userGender, .userBirthday], viewController: self) { login in

                switch login {
                case .failed(let error):
                    print("error \(error)")
                case .success(_, _, _):
                    self.navigateToProfile()
                case .cancelled:
                    print("User cancelled login.")
                }
            }
        }
    }

    // MARK:- Private Method

    fileprivate func bindUI() {

        let viewMain = GradientView(frame: .zero)
        view.addSubview(viewMain)

        viewMain.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        viewMain.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: viewMain.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: viewMain.centerYAnchor).isActive = true
    }

    fileprivate func navigateToProfile() {
        self.profileController.modalPresentationStyle = .fullScreen
        self.present(UINavigationController(rootViewController: self.profileController), animated: true, completion: nil)
    }

}
