//
//  Networking.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 23/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking {
    
    private var myAlamo: SessionManager!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // seconds
        configuration.timeoutIntervalForResource = 20 //seconds
        myAlamo = SessionManager(configuration: configuration)
    }
    
    func networkingAlamo(url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, handler: @escaping (NetworkResponse, JSON?)->Void) {
        
        myAlamo.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            
            guard let httpResponse = response.response else {
                
                let error = NetworkResponse(success: false, errorMessage: ErrorMessage.init(title: "Sucedió algo", message: "Por favor, intente de nuevo más tarde"), code: -1)
                
                DispatchQueue.main.async {
                    handler(error, nil)
                }
                return
            }
            
            
            switch httpResponse.statusCode {
                
            case 200...204:
                
                var errorResponse = NetworkResponse()
                errorResponse.success = true
                
                guard let jsonTemp = response.result.value else {
                    
                    handler(errorResponse, nil)
                    return
                }
                
                let json = JSON(jsonTemp)
                
                DispatchQueue.main.async {
                    handler(errorResponse, json)
                }
                
            default:
                
                let errorResponse = NetworkResponse(success: false, errorMessage: ErrorMessage.init(title: "Sucedió algo", message: "Por favor, intente de nuevo más tarde"), code: -1)
                
                DispatchQueue.main.async {
                    handler(errorResponse, nil)
                }
                
            }
        }
        
    }
    
}
