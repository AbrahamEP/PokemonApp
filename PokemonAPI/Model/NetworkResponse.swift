//
//  NetworkResponse.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 23/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import Foundation

struct ErrorMessage {
    var title: String
    var message: String
    
    init() {
        self.title = "Error"
        self.message = "Fatal Error"
    }
    
    init(title: String, message: String) {
        
        self.title = title
        self.message = message
    }
}

struct NetworkResponse {
    var success: Bool!
    var errorMessage: ErrorMessage?
    var statusCode: Int!
    
    
    init() {
        success = false
        errorMessage = ErrorMessage()
        statusCode = 0
        
    }
    
    init(success: Bool, errorMessage: ErrorMessage?, code: Int) {
        self.success = success
        self.errorMessage = errorMessage
        self.statusCode = code
    }
    
    
}
