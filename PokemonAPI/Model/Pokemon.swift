//
//  Pokemon.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 23/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pokemon: Codable {
    var name: String
    var url: String
    var id: Int{
        get{
            var tempUrl = self.url
            tempUrl.removeLast()
            let components = tempUrl.components(separatedBy: "/")
            guard let idString = components.last, let currentID = Int(idString) else {
                return -1
            }
            return currentID
        }
    }
    
    var imageUrl: String {
        get{
            return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.id).png"
        }
    }
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.url = json["url"].stringValue
    }
    
    
}
