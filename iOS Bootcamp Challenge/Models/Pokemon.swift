//
//  Pokemon.swift
//  iOS Bootcamp Challenge
//
//  Created by Jorge Benavides on 26/09/21.
//

import Foundation

// MARK: - Pokemon

enum PokemonType: String, Decodable, CaseIterable, Identifiable {

    var id: String { rawValue }

    case fire = "Fire"
    case grass = "Grass"
    case water = "Water"
    case poison = "Poison"
    case flying = "Flying"
    case electric = "Electric"
    case bug = "Bug"
    case normal = "Normal"
    case fighting = "Fighting"
    case ice = "Ice"
    case ground = "Ground"

}
struct abilitiesAux: Decodable, Equatable{
    let ability: abilityAux
    let is_hidden: Bool
    let slot: Int

}
struct abilityAux: Decodable, Equatable {
    let name: String
    let url: String
}
struct typesAux: Decodable, Equatable {
    let slot: Int
    let type: typeAux
}
struct typeAux: Decodable, Equatable{
    let name: String
    let url: String
}
struct Pokemon: Decodable, Equatable {
 
    let id: Int
    let name: String
    let image: String?
    let types: [String]?
    let abilities: [String]?
    let weight: Float
    let baseExperience: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case type
        case types
        case sprites
        case other
        case officialArtwork = "official-artwork"
        case frontDefault = "front_default"
        case abilities 
        case ability
        case weight
        case baseExperience = "base_experience"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let sprites = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .sprites)
        let other = try sprites.nestedContainer(keyedBy: CodingKeys.self, forKey: .other)
        let officialArtWork = try other.nestedContainer(keyedBy: CodingKeys.self, forKey: .officialArtwork)
        self.image = try? officialArtWork.decode(String.self, forKey: .frontDefault)

        // TODO: Decode list of types & abilities
        //https://pokeapi.co/api/v2/type/
        //https://pokeapi.co/api/v2/ability/
 
        /*let aux = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .abilities)
        let aux2 = try aux.nestedContainer(keyedBy: CodingKeys.self, forKey: .ability)*/

        
        //self.types = try? container.decode([String].self, forKey: .types)
        //self.abilities = []
        var array: [String] = []
        var arrayTypes: [String] = []
        let aux:[abilitiesAux] = try container.decode([abilitiesAux].self, forKey: .abilities)
        aux.forEach { ability in
            array.append(ability.ability.name)
        }
     
        let auxTypes:[typesAux] = try container.decode([typesAux].self, forKey: .types)
        auxTypes.forEach { type in
            arrayTypes.append(type.type.name)
        }
        self.abilities = array
        self.types = arrayTypes
        self.weight = try container.decode(Float.self, forKey: .weight)
        self.baseExperience = try container.decode(Int.self, forKey: .baseExperience)
    }

}

extension Pokemon {

    func formattedNumber() -> String {
        String(format: "#%03d", arguments: [id])
    }

    func primaryType() -> String? {
        guard let primary = types?.first else { return nil }
        return primary.capitalized
    }

    func secondaryType() -> String? {
        let index = 1
        guard index < types?.count ?? 0 else { return nil }
        return types?[index].capitalized
    }

}
