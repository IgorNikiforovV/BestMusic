//
//  SearchModels.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 20.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
    
    enum Model {
        struct Request {
            enum RequestType {
                case some
                case getTracks
            }
        }
        struct Response {
            enum ResponseType {
                case some
                case presentTracks
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case some
                case displayTracks
            }
        }
    }
    
}
