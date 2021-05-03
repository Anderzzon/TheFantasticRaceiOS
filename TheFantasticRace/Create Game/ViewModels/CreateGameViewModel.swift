//
//  CreateGameViewModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class CreateGameViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var radius: Double = 20
    @Published var showNextStop: Bool = true
    @Published var testStops = [
        GameStop(id: UUID().uuidString, title: "One stop", order: 0),
        GameStop(id: UUID().uuidString, title: "Two stop", order: 1),
        GameStop(id: UUID().uuidString, title: "Three stop", order: 2),
        GameStop(id: UUID().uuidString, title: "Four stop", order: 3),
        GameStop(id: UUID().uuidString, title: "Five stop", order: 4)
    ]
    
    @Published var game = Game(name: "New game",
                               description: "Your new game",
                               finishedStops: nil,
                               gameFinished: false,
                               listOfPlayers: nil,
                               parent_race: nil,
                               radius: 20,
                               show_next_stop: false,
                               show_next_stop_delay: 0,
                               show_players_map: false,
                               start_time: nil,
                               finished_time: nil,
                               unlock_with_question: true,
                               id: UUID().uuidString,
                               //accepted: nil,
                               //invites: nil,
                               owner: nil,
                               stops: nil)
    
    let ref = Firestore.firestore()
    
    func createGame(game: Game) {
        do {
            let _ = try ref.collection("races").addDocument(from: game)
        }
        catch {
            print("Error saving:", error)
        }
    }
    
    func reorderStop() {
        // move the data here
        
        for(index, item) in testStops.enumerated() {
            self.testStops[index].order = index
            print(testStops[index].order,":", testStops[index].title)
        }
        
    }
    
    func newStop(stop: GameStop) {
        var newStop = GameStop(id: stop.id,
                               title: stop.title,
                               order: stop.order)
        
        //Check for optional bindings
        if stop.hint != nil || stop.hint != "" {
            newStop.hint = stop.hint
        }
        if stop.hint == "" {
            newStop.hint = nil
        }
        
        if stop.question != nil || stop.question != "" {
            newStop.question = stop.question
        }
        if stop.question == "" {
            newStop.question = nil
        }
        
        if stop.answer != nil || stop.answer != "" {
            newStop.answer = stop.answer
        }
        if stop.answer == "" {
            newStop.answer = nil
        }
        
        if stop.lat != nil || stop.lat != 0 {
            newStop.lat = stop.lat
        }
        if stop.lat == 0 {
            newStop.lat = nil
        }
        
        if stop.lng != nil || stop.lng != 0 {
            newStop.lng = stop.lng
        }
        if stop.lng == 0 {
            newStop.lng = nil
        }
        if game.stops == nil {
            game.stops = [newStop]
        } else {
            game.stops!.append(newStop)
        }
        
    }
}
