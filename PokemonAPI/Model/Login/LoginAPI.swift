//
//  LoginAPI.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 5/7/19.
//  Copyright © 2019 AEP. All rights reserved.
//

import Foundation

final class LoginAPI {
    
    static func login(email: String, password: String, completion: @escaping (_ err: ResponseError?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard email == "pokeapp@me.com" && password == "123456" else {
                
                let response = ResponseError(code: 400, message: "Credenciales incorrectas", statusCode: nil)
                completion(response)
                return
            }
            completion(nil)
        }
    }
}
