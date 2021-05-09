//
//  ActiveGameViewModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class ActiveGameViewModel: ObservableObject {
    @Published var players: [PlayingPlayer] = []
    @Published var game: Game?
    {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                print("Game dispatch")
                self.fetchAllUsers()
                self.fetchUser()
            }

        }
    }
    @Published var currentPlayer: PlayingPlayer?
    @Published var locationManager = LocationManager()
    
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = locationManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
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
                print("Document:", document.data())
                return try? document.data(as: PlayingPlayer.self)
            }
            
        }
    }
    
    func tryAnswerQuestion(with answer: String?, for stop: GameStop) -> Bool {
        guard let procedWithQuestion = game?.unlock_with_question else { return false }
        
        if procedWithQuestion {
            guard let answer = answer else { return false }
            let result = answerQuestion(with: answer, for: stop)
            switch result {
            case true:
                print("Anser is correct")
                updateToFirebase()
                createGeofence()
                return true
                //Update and proced to next stop
            case false:
                return false
            }
        }
        return false
    }
    
    func fetchUser() {
        guard let id = self.game!.id else {
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
            self.currentPlayer = try? document.data(as: PlayingPlayer.self)
            self.startGame()
        }
    }
    
    private func startGame() {
        createGeofence()
    }
    
    private func createGeofence() {
        guard let player = currentPlayer?.finishedStops else { return }
        guard let game = game else { return }
        guard let stop = game.stops?[player] else { return }
        locationManager.createGeofence(for: stop, with: game.radius!)
    }
    
    private func answerQuestion(with answer: String, for stop: GameStop) -> Bool {
        guard let correctAnswer = stop.answer else { return false }
        return answer == correctAnswer ? true : false
    }
    
    private func updateToFirebase() {
        currentPlayer!.finishedStops = currentPlayer!.finishedStops + 1
        currentPlayer?.updatedTime = Date()
        if let id = game!.id {
            let docRef = ref.collection("races").document(id).collection("players").document(user)
            do {
                try docRef.setData(from: self.currentPlayer)
            } catch {
                print(error)
            }
        }
    }
    
    func updateMap() {
        guard let game = game else { return }
        if game.show_next_stop! {
            if let delay = game.show_next_stop_delay {
                //Start timer and show next stop after
            }
        } else {
            //Show next stop direct
        }
    }
    
}
