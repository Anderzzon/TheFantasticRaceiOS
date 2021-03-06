//
//  NavigationRowViewModel.swift
//  The Fantastic Race
//
//  Created by Erik Westervind on 2021-05-17.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class NavigationRowViewModel {
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser?.uid
    @Published var numberOfPlayers = 0
    @Published var gameOwner = ""
    @Published var acceptedInvitation = false
    
    func getAcceptedUsers(game: Game) {
        if let id = game.id {
            ref.collection("races").document(id).collection("players").getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents", error)
                }
                
                guard let documents = querySnapshot?.documents else {
                    return
                }
                self.numberOfPlayers = documents.count
                
                let players = documents.compactMap { document -> Player? in
                    try? document.data(as: Player.self)
                }
                if (players.first(where: { $0.id == self.user }) == nil) {
                    self.acceptedInvitation = true
                }
                
            }
        }
    }
    
    func getNameOfGameOwner(game: Game) {
        if let id = game.owner {
            ref.collection("users").document(id).getDocument { document, error in
                if let error = error {
                    print("Error getting documents", error)
                }
                guard let document = document else {
                    print("No document")
                    return
                }
                let user = try? document.data(as: Player.self)
                if let user = user {
                    if user.id == self.user {
                        self.gameOwner = "Your game"
                    } else {
                        self.gameOwner = user.name
                    }
                }
            }
        } else {
            print("No id")
        }
    }
    
}
