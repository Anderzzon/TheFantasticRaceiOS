//
//  ActiveGameView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import SwiftUI

enum SelectedGameTab: String, CaseIterable {
    case map = "Map"
    case stops = "Stops"
    case score = "Leaderboard"
}

struct ActiveGameView: View {
    
    @State private var selectedTab: SelectedGameTab = .map
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ActiveGameViewModel
    @ObservedObject var locationManager: LocationManager
    
    init(viewModel: ActiveGameViewModel, locationManager: LocationManager) {
        self.viewModel = viewModel
        self.locationManager = locationManager
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                ZStack(alignment: .top) {
                    Picker("Create new Game", selection: $selectedTab) {
                        ForEach(SelectedGameTab.allCases, id: \.self) {
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
            .navigationBarTitle(Text("viewModel.game.name"), displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        print("Exit")
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Exit").padding()
                    }))
        }.onAppear {
            locationManager.setUpMonitoring(for: viewModel.game.stops!, with: viewModel.game.radius!)
        }
        .alert(isPresented: $locationManager.atStop) {
            Alert(title: Text("You are now at stop \(locationManager.stopOrder)"))
        }
    }
    
    struct ChosenSettingsView: View {
        var selectedView: SelectedGameTab
        var viewModel: ActiveGameViewModel
        var body: some View {
            switch selectedView {
            case .map: ActiveGameMapView(viewModel: viewModel)
            case .stops: ActiveGameStopsView(viewModel: viewModel)
            case .score: ActiveGameScoreBoardView(viewModel: viewModel)
            }
        }
    }
}

struct ActiveGameView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameView(viewModel: ActiveGameViewModel(game: Game(name: "New game")), locationManager: LocationManager())
    }
}
