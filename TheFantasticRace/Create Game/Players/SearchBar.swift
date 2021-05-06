//
//  SearchBar.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-05.
//

import SwiftUI

struct SearchBar: View {
    
    @ObservedObject var viewModel: CreateGameViewModel
    //@Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField("Search for players to add", text: $viewModel.query)
                    .padding(.leading, 24).onChange(of: viewModel.query, perform: { search in
                        print("Should be searching")
                        viewModel.searchUser(searchQuery: search)
                    })
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(6)
            .padding(.horizontal)
            .onTapGesture(perform: {
                isSearching = true
            })
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    
                    if isSearching {
                        Button(action: { viewModel.query = "" }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        })
                        
                    }
                    
                }.padding(.horizontal, 32)
                .foregroundColor(.gray)
            ).transition(.move(edge: .trailing))
            .animation(.spring())
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    viewModel.query = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }, label: {
                    Text("Cancel")
                        .padding(.trailing)
                        .padding(.leading, 0)
                })
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
            
        }
    }
}
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(viewModel: CreateGameViewModel(selectedGame: Game(name: "New Game")), isSearching: .constant(true))
    }
}
