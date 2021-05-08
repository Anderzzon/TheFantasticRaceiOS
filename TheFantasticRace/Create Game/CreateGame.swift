//
//  CreateGame.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import SwiftUI

enum SelectedTab: String, CaseIterable {
    case basic = "Standard"
    case map = "Map"
    case stops = "Stops"
    case people = "People"
}

struct CreateGame: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @State private var selectedTab: SelectedTab = .basic
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CreateGameViewModel
    
    init(viewModel: CreateGameViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                ZStack(alignment: .top) {
                    Picker("Create new Game", selection: $selectedTab) {
                        ForEach(SelectedTab.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    
                }
                ChosenSettingsView(selectedView: selectedTab, viewModel: viewModel)
                    .padding(.top, -10)
                Spacer()
            }
            .navigationBarTitle(Text(viewModel.game.name), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        print("Saving")
                        viewModel.game.owner = userInfo.user.uid
                        print("Owner", viewModel.game.owner)
                        print("ID", viewModel.game.id)
                        if viewModel.game.id == nil {
                            viewModel.createGame(game: viewModel.game)
                        } else {
                            viewModel.updateGame(game: viewModel.game)
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save").padding()
                    }),
                trailing:
                    Button(action: {
                        print("Cancel")
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel").padding()
                    }))
        }.onAppear {
            print("ID", viewModel.game.id)
            print(userInfo.user.uid)
        }
    }
    
    struct ChosenSettingsView: View {
        var selectedView: SelectedTab
        var viewModel: CreateGameViewModel
        var body: some View {
            switch selectedView {
            case .basic: BasicGameSettings(viewModel: viewModel)
            case .map: Map(viewModel: viewModel)
            case .stops: Stops(viewModel: viewModel)
            case .people: SelectPlayers(viewModel: viewModel)
            }
        }
    }
}

struct CreateGame_Previews: PreviewProvider {
    static var previews: some View {
        CreateGame(viewModel: CreateGameViewModel(selectedGame: Game(name: "New game")))
    }
}
