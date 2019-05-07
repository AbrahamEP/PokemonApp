//
//  PokemonAPI.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 5/6/19.
//  Copyright © 2019 AEP. All rights reserved.
//

import Foundation
import Alamofire

enum PokemonRouter: URLRequestConvertible {
    
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
            return "http://pokeapi.co/api/v2/"
        
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
        case <#pattern#>:
            <#code#>
        default:
            <#code#>
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        <#code#>
    }
}
