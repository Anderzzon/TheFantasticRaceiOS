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
        lhs.name < rhs.name
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.name < rhs.name
    }
    
    var name: String
    var description: String?
    var finishedStops: Int?
    var gameFinished: Bool?
    var listOfPlayers: [String]?
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
