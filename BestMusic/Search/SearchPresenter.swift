//
//  SearchPresenter.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?
    
    func presentData(response: Search.Model.Response.ResponseType) {
        switch response {
        case .some:
            print("presenter .some")
        case .presentTracks(let searchResults):
            let cells = searchResults?.results.map{ cellViewModel(from: $0) } ?? []
            let searchViewModel = SearchViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayTracks(searchViewModel: searchViewModel))
        }
    }
    
}

// MARK: Private methods

private extension SearchPresenter {

    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        SearchViewModel.Cell(iconUrlString: track.artworkUrl100,
                             trackName: track.trackName ?? "Unknown track",
                             collectionName: track.collectionName ?? "No collection",
                             artistName: track.artistName ?? "Unknown author",
                             previewUrl: track.previewUrl)
    }

}
