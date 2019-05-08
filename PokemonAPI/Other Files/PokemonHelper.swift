//
//  PokemonHelper.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 5/7/19.
//  Copyright © 2019 AEP. All rights reserved.
//

import Foundation

final class PokemonHelper {
    static func savePokemons(_ pokemons: [Pokemon]) {
        do {
            let pokemonsData = try JSONEncoder().encode(pokemons)
            UserDefaults.standard.set(pokemonsData, forKey: "pokemons")
        } catch {
            print("Error al guardar pokemons")
        }
    }
    
    static func getSavedPokemons() -> [Pokemon]? {
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
}
