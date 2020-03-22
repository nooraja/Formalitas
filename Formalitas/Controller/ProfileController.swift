//
//  ProfileController.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookShare
import FBSDKShareKit
import SDWebImage
import MobileCoreServices

final class ProfileController: UIViewController {
    
    // MARK:- Private Property

    private let context = CoreDataManager.shared

    private lazy var imageProfile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var usernameTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        return textView
    }()

    private lazy var emailTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        return textView
    }()

    private lazy var genderDayTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    // MARK:- Public Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let userId = AccessToken.current?.userID ?? ""

        if context.validateUser(id: userId) == true {

            let user = context.fetchUser(id: userId)
            self.imageProfile.sd_setImage(with: URL(string: user?.urlImage ?? ""), completed: nil)
            self.usernameTextView.text = user?.name
            self.emailTextView.text = user?.email
            self.genderDayTextView.text = user?.gender
        } else {

            NetworkingFacebook().setUserData { result in
                if let name: String = result["name"] as? String,
                    let fbId: String = result["id"] as? String,
                    let email: String = result["email"] as? String,
                    let gender: String = result["gender"] as? String,
                    let imageDictionary = result["picture"] as? [String: Any] {

                    if let dataImage = imageDictionary["data"] as? [String: Any],
                        let urlImage = dataImage["url"] {

                        self.context.createUser(id: fbId, name: name, url: urlImage as! String, gender: gender, email: email)

                        self.imageProfile.sd_setImage(with: URL(string: urlImage as! String), completed: nil)
                        self.usernameTextView.text = name
                        self.emailTextView.text = email
                        self.genderDayTextView.text = gender
                    }
                }
            }
        }
    }

    @objc func handleShare() {
        self.shareLink(url: URL(string: "https://cocoapods.org/pods/FacebookShare")!)
    }

    func shareLink(url:URL){

        let linkshare = ShareLinkContent()
        linkshare.contentURL = url
        linkshare.quote = "Testing my url"

        let shareDialog = ShareDialog()
        shareDialog.shareContent = linkshare
        shareDialog.mode = .browser

        do {
            try shareDialog.show()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @objc func handleLogout() {

        guard let user = context.fetchUser(id: AccessToken.current?.userID ?? "") else {
            return
        }

        if AccessToken.current != nil {
            context.deleteUser(user: user)
            AccessToken.current = nil
            let login = LoginController()
            login.modalPresentationStyle = .fullScreen
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK:- Private Method

    private func bindUI() {

        let viewMain = GradientView(frame: .zero)
        viewMain.changeGradientColor(firstColor: .orangeLight, secondColor: .orangePure)
        view.addSubview(viewMain)

        viewMain.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        viewMain.addSubview(imageProfile)
        imageProfile.anchor(top: viewMain.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 160)
        imageProfile.centerXAnchor.constraint(equalTo: viewMain.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextView, emailTextView, genderDayTextView])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        viewMain.addSubview(stackView)
        stackView.anchor(top: imageProfile.bottomAnchor, left: viewMain.leftAnchor, bottom: nil, right: viewMain.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
}
