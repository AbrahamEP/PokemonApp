//
//  PokemonTableViewCell.swift
//  PokemonAPI
//
//  Created by Abraham Escamilla Pinelo on 24/07/18.
//  Copyright © 2018 AEP. All rights reserved.
//

import UIKit
import SDWebImage

class PokemonTableViewCell: UITableViewCell {
    
    //MARK: - GUI
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var mainContentView: UIView!
    
    var pokemon: Pokemon! {
        didSet{
            self.setupInfo()
        }
    }
    
    //MARK: - Awake from Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }

    //MARK: - Helper
    private func setup() {
        DispatchQueue.main.async {
            self.shadowView.roundBordersWith(radius: 12)
            self.shadowView.applyShadow()
            self.mainContentView.roundBordersWith(radius: 12)
        }
    }
    
    private func setupInfo() {
        self.nameLabel.text = self.pokemon.name
        self.idLabel.text = "#\(self.pokemon.id)"
        self.pokemonImageView.sd_setShowActivityIndicatorView(true)
        self.pokemonImageView.sd_setIndicatorStyle(.gray)
        self.pokemonImageView.sd_setImage(with: URL.init(string: self.pokemon.imageUrl), completed: nil)
    }
}
