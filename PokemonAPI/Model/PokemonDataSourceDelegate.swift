//
//  PokemonDataSourceDelegate.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 24/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PokemonDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var nextUrl: String?
    var previousUrl: String?
    var pokemons: [Pokemon] = []
    
    func loadPokemons(completion: @escaping () -> Void) {
        
        API.shared.getPokemonList { (tempPokemons, json, response) in
            
            guard let currentPokems = tempPokemons, let currentJson = json else {
                
                guard let savedPokemons = API.shared.getSavedPokemons() else {
                    DispatchQueue.main.async {
                        completion()
                    }
                    return
                }
                self.pokemons = savedPokemons
                
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            self.pokemons = currentPokems
            self.nextUrl = currentJson["next"].string
            self.previousUrl = currentJson["previous"].string
            
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }
    
    func loadNextPokemons(completion: @escaping () -> Void) {
        
        guard let next = self.nextUrl else {return}
        API.shared.getPokemonList(for: next) { (tempPokemons, json, response) in
            
            guard let currentPokemons = tempPokemons, let currentJson = json else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            self.pokemons = self.pokemons + currentPokemons
            self.nextUrl = currentJson["next"].string
            self.previousUrl = currentJson["previous"].string
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.TableView.pokemon, for: indexPath) as! PokemonTableViewCell
        
        cell.pokemon = self.pokemons[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.pokemons.count - 1 {
            
            self.loadNextPokemons {
                tableView.reloadData()
            }
            
        }
        
    }
    
}
