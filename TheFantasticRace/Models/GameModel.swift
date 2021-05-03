//
//  GameModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-07.
//

import Foundation
import SwiftUI

struct Game: Codable, Identifiable, Comparable {
    static func < (lhs: Game, rhs: Game) -> Bool {
        lhs.name! < rhs.name!
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.name! < rhs.name!
    }
    
    var name: String?
    var description: String?
    var finishedStops: Int?
    var gameFinished: Bool?
    var listOfPlayers: [String]?
    var parent_race: String?
    var radius: Double?
    var show_next_stop: Bool?
    var show_next_stop_delay: Double?
    var show_players_map: Bool?
    var start_time: Date?
    var finished_time: Date?
    var unlock_with_question: Bool?
    
    var id: String? //Parent race only
    //var accepted: [String]? //Parent race only
    //var invites: [String]? //Parent race only
    var owner: String? //Parent race only
    var stops: [GameStop]?
    
}

struct GameStop: Codable, Identifiable {
    var id: String
    var title: String
    var lat: Double?
    var lng: Double?
    var order: Int
    var question: String?
    var answer: String?
    var hint: String?
    
}
