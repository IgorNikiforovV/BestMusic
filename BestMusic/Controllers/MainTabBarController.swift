//
//  MainTabBarController.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 15.05.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tabBar.tintColor = UIColor(named: "Colors/TabBarIconColor")

        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        let libraryVC = ViewController()

        viewControllers = [
            generateViewController(rootViewController: searchVC, image: "TabBar/Search", title: "Search"),
            generateViewController(rootViewController: libraryVC, image: "TabBar/Library", title: "Library"),
        ]
    }

    private func generateViewController(rootViewController: UIViewController, image: String, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(named: image)
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }

}
