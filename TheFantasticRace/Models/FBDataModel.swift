//
//  FBDataModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-07.
//

import Foundation
import Firebase

class FBDataModel: ObservableObject {
    @Published var noPosts = false
    @Published var games: [Game] = []
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    init() {
        getAllGames()
    }
    
    func getAllGames() {
        
        ref.collection("users").document(user).collection("races_invited").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                self.noPosts = true
                print("No documents")
                return
            }
            self.games = documents.map { (querySnapshot) -> Game in
                let data = querySnapshot.data()
                
                let name = data["name"] as? String
                let description = data["description"] as? String
                let finishedStops = data["finishedStops"] as? Int
                let gameFinished = data["gameFinished"] as? Bool
                let listOfPlayers = data["listOfPlayers"] as? [String]
                let parent_race = data["parent_race"] as? String
                let radius = data["radius"] as? Int
                let show_next_stop = data["show_next_stop"] as? Int
                let show_players_map = data["show_players_map"] as? Bool
                let start_time = data["start_time"] as? Date
                let finished_time = data["finished_time"] as? Date
                let unlock_with_question = data["unlock_with_question"] as? Bool
                let id = data["id"] as? String
                let accepted = data["accepted"] as? [String]
                let invites = data["invites"] as? [String]
                let owner = data["owner"] as? String
                
                return Game(name: name, description: description, finishedStops: finishedStops, gameFinished: gameFinished, listOfPlayers: listOfPlayers, parent_race: parent_race, radius: radius, show_next_stop: show_next_stop, show_players_map: show_players_map, start_time: start_time, finished_time: finished_time, unlock_with_question: unlock_with_question, id: id, accepted: accepted, invites: invites, owner: owner)
            }
        }
    }
}
