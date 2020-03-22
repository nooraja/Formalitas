//
//  NetworkingFacebook.swift
//  Formalitas
//
//  Created by NOOR on 21/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import FacebookCore

struct NetworkingFacebook {

    func setUserData(handleCompletion: @escaping ([String: Any]) -> Void) {
        if AccessToken.current != nil {
            let connection = GraphRequestConnection()

            connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"])) { httpResponse, result, error   in
                if error != nil {
                    NSLog(error.debugDescription)
                    return
                }

                if (result as? [String: Any]) != nil {
                    handleCompletion(result as! [String : Any])
                }
            }
            connection.start()
        }
    }
}
