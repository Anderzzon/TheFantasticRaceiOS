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
            self.players.removeAll()
            self.fetchUser()
            
            if let startTime = self.game?.start_time {
                if startTime <= Date() {
                    
                    self.fetchAllUsers()
                    self.startTimer()
                    self.locationManager.startLocationServices()
                    self.locationManager.gameName = self.game?.name ?? "Current Game"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if self.user != self.game?.owner {
                            self.startGame()
                        }
                    }
                } else {
                    //TODO: Start timer than runs until start of game
                }
            }
        }
    }
    @Published var currentPlayer: PlayingPlayer?
    @Published var locationManager = LocationManager()
    @Published var stopOverlays = MKCircle()
    @Published var gameFinished = false
    static var playerPositionTimer: Timer?
    static var showNextStopWithDelayTimer: Timer?
    
    let ref = Firestore.firestore()
    let user = Auth.auth().currentUser!.uid
    let encryption = Crypto()
    
    var anyCancellable: AnyCancellable? = nil
    var gameisSetToFinished = false
    @Published var showFinishedAlert = false
    
    init() {
        anyCancellable = locationManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
            
            if self?.locationManager.gameFinished == true && self?.gameisSetToFinished == false {
                self?.gameisSetToFinished = true
                self?.updateToFirebase()
                self?.showFinishedAlert = true
                self?.gameFinished = true
            }
        }
    }
    
    //MARK: Public functions:
    
    func startTimer() {
        ActiveGameViewModel.playerPositionTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            self.updatePlayerPosition()
            //print("Users current location:", self.locationManager.locationManager.location)
        }
    }
    
    func stopTimer() {
        ActiveGameViewModel.playerPositionTimer?.invalidate()
    }
    
    func answerQuestion(with answer: String?, for stop: GameStop) -> Bool {
        guard let procedWithQuestion = game?.unlock_with_question else { return false }
        
        if procedWithQuestion {
            guard let answer = answer else { return false }
            let result = checkAnswer(with: answer, for: stop)
            switch result {
            case true:
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
    
    func handleGameFinished() {
        updateToFirebase()
        gameFinished = false
    }
    
    //MARK: Private functions
    
    private func startGame() {
        self.createGeofence()
        //self.updateMap()
    }
    
    private func createGeofence() {
        guard let player = currentPlayer?.finishedStops else { return }
        guard let game = game else { return }
        if player <= game.stops!.count-1 {
            guard let stop = game.stops?[player] else { return }
            let lastStop = isLastStop(stop: stop, for: game)
            locationManager.createGeofence(for: stop, with: game.radius!, isLastStop: lastStop)
            updateMap()
        }
    }
    
    private func isLastStop(stop: GameStop, for game: Game) -> Bool {
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
        guard let game = game else { return }
        
        //The map will display the next stop, by checking number of finished stops of currentPlayer
        if let finishedStops = currentPlayer?.finishedStops, let totalStopsOfGame = game.stops?.count {
            
            if finishedStops <= totalStopsOfGame - 1 {
                if finishedStops == 0 { //Always show first stop direct
//                    if let radius = game.radius {
//                        let overlay = MKCircle(center: game.stops![finishedStops].coordinate, radius: radius)
//                        stopOverlays = overlay
//                    }
                    addOverlay()
                } else if game.show_next_stop! && finishedStops != 0 {
                    if game.show_next_stop_delay == nil || game.show_next_stop_delay == 0.0 { //Show next stop direct
//                        if let radius = game.radius {
//                            let overlay = MKCircle(center: game.stops![finishedStops].coordinate, radius: radius)
//                            stopOverlays = overlay
//                        }
                        addOverlay()
                    } else {
                        //TODO: Create function for displaying stops with a delay
                        showNextStopWithDelay()
                    }
                }
            }
        }
    }
    
    private func showNextStopWithDelay() {
        guard let updatedTime = currentPlayer?.updatedTime else { return }
        guard let delayTime = game?.show_next_stop_delay else { return }
        //let timeToShowNextStop = updatedTime.addingTimeInterval(10) //For testing
        let timeToShowNextStop = updatedTime.addingTimeInterval(delayTime * 60)
        if Date() < timeToShowNextStop {
            stopOverlays = MKCircle()
            ActiveGameViewModel.showNextStopWithDelayTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if Date() > timeToShowNextStop {
                    self.addOverlay()
                    ActiveGameViewModel.showNextStopWithDelayTimer?.invalidate()
                }
            }
        } else {
            addOverlay()
        }
    }
    
    private func addOverlay() {
        guard let game = game else { return }
        if let finishedStops = currentPlayer?.finishedStops {
            if let radius = game.radius {
                let overlay = MKCircle(center: game.stops![finishedStops].coordinate, radius: radius)
                stopOverlays = overlay
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
                print("No documents fetchAllUsers")
                return
            }
            
            self.players = documents.compactMap{ document -> PlayingPlayer? in
                return try? document.data(as: PlayingPlayer.self)
            }
            for player in self.players {
                self.decryptCoordinates(player: player)
            }
            
        }
    }
    
    private func decryptCoordinates(player: PlayingPlayer) {
        if let encryptedLat = player.latEncrypted {
            player.latEncrypted = self.encryption.decryptData(input: encryptedLat, password: self.encryption.createKey(key: Crypto.key))
        }
        if let encryptedLng = player.lngEncrypted {
            player.lngEncrypted = self.encryption.decryptData(input: encryptedLng, password: self.encryption.createKey(key: Crypto.key))
        }
    }
    
    func fetchUser() {
        guard let id = self.game!.id else { return }
        
        ref.collection("races").document(id).collection("players").document(user).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting documents", error)
            }
            guard let document = snapshot else {
                print("No documents user")
                return
            }
            self.currentPlayer = try? document.data(as: PlayingPlayer.self)
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
        guard let player = currentPlayer else { return }
        
        if let lat = locationManager.locationManager.location?.coordinate.latitude, let lng = locationManager.locationManager.location?.coordinate.longitude {
            do {
                player.latEncrypted = try encryption.encryptData(input: String(lat), password: encryption.symetricKey!)
                player.lngEncrypted = try encryption.encryptData(input: String(lng), password: encryption.symetricKey!)
            } catch {
                print("Error encrypting")
            }
            if let id = game!.id {
                let docRef = ref.collection("races").document(id).collection("players").document(user)
                do {
                    print("Location updated to Firebase")
                    try docRef.setData(from: player)
                } catch {
                    print("Error", error)
                }
            }
        }
        
    }
    
}
