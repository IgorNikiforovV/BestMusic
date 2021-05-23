//
//  SearchInteractor.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var presenter: SearchPresentationLogic?
    var service: SearchService?

    var networkService = NetworkService()
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }

        switch request {
        case .some:
            print("interactor .some")
        case .getTracks(let searchTerm):
            networkService.fetchTracks(searchText: searchTerm) { [weak self] response in
                self?.presenter?.presentData(response: .presentTracks(searchResponse: response))
            }
        }
    }
    
}
