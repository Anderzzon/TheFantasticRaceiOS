//
//  GameModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-07.
//

import Foundation

struct Game: Codable {
    var name: String?
    var description: String?
    var finishedStops: Int?
    var gameFinished: Bool?
    var listOfPlayers: [String]?
    var parent_race: String?
    var radius: Int?
    var show_next_stop: Int?
    var show_players_map: Bool?
    var start_time: Date?
    var finished_time: Date?
    var unlock_with_question: Bool?
    var id: String? //Parent race only
    var accepted: [String]? //Parent race only
    var invites: [String]? //Parent race only
    var owner: String? //Parent race only
}
