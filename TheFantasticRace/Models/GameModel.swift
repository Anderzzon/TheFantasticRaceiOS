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
        //lhs.start_time < rhs.start_time
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
    
    @DocumentID var id: String? = UUID().uuidString //Parent race only
    //var accepted: [String]? //Parent race only
    //var invites: [String]? //Parent race only
    var owner: String? //Parent race only
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

class PlayingPlayer: NSObject, Codable, Identifiable, Comparable {
    static func < (lhs: PlayingPlayer, rhs: PlayingPlayer) -> Bool {
        print("<")
        if lhs.finishedStops != rhs.finishedStops {
            return lhs.finishedStops > rhs.finishedStops
        } else if lhs.updatedTime! < rhs.updatedTime! {
            return true
        }
        return false
//        lhs.name < rhs.name
    }
    
//    static func == (lhs: PlayingPlayer, rhs: PlayingPlayer) -> Bool {
//        print("==")
//        if lhs.finishedStops == rhs.finishedStops {
//            if lhs.updatedTime! > rhs.updatedTime! {
//                return true
//            }
//
//        }
//        return false
////        lhs.name < rhs.name
//    }
    
    var name: String
    var id: String
    var lat: Double?
    var lng: Double?
    var finishedStops: Int
    var updatedTime: Date?
    
    init(name: String, id: String, lat: Double?, lng: Double?, finishedStops: Int, updatedTime: Date?) {
        self.name = name
        self.id = id
        self.lat = lat
        self.lng = lng
        self.finishedStops = finishedStops
        self.updatedTime = updatedTime
    }
    
//    convenience init?(document: [String: Any]) {
//        let name = document["name"] as? String ?? ""
//        let lat = document["lat"] as? Double
//        let lng = document["lng"] as? Double
//        let finishedStops = document["finishedStops"] as? Int ?? 0
//        let updatedTime = document ["updatedTime"] as? Date
//        
//        self.init(name: name,
//                  lat: lat,
//                  lng: lng,
//                  finishedStops: finishedStops,
//                  updatedTime: updatedTime
//                  )
//    }
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
//    required init(from decoder: Decoder) throws {
//        enum CodingKeys: CodingKey {
//            case id
//            case name
//            case lat
//            case lng
//            case order
//            case question
//            case answer
//            case hint
//        }
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(String.self, forKey: .id)
//        name = try values.decode(String.self, forKey: .name)
//        lat = try values.decode(Double.self, forKey: .lat)
//        lng = try values.decode(Double.self, forKey: .lng)
//        order = try values.decode(Int.self, forKey: .order)
//        question = try values.decode(String.self, forKey: .question)
//        answer = try values.decode(String.self, forKey: .answer)
//        hint = try values.decode(String.self, forKey: .hint)
//
//    }
    
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
        CLLocation(latitude: lat!, longitude: lng!).coordinate
    }
    var title: String? { name }
    var subtitle: String? { String(finishedStops) }
}
