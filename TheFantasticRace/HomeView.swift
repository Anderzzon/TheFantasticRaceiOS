//
//  HomeView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-06.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var showError = false
    @State private var errorString = ""
    @StateObject var games = FBDataModel()
    
    @State private var createGameIsPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Print("VStack Load")
                    ForEach(games.fetchedGames.sorted()) { game in
                        //Text(game.name!)
                        
                        Print(game)
                        NavigationRow(game: game).onTapGesture {
                            print(game.name, "tapped")
                        }
                        
                    }
                }
            }
            .navigationBarTitle("All games")
            .navigationBarItems(trailing: Button(action: {
                                                    createGameIsPresented = true
                                                    print("add game")}, label: {
                Image(systemName: "plus").padding()
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
            .fullScreenCover(isPresented: $createGameIsPresented) {
                CreateGame(viewModel: CreateGameViewModel())
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
