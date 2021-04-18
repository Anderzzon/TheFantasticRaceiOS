//
//  CreateGameViewModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import Foundation
import Firebase

class CreateGameViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var radius: Double = 20
    
    @Published var game = Game(name: "New game",
                               description: "Your new game",
                               finishedStops: nil,
                               gameFinished: false,
                               listOfPlayers: nil,
                               parent_race: nil,
                               radius: 20,
                               show_next_stop: nil,
                               show_players_map: false,
                               start_time: nil,
                               finished_time: nil,
                               unlock_with_question: nil,
                               //id: UUID,
                               accepted: nil,
                               invites: nil,
                               owner: nil,
                               stops: nil)
    
    let ref = Firestore.firestore()
    
    func createGame(game: Game) {
//        do {
//            let _ = try ref.collection("races").addDocument(from: game)
//        }
//        catch {
//            print("Error saving:", error)
//        }
    }
}
