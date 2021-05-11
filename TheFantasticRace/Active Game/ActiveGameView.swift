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
    //@ObservedObject var locationManager: LocationManager
    
    init(viewModel: ActiveGameViewModel) {
        self.viewModel = viewModel
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemPurple
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        //self.locationManager = locationManager
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                ZStack(alignment: .top) {
                    ChosenSettingsView(selectedView: selectedTab, viewModel: viewModel)
                        .padding(.top, -10)
                    Picker("Create new Game", selection: $selectedTab) {
                        ForEach(SelectedGameTab.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(.systemGray6).opacity(0.5))
                    .padding()
                    //

                }
                
                Spacer()
            }
            .navigationBarTitle(Text(viewModel.game?.name ?? "Active Game"), displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        print("Exit")
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Exit").padding()
                    }))
                    }
        .sheet(isPresented: $viewModel.locationManager.showSheet) {
            StopDetailView(viewModel: viewModel)
            Print("Sheet")
        }.onAppear {
            
        }
//        .alert(isPresented: $viewModel.locationManager.atStop) {
//            Alert(title: Text("You are now at stop \(viewModel.locationManager.stopOrder)"))
//            
//        }
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
        ActiveGameView(viewModel: ActiveGameViewModel())
    }
}
