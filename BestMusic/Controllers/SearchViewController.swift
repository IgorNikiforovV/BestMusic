//
//  SearchViewController.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 15.05.2021.
//

import UIKit

struct TrackModel {
    let trackName: String
    let artistName: String
}

class SearchViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)

    private let tracks = [TrackModel(trackName: "Save Your Tears", artistName: "The Weeknd"),
                          TrackModel(trackName: "Diamonds", artistName: "Sam Smith"),
                          TrackModel(trackName: "Regardless", artistName: "RAYE&Rudimental")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureSearchBar()
        configureTableView()

    }

}

// MARK: UITableViewDataSource -

extension SearchViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = tracks[indexPath.item].artistName
        let track = tracks[indexPath.item]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.imageView?.image = UIImage(named: "trackImage")
        return cell
    }

}

// MARK: UISearchBarDelegate -

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

}

// MARK: Private methods -

private extension SearchViewController {

    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }

    func configureSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}
