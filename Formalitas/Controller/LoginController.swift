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
    
    // MARK:- Public Property

    lazy var loginButton: FBLoginButton = {
        let button = FBLoginButton(frame: .zero, permissions: [.publicProfile, .email])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(whenTappedLoginButton), for: .touchUpInside)
        return button
    }()

    lazy var imageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "tester"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true

        return image
    }()
    
    // MARK:- Private Property

    private let mainTabBar = MainTabController()
    private let manager = LoginManager()
    
    // MARK:- Public Method
    
    override func viewDidAppear(_ animated: Bool) {
        
        if AccessToken.current != nil{
            self.present(MainTabController(), animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = AccessToken.current {
            print("Access Token :  \(accessToken.appID)")
        }
        
        bindUI()
    }

    @objc func whenTappedLoginButton() {
        if AccessToken.current != nil{
          
            self.mainTabBar.modalPresentationStyle = .fullScreen
            self.present(mainTabBar, animated: true, completion: nil)

        } else {
            manager.logIn(permissions: [.email, .publicProfile, .userGender, .userBirthday], viewController: self) { login in

                switch login {
                case .failed(let error):
                    print("error \(error)")
                case .success(_, _, _):
                    self.mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(self.mainTabBar, animated: true, completion: nil)
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

}

