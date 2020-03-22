//
//  FeedController.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit
import FacebookCore

final class FeedController: UIViewController {
    
    //MARK:- Public Method

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NetworkingFacebook().setUserData { result in
            if let id = result["id"] as? String, let name = result["name"] as? String {
            }
        }
    }
    
    

}
