//
//  FeedController.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit
import FacebookCore

class FeedController: UIViewController {
    
    //MARK:- Public Method

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        getUserData()
    }
    
    func getUserData(){
        if AccessToken.current != nil {
            let connection = GraphRequestConnection()

            connection.add(GraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"])) { httpResponse, result, error   in
                if error != nil {
                    NSLog(error.debugDescription)
                    return
                }

                if let result = result as? [String: Any] {
                    print(result)
                }
            }
            connection.start()
        }
    }

}
