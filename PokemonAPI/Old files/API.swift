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
    
    private let email = "pokeapp@me.com"
    private let password = "123456"
    
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
                
//                let newPokemon = Pokemon(json: pokemonJson)
//                pokemons.append(newPokemon)
            })
            
            if self.getSavedPokemons() == nil {
                self.savePokemons(pokemons)
            }
            
            DispatchQueue.main.async {
                completion(pokemons, json, response)
            }
            
        }
        
    }
    
    func savePokemons(_ pokemons: [Pokemon]) {
        do {
            let pokemonsData = try JSONEncoder().encode(pokemons)
            UserDefaults.standard.set(pokemonsData, forKey: "pokemons")
        } catch {
            print("Error al guardar pokemons")
        }
    }
    
    func getSavedPokemons() -> [Pokemon]? {
        guard let data = UserDefaults.standard.data(forKey: "pokemons") else {
            return nil
        }
        
        do {
            let pokemons = try JSONDecoder().decode([Pokemon].self, from: data)
            return pokemons
        } catch {
            return nil
        }
    }
    
    func login(email: String, password: String, completion: @escaping (_ response: NetworkResponse) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            guard email == self.email && password == self.password else {
                
                let response = NetworkResponse(success: false, errorMessage: ErrorMessage.init(title: "Credenciales incorrectas", message: "Por favor, verifica tu email o contraseña"), code: -1)
                completion(response)
                return
            }
            
            let response = NetworkResponse(success: true, errorMessage: nil, code: 200)
            completion(response)
        }
        
        
    }
    
}
