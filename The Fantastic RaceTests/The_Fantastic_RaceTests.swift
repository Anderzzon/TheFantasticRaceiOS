//
//  The_Fantastic_RaceTests.swift
//  The Fantastic RaceTests
//
//  Created by Erik Westervind on 2021-05-23.
//

import XCTest
import Firebase
import FirebaseFirestoreSwift
@testable import TheFantasticRace

class TheFantasticRaceTests: XCTestCase {
    
    let incorectStops = [GameStop(id: UUID().uuidString, title: "Stop 1", order: 0, lat: nil, lng: nil, question: nil, answer: nil, hint: nil), GameStop(id: UUID().uuidString, title: "Stop 2", order: 1, lat: nil, lng: nil, question: nil, answer: nil, hint: nil)]
    
    let correctStops = [GameStop(id: UUID().uuidString, title: "Stop 1", order: 0, lat: nil, lng: nil, question: "Funkar denna?", answer: "ja", hint: nil), GameStop(id: UUID().uuidString, title: "Stop 2", order: 1, lat: nil, lng: nil, question: "Funkar denna?", answer: "Ja", hint: nil), GameStop(id: UUID().uuidString, title: "Stop 3", order: 2, lat: nil, lng: nil, question: "Funkar denna?", answer: "Ja", hint: nil)]
    
    let activeGame = Game(name: "Test Game",
                        description: nil,
                        finishedStops: nil,
                        gameFinished: nil,
                        listOfPlayers: nil,
                        listOfPlayersString: nil,
                        parent_race: nil,
                        radius: 20,
                        show_next_stop: true,
                        show_next_stop_delay: nil,
                        show_players_map: nil,
                        start_time: nil,
                        finished_time: nil,
                        unlock_with_question: true,
                        id: nil,
                        owner: nil,
                        stops: nil)
    
    func test_Check_Stop_Validation_Expect_false() {
        let testGame = Game(name: "Test Game",
                            description: nil,
                            finishedStops: nil,
                            gameFinished: nil,
                            listOfPlayers: nil,
                            listOfPlayersString: nil,
                            parent_race: nil,
                            radius: nil,
                            show_next_stop: nil,
                            show_next_stop_delay: nil,
                            show_players_map: nil,
                            start_time: nil,
                            finished_time: nil,
                            unlock_with_question: true,
                            id: nil,
                            owner: nil,
                            stops: incorectStops)
        let createGameVM = CreateGameViewModel(selectedGame: testGame)
        
        createGameVM.checkStopValidation()
        XCTAssertEqual(createGameVM.validStops, false)
    }
    
    func test_Check_Stop_Validation_Expect_true() {
        let testGame = Game(name: "Test Game",
                            description: nil,
                            finishedStops: nil,
                            gameFinished: nil,
                            listOfPlayers: nil,
                            listOfPlayersString: nil,
                            parent_race: nil,
                            radius: nil,
                            show_next_stop: nil,
                            show_next_stop_delay: nil,
                            show_players_map: nil,
                            start_time: nil,
                            finished_time: nil,
                            unlock_with_question: true,
                            id: nil,
                            owner: nil,
                            stops: correctStops)
        let createGameVM = CreateGameViewModel(selectedGame: testGame)
        print(createGameVM.game.stops?.count)
        
        createGameVM.checkStopValidation()
        XCTAssertEqual(createGameVM.validStops, true)
    }
    
    func test_Check_Answer_Question_Expect_false() {
        let activeGameVM = ActiveGameViewModel()
        activeGameVM.game = activeGame
        
        let result = activeGameVM.answerQuestion(with: "Fel", for: correctStops[0])
        
        XCTAssertEqual(result, false)
        
    }
    
    func test_Check_Answer_Question_Expect_true() {
        let activeGameVM = ActiveGameViewModel()
        activeGameVM.game = activeGame
        
        let result = activeGameVM.answerQuestion(with: "Ja", for: correctStops[0])
        
        XCTAssertEqual(result, false)
        
    }

}
