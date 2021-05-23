//
//  ActiveGameView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import SwiftUI

enum SelectedGameTab: String, CaseIterable {
    case map = "Map"
    //case stops = "Stops"
    case score = "Leaderboard"
}

struct ActiveGameView: View {
    
    @State private var selectedTab: SelectedGameTab = .map
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ActiveGameViewModel
    
    init(viewModel: ActiveGameViewModel) {
        self.viewModel = viewModel
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("FRpurple"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.game == nil || viewModel.currentPlayer == nil {
                    GameLoadingView()
                } else if viewModel.game!.start_time! > Date() {
                    UnstartedGameView(startTime: (viewModel.game?.start_time)!)
                } else {
                    
                    ZStack(alignment: .top) {
                        ChosenSettingsView(selectedView: selectedTab, viewModel: viewModel)
                            .padding(.top, -10)
                        Picker("Current game", selection: $selectedTab) {
                            ForEach(SelectedGameTab.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color(.systemGray6).opacity(0.5))
                        .padding()
                    }
                }
                Spacer()
            }
            
            .background(LinearGradient(gradient: Gradient(colors: [Color("FRpurple"), Color.white]), startPoint: .bottom, endPoint: .center).opacity(0.8).edgesIgnoringSafeArea(.all))
            .navigationBarTitle(Text(viewModel.game?.name ?? "Active Game"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color("FRpurple"))
                            .padding()
                    })
                ,
                trailing:
                    Button(action: {
                        viewModel.locationManager.locationManager.stopUpdatingLocation()
                        viewModel.stopTimer()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Exit")
                            .foregroundColor(Color("FRpurple"))
                            .padding()
                    })
            )
        }
        .sheet(isPresented: $viewModel.locationManager.showSheet) {
            StopDetailView(viewModel: viewModel)
        }
        .alert(isPresented: $viewModel.showFinishedAlert, content: {
            Alert(title: Text("You have finished the race!"))
        })
    }
    
    struct ChosenSettingsView: View {
        var selectedView: SelectedGameTab
        var viewModel: ActiveGameViewModel
        var body: some View {
            switch selectedView {
            case .map: ActiveGameMapView(viewModel: viewModel)
            //case .stops: ActiveGameStopsView(viewModel: viewModel)
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
