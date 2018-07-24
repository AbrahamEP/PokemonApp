//
//  API.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 23/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct EndpointsURLs {
    static let baseUrl = "http://pokeapi.co/api/v2/"
    static let getPokemonList = baseUrl + "pokemon/?limit=150"
}

class API {
    
    static let shared = API()
    
    var networking: Networking!
    
    private init() {
        self.networking = Networking()
    }
    
    func getPokemonList(for url: String = EndpointsURLs.getPokemonList ,completion: @escaping (_ pokemons: [Pokemon]?, _ json: JSON?) -> Void) {
        
        self.networking.networkingAlamo(url: url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil) { (response, json) in
            
            
            
        }
        
    }
    
}
