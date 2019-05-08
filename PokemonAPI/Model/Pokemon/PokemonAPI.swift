//
//  PokemonAPI.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 5/6/19.
//  Copyright © 2019 AEP. All rights reserved.
//

import Foundation
import Alamofire

enum PokemonRouter: APIConfiguration {
    
    case getPokemons(params: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .getPokemons:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getPokemons:
            return "pokemon/"
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPokemons(let params):
            return params
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try DCAPIManager.shared.host.asURL()
        url.appendPathComponent(DCAPIManager.shared.apiVersion)
        url.appendPathComponent(path)
        
        var urlRequest = try URLRequest(url: url, method: method)
        urlRequest = try encoding.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
}

final class PokemonAPI {
    static func getPokemons(offset: Int? = nil, completion: @escaping (_ error: ResponseError?, _ pokemons: Pagination<Pokemon>?) -> Void) {
        
        var params: Parameters = ["limit": 20]
        if let offset = offset {
            params["offset"] = offset
        }
        
        DCAPIManager.shared.request(urlRequest: PokemonRouter.getPokemons(params: params)) { (err, pokemons: Pagination<Pokemon>?) in
            
            if PokemonHelper.getSavedPokemons() == nil  {
                if let pokemons = pokemons {
                    PokemonHelper.savePokemons(pokemons.results)
                }
            }
            DispatchQueue.main.async {
                completion(err, pokemons)
            }
        }
    }
}
