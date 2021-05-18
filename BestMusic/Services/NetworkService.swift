//
//  NetworkService.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 18.05.2021.
//

import UIKit
import Alamofire

class NetworkService {

    func fetchTracks(searchText: String) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "limit": "10"]

        AF.request(url, method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default).responseData { [weak self] response in
                    switch response.result {
                    case .success(let data1):
                        let decoder = JSONDecoder()
                        do {
                            let objects = try decoder.decode(SearchResponse.self, from: data1)
                        } catch let error {
                            print("Failed to decode JSON", error.localizedDescription)
                        }
                    case .failure(let error):
                        print("Error recived requesiong data: \(error.localizedDescription)")
                    }
        }
    }

}
