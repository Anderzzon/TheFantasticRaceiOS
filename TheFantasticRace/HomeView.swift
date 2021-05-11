//
//  HomeView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-06.
//

import SwiftUI
import FirebaseAuth

enum ActiveGameSheet {
    case newGame, activeGame
}

enum Tagss: String {
    case test
    
    var fbString: String? {
        switch self {
        case .test:
            return "test"
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var showError = false
    @State private var errorString = ""
    //@StateObject private var locationManager = LocationManager()
    @StateObject var games = FBDataModel()
    var game = Game(name: "New Game", description: nil, finishedStops: nil, gameFinished: nil, listOfPlayers: nil, parent_race: nil, radius: 20, show_next_stop: true, show_next_stop_delay: 5, show_players_map: false, start_time: nil, finished_time: nil, unlock_with_question: true, id: nil, owner: nil, stops: nil)
    
    @ObservedObject var viewModel = CreateGameViewModel(selectedGame: Game(name: "New Game", description: nil, finishedStops: nil, gameFinished: nil, listOfPlayers: nil, parent_race: nil, radius: 20, show_next_stop: true, show_next_stop_delay: 5, show_players_map: false, start_time: nil, finished_time: nil, unlock_with_question: true, id: nil, owner: nil, stops: nil))
    
    @State private var activeGame: Game?
    
    @State private var activeGameSheet: ActiveGameSheet = .activeGame
    @State private var showGameSheet = false
    @StateObject var playingGame = ActiveGameViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if games.fetchedGames.count == 0 {
                    Text("No games here 😢! Create your first or ask a friend for an invitation").padding()
                } else {
                    LazyVStack {
                        //Print("VStack Load")
                        ForEach(games.fetchedGames.sorted()) { game in
                            //Text(game.name!)
                            
                            //Print(game)
                            NavigationRow(game: game).onTapGesture {
                                //self.viewModel.game = game
                                if game.owner == userInfo.user.uid {
                                    activeGame = nil
                                    activeGame = game
                                    activeGameSheet = .newGame
                                    showGameSheet = true
                                } else {
                                    //locationManager.startLocationServices()
                                    activeGame = game
                                    playingGame.game = activeGame
                                    //Print("Game in viewModel:", playingGame.game)
                                    //activeGame = game
                                    activeGameSheet = .activeGame
                                    showGameSheet = true
                                }
                                print(viewModel.game, "tapped")
                            }
                            
                        }
                    }
                }
            }
            .navigationBarTitle("All games")
            .navigationBarItems(trailing: Button(action: {
                                                    viewModel.game = game
                                                    activeGame = game
                                                    showGameSheet = true
                                                    print("add game")}, label: {
                                                        Image(systemName: "plus").foregroundColor(Color("FRpurple"))
                                                            .padding()
                                                    }))
            .onAppear {
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                FBFirestore.retrieveFBUser(uid: uid) { (result) in
                    switch result {
                    case .failure(let error):
                        print("Error retreiving user:",error.localizedDescription)
                    case .success(let user):
                        self.userInfo.user = user
                    }
                }
            }
            .fullScreenCover(isPresented: $showGameSheet) {
                if activeGameSheet == .newGame {
                    let viewModel = CreateGameViewModel(selectedGame: activeGame!)
                    CreateGame(viewModel: viewModel).environmentObject(userInfo)
                } else {
                    //Print("Game in viewModel:", playingGame.game)
                    let viewModel = ActiveGameViewModel()
                    ActiveGameView(viewModel: playingGame)
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error creating user"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
