//
//  ActiveGameViewModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ActiveGameViewModel: ObservableObject {
    @Published var players: [PlayingPlayer] = []
    @Published var game: Game?
    @Published var currentPlayer: PlayingPlayer?
    
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    init(game: Game?) {
        self.game = game
    }
    
    func fetchAllUsers() {
        guard let id = self.game?.id else {
            return
        }
        ref.collection("races").document(id).collection("players").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting documents", error)
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            self.players = documents.compactMap{ document -> PlayingPlayer? in
                
                return try? document.data(as: PlayingPlayer.self)
            }
            
        }
    }
    
    func fetchUser() {
        guard let id = self.game?.id else {
            return
        }
        
        ref.collection("races").document(id).collection("players").document(user).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting documents", error)
            }
            guard let document = snapshot else {
                print("No documents")
                return
            }
            
            
        }
    }
    
}
