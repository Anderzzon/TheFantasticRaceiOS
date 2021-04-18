//
//  CreateGame.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import SwiftUI

enum SelectedTab: String, CaseIterable {
    case basic = "Standard"
    case stops = "Stops"
    case map = "Map"
    case people = "People"
}

struct CreateGame: View {
    
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
        .navigationBarTitle(Text("Create new Game"), displayMode: .inline)
        .navigationBarItems(
            leading:
                Button(action: {
                    print("Saving")
                    presentationMode.wrappedValue.dismiss()
                    viewModel.createGame(game: viewModel.game)
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
    }
}

struct ChosenSettingsView: View {
    var selectedView: SelectedTab
    var viewModel: CreateGameViewModel
    var body: some View {
        switch selectedView {
            case .basic: BasicGameSettings(viewModel: viewModel)
            case .stops: Stops()
            case .map: Map()
            case .people: SelectPeople()
            }
        }
    }
}

struct CreateGame_Previews: PreviewProvider {
    static var previews: some View {
        CreateGame(viewModel: CreateGameViewModel())
    }
}
