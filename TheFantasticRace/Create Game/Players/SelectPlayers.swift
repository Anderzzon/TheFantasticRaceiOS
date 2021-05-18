//
//  SelectPeople.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import SwiftUI

struct SelectPlayers: View {
    @ObservedObject var viewModel: CreateGameViewModel
    
    //@State var searchText = ""
    @State var isSearching = false
    var body: some View {
        ScrollView {
            SearchBar(viewModel: viewModel, isSearching: $isSearching)
            //Print(searchText)
            ZStack {
                LazyVStack {
                    ForEach(viewModel.game.listOfPlayers ?? []) { player in
                        Print("Invited Player", player)
                        PlayerInvitedRowView(player: player)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .listRowInsets(EdgeInsets())
                    .background(Color.white)
                }
                if isSearching {
                    LazyVStack {
                        ForEach(viewModel.players) { player in
                            PlayerSearchRowView(player: player).onTapGesture {
                                viewModel.inviteUserToGame(player: player)
                                isSearching = false
                            }
                            Divider().foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
                        .listRowInsets(EdgeInsets())
                        //.background(Color.white)
                    }
                    .background(Color.purple)
                }
            }
            
        }
    }
}

struct SelectPeople_Previews: PreviewProvider {
    static var previews: some View {
        SelectPlayers(viewModel: CreateGameViewModel(selectedGame: Game(name: "New Game")))
    }
}
