//
//  MainTabController.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            generateViewController(source: FeedController(), title: "Feed", image: #imageLiteral(resourceName: "share")),
            generateViewController(source: ProfileController(), title: "Profile", image: #imageLiteral(resourceName: "moon"))
        ]
    }

}

extension MainTabController: ViewControllerFactory {

    func generateViewController(source: UIViewController, title: String, image: UIImage) -> UIViewController {

        let navigationController = UINavigationController(rootViewController: source)
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.title = title

        return navigationController
    }

}
