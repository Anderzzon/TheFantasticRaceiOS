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
import MapKit

enum Tags: String {
    case test
}

class CreateGameViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var radius: Double = 20
    @Published var showNextStop: Bool = true
    @Published var players: [Player] = []
    @Published var query = ""
    @Published var validStops = true
    
    @Published var game: Game
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
//    @Published var game = Game(name: "New game",
//                               description: "Your new game",
//                               finishedStops: nil,
//                               gameFinished: false,
//                               listOfPlayers: nil,
//                               parent_race: nil,
//                               radius: 20,
//                               show_next_stop: false,
//                               show_next_stop_delay: 0,
//                               show_players_map: false,
//                               start_time: nil,
//                               finished_time: nil,
//                               unlock_with_question: true,
//                               id: UUID().uuidString,
//                               //accepted: nil,
//                               //invites: nil,
//                               owner: nil,
//                               stops: nil)
    
    init(selectedGame: Game) {
        self.game = selectedGame
    }
    
    func createGame(game: Game) {
        self.game = game
        do {
            let _ = try ref.collection("races").addDocument(from: self.game)
        }
        catch {
            print("Error saving:", error)
        }
    }
    
    func updateGame(game: Game) {
        self.game = game
        if let id = game.id {
            let docRef = ref.collection("races").document(id)
            do {
                try docRef.setData(from: self.game)
            }
            catch {
                print(error)
            }
        }
    }
    
    func reorderStop() {
        for(index, item) in self.game.stops!.enumerated() {
            self.game.stops![index].order = index
            
        }
        
    }
    
    func createCenterCoordinate(stop: GameStop) -> CLLocationCoordinate2D? {
        
        var location = CLLocationCoordinate2D()
        if stop.lat != nil && stop.lng != nil {
            location = CLLocationCoordinate2D(latitude: stop.lat!, longitude: stop.lng!)
        }
        return location
    }
    
    func newStop(stop: GameStop) {
        var newStop = GameStop(id: stop.id,
                               title: stop.name,
                               order: stop.order,
                               lat: stop.lat,
                               lng: stop.lng,
                               question: stop.question,
                               answer: stop.answer,
                               hint: stop.hint)
        
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
    
    func searchUser(searchQuery: String) {

        let usersRef = ref.collection("users")
        let query = usersRef.whereField("name", isGreaterThanOrEqualTo: searchQuery)
        query.getDocuments { (query, error) in
            if let error = error {
                print("Error fetching users", error)
            }
            guard let documents = query?.documents else {
                print("No users")
                return
            }
            self.players = documents.compactMap { document -> Player? in
                print("Players:", self.players)
                do {
                    if searchQuery == "" {
                        self.players = []
                        return nil
                    }
                    return try document.data(as: Player.self)
                } catch {
                    print("Error")
                    print(error)
                }
               
                return nil
            }
        }
    }
    
    func inviteUserToGame(player: Player) {
        let invitedPlayer = Player(name: player.name, email: player.email, accepted: false, id: player.id)
        if (self.game.listOfPlayers?.first(where: { $0.id == player.id })) != nil {
            print("User allready added")
        } else {
            if self.game.listOfPlayers == nil {
                self.game.listOfPlayers = []
                self.game.listOfPlayersString = []
                self.game.listOfPlayersString?.append(user) //The game owner needs to be in this array in order for the Firebase query to work
            }
            print("Inviting user")
            self.game.listOfPlayers?.append(invitedPlayer)
            self.game.listOfPlayersString?.append(invitedPlayer.id)
        }
    }
    
    func checkStopValidation() { //See test
        //TODO: Add more logic
        if let stops = game.stops {
            if self.game.unlock_with_question == true {
                for stop in stops {
                    if stop.order != stops.count-1 { //Checks every question exept the last one
                        if stop.question == nil || stop.question!.count < 1 || stop.answer == nil || stop.answer!.count < 1 {
                            validStops = false
                            print("Some questions is not valid")
                            return
                        } else {
                            validStops = true
                        }
                    }
                }
            }
        }
    }
}
