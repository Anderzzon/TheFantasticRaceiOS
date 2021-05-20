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
import MapKit

class ActiveGameViewModel: ObservableObject {
    @Published var players: [PlayingPlayer] = []
    @Published var game: Game?
    {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Game dispatch", self.game)
                self.players.removeAll()
                self.fetchAllUsers()
                self.fetchUser()
                self.startTimer()
                self.locationManager.startLocationServices()
                self.locationManager.gameName = self.game?.name ?? "Current Game"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let game = self.game {
                        if let startTime = game.start_time {
                            if startTime <= Date() {
                                self.startGame()
                            } else {
                                //TODO: Start timer than runs until start of game
                            }
                        }
                    }
                }
            }
        }
    }
    @Published var currentPlayer: PlayingPlayer?
    @Published var locationManager = LocationManager()
    //@Published var showSheet = false
    @Published var stopOverlays = MKCircle()
    @Published var gameFinished = false
    static var playerPositionTimer: Timer?
    
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    
    var anyCancellable: AnyCancellable? = nil
    var gameisSetToFinished = false
    @Published var showFinishedAlert = false
    
    init() {
        anyCancellable = locationManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
            
            if self?.locationManager.gameFinished == true && self?.gameisSetToFinished == false {
                print("anyCancellable gameFinished", self?.locationManager.gameFinished)
                self?.gameisSetToFinished = true
                self?.updateToFirebase()
                self?.showFinishedAlert = true
                self?.gameFinished = true
            }
        }
    }
    
    func startTimer() {
        ActiveGameViewModel.playerPositionTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            print("Timer fired!")
            self.updatePlayerPosition()
        }
    }
    
    func stopTimer() {
        ActiveGameViewModel.playerPositionTimer?.invalidate()
    }
    
    //MARK: Public functions:
    
    func answerQuestion(with answer: String?, for stop: GameStop) -> Bool {
        guard let procedWithQuestion = game?.unlock_with_question else { return false }
        
        if procedWithQuestion {
            guard let answer = answer else { return false }
            let result = checkAnswer(with: answer, for: stop)
            switch result {
            case true:
                print("Answer is correct")
                if let region = locationManager.geofenceRegion {
                    locationManager.removeGeofence(for: region)
                }
                updateToFirebase()
                createGeofence()
                
                return true
            case false:
                return false
            }
        }
        return false
    }
    
    //MARK: Private functions
    
    private func startGame() {
        print("Starting game")
        self.createGeofence()
        self.updateMap()
    }
    
    func handleGameFinished() {
        //gameFinished = true
        updateToFirebase()
        gameFinished = false
    }
    
    private func createGeofence() {
        guard let player = currentPlayer?.finishedStops else { return }
        print("Finished stops:", player)
        guard let game = game else { return }
        if player <= game.stops!.count-1 {
            guard let stop = game.stops?[player] else { return }
            let lastStop = isLastStop(stop: stop, for: game)
            locationManager.createGeofence(for: stop, with: game.radius!, isLastStop: lastStop)
            updateMap()
        }
    }
    private func isLastStop(stop: GameStop, for game: Game) -> Bool {
        print("StopOrder:", stop.order)
        print("LocationManager:", locationManager.gameFinished)
        if stop.order + 1 == game.stops?.count {
            return true
        }
        return false
    }
    
    private func checkAnswer(with answer: String, for stop: GameStop) -> Bool {
        guard let correctAnswer = stop.answer else { return false }
        return answer == correctAnswer ? true : false
    }
    
    private func updateMap() {
        guard let game = game else {
            print("update map guard game return")
            return }
        //The map will display the next stop, by checking number of finished stops of currentPlayer
        if let finishedStops = currentPlayer?.finishedStops, let totalStopsOfGame = game.stops?.count {
            
            if finishedStops  <= totalStopsOfGame - 1 {
                if finishedStops == 0 { //Always show first stop direct
                    if let radius = game.radius {
                        let overlay = MKCircle(center: game.stops![finishedStops].coordinate, radius: radius)
                        stopOverlays = overlay
                    }
                } else if game.show_next_stop! && finishedStops != 0 {
                    if game.show_next_stop_delay == nil || game.show_next_stop_delay == 0.0 { //Show next stop direct
                        if let radius = game.radius {
                            let overlay = MKCircle(center: game.stops![finishedStops].coordinate, radius: radius)
                            stopOverlays = overlay
                        }
                    } else {
                        //TODO: Create function for displaying stops with a delay
                        if let radius = game.radius {
                            let overlay = MKCircle(center: game.stops![finishedStops].coordinate, radius: radius)
                            stopOverlays = overlay
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Firebase functions:
    
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
    
    func fetchUser() {
        guard let id = self.game!.id else {
            print("guard return no game id")
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
            print("Current player in Firebase:", self.currentPlayer)
            //self.startGame()
        }
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
    
    private func updatePlayerPosition() {
        guard let player = currentPlayer else {
            print("No player guard return")
            return
        }
        if let lat = locationManager.locationManager.location?.coordinate.latitude, let lng = locationManager.locationManager.location?.coordinate.longitude {
            player.lat = lat
            player.lng = lng
            if let id = game!.id {
                let docRef = ref.collection("races").document(id).collection("players").document(user)
                do {
                    try docRef.setData(from: player)
                } catch {
                    print("Error", error)
                }
            }
        }
        
    }
    
}
