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
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(games.games, id: \.name) { game in
                        //Text(game.name!)
                        NavigationRow(game: game)
                        Print(game)
                    }
                }
            }
            .navigationBarTitle("All games")
            .navigationBarItems(trailing: Button(action: {print("add game")}, label: {
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
