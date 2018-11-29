//
//  PokemonDataSource.swift
//  pokedex
//
//  Created by Xavier La Rosa on 11/28/18.
//  Copyright © 2018 Xavier La Rosa. All rights reserved.
//

import Foundation //just kind of like a standard library

//we made this file by creating a new file and instead of using cocoa we used a plain swift file option
//in reference to using Postman API and using GET on https://pokeapi.co/api/v2/pokemon/
//lets make our own object for pokemon using struct (classes without methods, classes use pointers)
struct Pokemon: Codable{
    let name: String //explicitly matching the types in postman data for name and url
    let url: String
}

//: codable converts JSON into objects easily
struct PokemonData: Codable{
    let results: [Pokemon] //an array called results holding pokemon structs
}

//struct to hold the actual data in pokemon
struct PokemonDataSource {
    let urlString: String = "https://pokeapi.co/api/v2/pokemon/"
    
    //escaping and the () -> is really complicated to explain in lesson
    //we created a completion handler with method called completion (PokemonData) -> is type of variable
    //method that takes pokemonData and returns null
    //basically this function calls another function
    //basically if you didnt have this and everytime we get and post the app would halt or freeze
    //completion is not only good for networking but animations too, think about it
    //it returns null because its kind of like a void function
    func getPokemonData(completion: @escaping (PokemonData) -> ()) {
        guard let url = URL(string: urlString) else {return} // we created a url object with url given if its actually a url
        
        //making a request to the url object we made, has error so it will return an error like 404 or something if unsuccessful
        //response will return code 201 if successful
        //data is the actual data that is taken pictures etc
        //(data, response, error) is the data completion handler we can name it whatever we want but we named it data response error for semantic reasons
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let jsonData = data{
                /* below shows how to print out a get request if we were to not user postman
                        var jsonString = String(data: jsonData, encoding: String.Encoding.utf8)//you will never have to know how this line works
                        print(jsonString!) //shows we successfully made a request like what postman did but did it ourselves
                */
                
                //we do do and catch so that if at any point within the lines of code in do crasehs instead of crashing it prints error
                do{
                    //we use try so that if we try to format the json data like what if it is empty it wont crash
                    //basically we are converting jsonData type into PokemonData type by using decode method
                    let pokemonData = try JSONDecoder().decode(PokemonData.self, from: jsonData)
                    completion(pokemonData) //
                }catch{
                    print(error)
                }
                
            }
        }.resume()
    }
}


