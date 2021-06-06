//
//  MainTabBarController.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 15.05.2021.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func minimizedTrackDetailController()
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {

    // MARK: Properties

    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!

    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTrackDetailView()

        view.backgroundColor = .white
        tabBar.tintColor = UIColor(named: "Colors/TabBarIconColor")

        let libraryVC = ViewController()
        searchVC.tabBarDelegate = self

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
        view.insertSubview(trackDetailView, belowSubview: tabBar)

        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC

        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                         constant: view.frame.height)

        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint.isActive = true

        trackDetailView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trackDetailView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}

// MARK: MainTabBarControllerDelegate

extension MainTabBarController: MainTabBarControllerDelegate {

    func minimizedTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                       },
                       completion: nil)
    }

    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                       },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        trackDetailView.set(viewModel: viewModel)
    }

}
