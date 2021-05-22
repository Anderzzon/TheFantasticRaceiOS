//
//  FBDataModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var noPosts = false
    @Published var fetchedGames: [Game] = []
    @Published var players: [Player] = []
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    @Published var showAcceptAlert = false
    
    init() {
        getAllGames()
    }
    
    func getAllGames() {
        
        //ref.collection("users").document(user).collection("races_invited").addSnapshotListener { (querySnapshot, error) in
        ref.collection("races").whereField("listOfPlayersString", arrayContains: user)
            .addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents", error)
            }
            guard let documents = querySnapshot?.documents else {
                self.noPosts = true
                print("No documents")
                return
            }
            self.fetchedGames = documents.compactMap { document -> Game? in
                return try? document.data(as: Game.self)
                
            }
            //            self.fetchedGames = documents.map { (querySnapshot) -> Game in
            //                let data = querySnapshot.data()
            //
            //                let name = data["name"] as? String
            //                let description = data["description"] as? String
            //                let finishedStops = data["finishedStops"] as? Int
            //                let gameFinished = data["gameFinished"] as? Bool
            //                let listOfPlayers = data["listOfPlayers"] as? [String]
            //                let parent_race = data["parent_race"] as? String
            //                let radius = data["radius"] as? Double
            //                let show_next_stop_delay = data["show_next_stop"] as? Double
            //                let show_players_map = data["show_players_map"] as? Bool
            //                let start_time = data["start_time"] as? Date
            //                let finished_time = data["finished_time"] as? Date
            //                let unlock_with_question = data["unlock_with_question"] as? Bool
            //                let id = data["id"] as? String
            //                let accepted = data["accepted"] as? [String]
            //                let invites = data["invites"] as? [String]
            //                let owner = data["owner"] as? String
            //                let stops = data["stops"] as? [GameStop]
            //
            //                print("Game", name)
            //                return Game(name: name, description: description, finishedStops: finishedStops, gameFinished: gameFinished, listOfPlayers: listOfPlayers, parent_race: parent_race, radius: radius, show_next_stop_delay: show_next_stop_delay, show_players_map: show_players_map, start_time: start_time, finished_time: finished_time, unlock_with_question: unlock_with_question, id: id, owner: owner, stops: stops)
            //            }
        }
    }
    
    func checkIfUserHasAccepted(game: Game, completion: @escaping (Bool) -> ()) {
        if let id = game.id {
            ref.collection("users").document(user).collection("invites").document(id).getDocument(completion: { snapshot, error in
                if let error = error {
                    print("Error getting documents", error)
                }
                
                guard let document = snapshot else {
                    print("No documents")
                    return
                }
                print("Document:", document.data())
                do {
                    let invitation = try document.data(as: Invitation.self)
                    if invitation?.accepted == false {
                        self.showAcceptAlert = true
                    }
                    completion(invitation!.accepted)
                } catch {
                    print("Error", error)
                }
                
                //self.startGame()

                
            })
        }
    }
    
    func updateInvitation(game: Game) {
        let invitation = Invitation(accepted: true)
        if let id = game.id {
            let docRef = ref.collection("users").document(user).collection("invites").document(id)
            do {
                try docRef.setData(from: invitation)
            }
            catch {
                print(error)
            }
        }
    }


}
