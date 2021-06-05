//
//  SearchViewController.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?

    // MARK: @IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var footerView = FooterView()

    private var searchViewModel = SearchViewModel(cells: [])
    private var timer: Timer?

    // MARK: Object lifecycle


    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        setupTableView()
        setupSearchBar()
        searchBar(searchController.searchBar, textDidChange: "Billie")
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(let searchViewModel):
            self.searchViewModel = searchViewModel
            tableView.reloadData()
            footerView.hideLoader()
        case .displayFooterView:
            footerView.showLoader()
        }
    }
    
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        let cellViewModel = searchViewModel.cells[indexPath.item]
        cell.set(cellViewModel)
        return cell
    }

}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.item]
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailView.set(viewModel: cellViewModel)
        trackDetailView.delegate = self
        window?.addSubview(trackDetailView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        searchViewModel.cells.isEmpty ? 250 : 0
    }

}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
        })
    }

}

// MARK: - TrackMovingDelegate

extension SearchViewController: TrackMovingDelegate {

    private func getTrack(isForvardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        var item: Int
        if isForvardTrack {
            item = indexPath.item == searchViewModel.cells.count - 1 ? 0 : indexPath.item + 1
        } else {
            item = indexPath.item == 0 ? searchViewModel.cells.count - 1 : indexPath.item - 1
        }
        let newIndexPath = IndexPath(item: item, section: indexPath.section)
        tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = searchViewModel.cells[newIndexPath.item]
        return cellViewModel
    }

    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isForvardTrack: false)
    }

    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isForvardTrack: true)
    }

}

// MARK: - Private methods

private extension SearchViewController {

    func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

    }

    func setupTableView() {
        let nib = UINib(nibName: TrackCell.reuseId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        tableView.tableFooterView = footerView
    }

}
