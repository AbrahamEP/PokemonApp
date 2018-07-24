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
    
    func getPokemonList(for url: String = EndpointsURLs.getPokemonList ,completion: @escaping (_ pokemons: [Pokemon]?, _ json: JSON?, _ response: NetworkResponse) -> Void) {
        
        self.networking.networkingAlamo(url: url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil) { (response, json) in
            
            guard let currentJson = json else {
                DispatchQueue.main.async {
                    completion(nil, nil, response)
                }
                return
            }
            
            let resultsJson = currentJson["results"].arrayValue
            var pokemons: [Pokemon] = []
            resultsJson.forEach({ (pokemonJson) in
                let newPokemon = Pokemon(json: pokemonJson)
                pokemons.append(newPokemon)
            })
            
            DispatchQueue.main.async {
                completion(pokemons, json, response)
            }
            
        }
        
    }
    
    func login(username: String, password: String, completion: @escaping () -> Void) {
        
        
        
    }
    
}
