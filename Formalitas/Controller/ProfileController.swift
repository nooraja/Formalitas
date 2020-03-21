//
//  ProfileController.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import SDWebImage
import MobileCoreServices

class ProfileController: UIViewController {
    
    lazy var imageProfile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var usernameTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        view.addSubview(imageProfile)
        imageProfile.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 160)
        imageProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageProfile.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(usernameTextView)
        usernameTextView.anchor(top: imageProfile.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 60)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserData()
    }
    
    @objc func handleLogout() {
        if AccessToken.current != nil {
            AccessToken.current = nil
            let login = LoginController()
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: false, completion: nil)
        }
    }
    
    func getUserData(){
        if AccessToken.current != nil {
            let connection = GraphRequestConnection()
            connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"])) { httpResponse, result, error   in
                if error != nil {
                    NSLog(error.debugDescription)
                    return
                }
                
                if let result = result as? [String: Any],
                    let name: String = result["name"] as! String,
                    let fbId: String = result["id"] as! String,
                    let email: String = result["email"] as? String,
                    let imageDictionary = result["picture"] as? [String: Any] {

                    if let dataImage = imageDictionary["data"] as? [String: Any],
                        let imageUrl = dataImage["url"] {
                        self.imageProfile.sd_setImage(with: URL(string: imageUrl as? String ?? ""), completed: nil)
                        self.usernameTextView.text = email
                    }
                }
            }
            connection.start()
        }
    }
    
}
