//
//  HomeView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-06.
//

import SwiftUI
import FirebaseAuth
import AlertX

enum ActiveGameSheet {
    case newGame, activeGame
}

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var showError = false
    @State private var errorString = ""
    @StateObject var games = HomeViewModel()
    var newGame = Game(name: "New Game", description: nil, finishedStops: nil, gameFinished: nil, listOfPlayers: nil, parent_race: nil, radius: 20, show_next_stop: true, show_next_stop_delay: 5, show_players_map: false, start_time: nil, finished_time: nil, unlock_with_question: true, id: nil, owner: nil, stops: nil)
    
    @StateObject var viewModel = CreateGameViewModel(selectedGame: Game(name: "New Game", description: nil, finishedStops: nil, gameFinished: nil, listOfPlayers: nil, parent_race: nil, radius: 20, show_next_stop: true, show_next_stop_delay: 5, show_players_map: false, start_time: nil, finished_time: nil, unlock_with_question: true, id: nil, owner: nil, stops: nil))
    
    @State private var activeGame: Game?
    
    @State private var activeGameSheet: ActiveGameSheet = .activeGame
    @State private var showGameSheet = false
    
    @StateObject var playingGame = ActiveGameViewModel()
    @State private var showAlertX = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if games.fetchedGames.count == 0 {
                    Text("No games here 😢! Create your first or ask a friend for an invitation").padding()
                } else {
                    LazyVStack {
                        ForEach(games.fetchedGames.sorted()) { game in
                            
                            NavigationRow(game: game).onTapGesture {
                                let date = Date()
                                if game.owner == userInfo.user.uid {
                                    print("Own game")
                                    if game.start_time! < date {
                                        print("Watch game")
                                        playingGame.game = game
                                        activeGameSheet = .activeGame
                                        showGameSheet = true
                                    } else {
                                        print("Edit game")
                                        activeGame = game
                                        viewModel.game = activeGame!
                                        activeGameSheet = .newGame
                                        showGameSheet = true
                                    }
                                } else {
                                    print("Invited game")
                                    playingGame.game = game
                                    games.checkIfUserHasAccepted(game: game) { accepted in
                                        switch accepted {
                                        case true:
                                            activeGameSheet = .activeGame
                                            showGameSheet = true
                                            
                                        case false:
                                            print("Not accepted")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .alert(isPresented:$games.showAcceptAlert) {
                        Alert(
                            title: Text("You are invited to game"),
                            message: Text("Do you want to join the game?"),
                            primaryButton: .destructive(Text("Yes")) {
                                games.updateInvitation(game: playingGame.game!)
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .background(Color(.systemGray4).opacity(0.8).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("All games")
            .navigationBarItems(
                leading: Button(action: {
                    FBAuth.logout { result in
                        switch result {
                        case .success:
                            userInfo.isUserAuthenticated = .signedOut
                        case .failure(let error):
                            print(error.localizedDescription)
                            
                        }
                    }
                }, label: {
                    Image(systemName: "escape").foregroundColor(Color("FRpurple"))
                        .padding()
                }),
                trailing: Button(action: {
                    viewModel.game = newGame
                    activeGame = newGame
                    activeGameSheet = .newGame
                    showGameSheet = true
                }, label: {
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
                    CreateGame(viewModel: viewModel).environmentObject(userInfo)
                } else {
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
