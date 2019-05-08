//
//  PokemonListViewController.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 23/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    //MARK: - GUI
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutBarButtonItem: UIBarButtonItem!
    
    //MARK: - Variables
    
    
    var pokemonsPagination: Pagination<Pokemon>! = Pagination<Pokemon>()
    var pokemons: [Pokemon] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    //MARK: - Helper
    
    private func setup() {
        self.title = "Pokémon"
        self.setupTableView()
        self.setupLogouBarButton()
    }
    
    private func setupLogouBarButton() {
        self.logoutBarButtonItem.tintColor = UIColor.red
    }
    
    private func setupTableView() {
        
        self.tableView.register(UINib.init(nibName: CellNames.TableView.pokemon, bundle: nil), forCellReuseIdentifier: CellNames.TableView.pokemon)
        
        self.tableView.rowHeight = 80
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        HelpTools.showProgressHUD(in: self.view)
        PokemonAPI.getPokemons { [weak self] (err, pagedPokemons) in
            guard let self = self else {return}
            HelpTools.dismissProgressHUD(in: self.view)
            guard let pagedPokemons = pagedPokemons else {
                return
            }
            self.pokemonsPagination = pagedPokemons
            self.pokemons = self.pokemons + pagedPokemons.results
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Actions
    
    @IBAction func logoutBarButtonAction(_ sender: UIBarButtonItem)
    {
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            HelpTools.logout()
            self.transitionToLogin()
        }
        self.createAlertView("¿Seguro que desea cerrar sesión?", nil, type: .alert, actions: cancelAction, okAction)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.TableView.pokemon, for: indexPath) as! PokemonTableViewCell
        
        let pokemon = self.pokemons[indexPath.row]
        cell.pokemon = pokemon
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.pokemons.count - 1 {
            PokemonAPI.getPokemons(offset: self.pokemons.count) { (err, pagedPokemons) in
                guard let pagedPokemons = pagedPokemons else {
                    return
                }
                self.pokemonsPagination = pagedPokemons
                self.pokemons = self.pokemons + pagedPokemons.results
                self.tableView.reloadData()
            }
        }
    }
}
