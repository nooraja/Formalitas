//
//  ViewControllerFactory.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit

protocol ViewControllerFactory {
    func generateViewController(source: UIViewController, title: String, image: UIImage) -> UIViewController
}
