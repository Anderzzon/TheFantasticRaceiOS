//
//  GameModel.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-07.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable, Comparable {
    static func < (lhs: Game, rhs: Game) -> Bool {
        if let lhs = lhs.start_time, let rhs = rhs.start_time {
            return lhs < rhs
        }
        return false
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        if let lhs = lhs.start_time, let rhs = rhs.start_time {
            return lhs < rhs
        }
        return false
    }
    
    var name: String
    var description: String?
    var finishedStops: Int?
    var gameFinished: Bool?
    var listOfPlayers: [Player]?
    var listOfPlayersString: [String]?
    var parent_race: String?
    var radius: Double?
    var show_next_stop: Bool?
    var show_next_stop_delay: Double?
    var show_players_map: Bool?
    var start_time: Date?
    var finished_time: Date?
    var unlock_with_question: Bool?
    
    @DocumentID var id: String? = UUID().uuidString
    var owner: String?
    var stops: [GameStop]?
    
}

struct Player: Codable, Identifiable {
    
    var name: String
    var email: String
    var accepted: Bool?
    var id: String
    
    private enum CodingKeys: String, CodingKey {
        case name, email, accepted
        case id = "uid"
    }
}

struct Invitation: Codable {
    var accepted: Bool
}

class PlayingPlayer: NSObject, Codable, Identifiable, Comparable {
    static func < (lhs: PlayingPlayer, rhs: PlayingPlayer) -> Bool {
        if let lhsTime = lhs.updatedTime, let rhsTime = rhs.updatedTime {
            if lhs.finishedStops != rhs.finishedStops {
                return lhsTime > rhsTime
            } else if lhs.updatedTime! < rhs.updatedTime! {
                return true
            }
        }
        return false
    }
    
    var name: String
    var id: String
    var finishedStops: Int
    var updatedTime: Date?
    var latEncrypted: String?
    var lngEncrypted: String?
    
    init(name: String, id: String, finishedStops: Int, updatedTime: Date?, latEncrypted: String?, lngEncrypted: String?) {
        print("Init Playing player")
        self.name = name
        self.id = id
        self.finishedStops = finishedStops
        self.updatedTime = updatedTime
        self.latEncrypted = latEncrypted
        self.lngEncrypted = lngEncrypted
    }
    
}

class GameStop: NSObject, Codable, Identifiable {
    var id: String
    var name: String
    var lat: Double?
    var lng: Double?
    var order: Int
    var question: String?
    var answer: String?
    var hint: String?
    
    init(id: String, title: String, order: Int, lat: Double?, lng: Double?, question: String?, answer: String?, hint: String?) {
        self.id = id
        self.name = title
        self.order = order
        self.lat = lat
        self.lng = lng
        self.question = question
        self.answer = answer
        self.hint = hint
    }
    
}

extension GameStop: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocation(latitude: lat!, longitude: lng!).coordinate
    }
    var title: String? { name }
    var subtitle: String? { hint }
}

extension PlayingPlayer: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        if let lat = convertCoordinates(from: latEncrypted), let lng = convertCoordinates(from: lngEncrypted) {
            return CLLocation(latitude: lat, longitude: lng).coordinate
        }
        return CLLocation(latitude: 0.0, longitude: 0.0).coordinate
    }
    var title: String? { name }
    var subtitle: String? { String(finishedStops) }
    
    func convertCoordinates(from encrypted: String?) -> Double? {
        if let encrypted = encrypted {
            return (encrypted as NSString).doubleValue
        }
        return nil
    }
}
