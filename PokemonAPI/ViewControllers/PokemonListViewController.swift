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
    
    var pokemonDataSource: PokemonDataSourceDelegate!
    
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
        self.pokemonDataSource = PokemonDataSourceDelegate()
        
        self.tableView.rowHeight = 80
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self.pokemonDataSource
        self.tableView.delegate = self.pokemonDataSource
        
        HelpTools.showProgressHUD(in: self.view)
        self.pokemonDataSource.loadPokemons {
            self.tableView.reloadData()
            HelpTools.dismissProgressHUD(in: self.view)
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
