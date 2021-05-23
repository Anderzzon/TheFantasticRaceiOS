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
    @Published var showAcceptAlert = false
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    init() {
        getAllGames()
    }
    
    func getAllGames() {
        ref.collection("races").whereField("listOfPlayersString", arrayContains: user)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents", error)
                }
                guard let documents = querySnapshot?.documents else {
                    self.noPosts = true
                    print("No documents get all games")
                    return
                }
                self.fetchedGames = documents.compactMap { document -> Game? in
                    return try? document.data(as: Game.self)
                    
                }
            }
    }
    
    func checkIfUserHasAccepted(game: Game, completion: @escaping (Bool) -> ()) {
        if let id = game.id {
            ref.collection("users").document(user).collection("invites").document(id).getDocument(completion: { snapshot, error in
                if let error = error {
                    print("Error getting documents", error)
                }
                
                guard let document = snapshot else {
                    print("No documents check for user accepted")
                    return
                }
                do {
                    let invitation = try document.data(as: Invitation.self)
                    if invitation?.accepted == false {
                        self.showAcceptAlert = true
                    }
                    completion(invitation!.accepted)
                } catch {
                    print("Error", error)
                }
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
