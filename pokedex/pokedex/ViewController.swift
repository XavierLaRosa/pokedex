//
//  ViewController.swift
//  pokedex
//
//  Created by Xavier La Rosa on 11/28/18.
//  Copyright © 2018 Xavier La Rosa. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    let pokemonApi: PokemonDataSource = PokemonDataSource()
    var pokemon: [Pokemon] = []
    
    @IBOutlet var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
        pokemonApi.getPokemonData { (pokemonData) in
            self.pokemon = pokemonData.results
            //you dont have to put using dispatchqueue on tableview reload data will run this on main thread instead of background
            //main threads run faster than background threads
            DispatchQueue.main.sync{
                self.tableView.reloadData()
            }
        }
        
    }
    
}

//we use extensions so that you can add any class in swift to anything
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return UITableViewCell(1)
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = pokemon[indexPath.row].name
        //this code right here puts images per pokemon
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(indexPath.row+1).png"
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
        }
        //code ends for images per pokemon
        return cell
    }
}

