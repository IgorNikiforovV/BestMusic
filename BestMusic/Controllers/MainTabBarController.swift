//
//  MainTabBarController.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 15.05.2021.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func minimizedTrackDetailController()
}

class MainTabBarController: UITabBarController {

    // MARK: Properties

    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!

    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTrackDetailView()

        view.backgroundColor = .white
        tabBar.tintColor = UIColor(named: "Colors/TabBarIconColor")

        let libraryVC = ViewController()

        viewControllers = [
            generateViewController(rootViewController: searchVC, image: "TabBar/Search", title: "Search"),
            generateViewController(rootViewController: libraryVC, image: "TabBar/Library", title: "Library"),
        ]
    }

}

// MARK: - Private methods

private extension MainTabBarController {

    func generateViewController(rootViewController: UIViewController, image: String, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(named: image)
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }

    func setupTrackDetailView() {
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailView.backgroundColor = .green
        view.insertSubview(trackDetailView, belowSubview: tabBar)

        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC

        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

        maximizedTopAnchorConstraint.isActive = true

        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                         constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        trackDetailView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trackDetailView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}

// MARK: MainTabBarControllerDelegate

extension MainTabBarController: MainTabBarControllerDelegate {

    func minimizedTrackDetailController() {

        self.maximizedTopAnchorConstraint.isActive.toggle()
        self.minimizedTopAnchorConstraint.isActive.toggle()

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                       },
                       completion: nil)
    }

}
