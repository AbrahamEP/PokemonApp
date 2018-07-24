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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    //MARK: - Helper
    
    private func setup() {
        self.setupTableView()
    }
    
    private func setupTableView() {
        
        
        
    }
    
    //MARK: - Actions
    
    @IBAction func logoutBarButtonAction(_ sender: UIBarButtonItem) {
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
