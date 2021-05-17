//
//  BasicGameSettings.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import SwiftUI

enum ActiveSheet {
    case title, description
}

struct BasicGameSettings: View {
    @State var showSheet = false
    @State private var activeSheet: ActiveSheet = .title
    @State private var showNextStop: Bool = true
    
    @ObservedObject var viewModel: CreateGameViewModel
    var body: some View {
        //NavigationView {
            VStack {
                Form {
                    Section(header: Text("Name of race")) {
                        List {
                            Text(viewModel.game.name ?? "New Game")
                        }.onTapGesture {
                            activeSheet = .title
                            showSheet = true
                        }
                    }
                    Section(header: Text("Description")) {
                        List {
                            Text(viewModel.game.description ?? "Description")
                        }.onTapGesture {
                            activeSheet = .description
                            showSheet = true
                        }
                    }
                    Section(header: Text("Geofence radius")) {
                        VStack {
                            Slider(value: $viewModel.game.radius ?? 20, in: 20...100, step: 10).accentColor(Color("FRpurple"))
                            Text("Radius for stops is set to \(Int(viewModel.game.radius ?? 20)) meters").font(.footnote)
                        }
                    }
                    Section(header: Text("Show particiments on the map")) {
                        Toggle(isOn: $viewModel.game.show_players_map ?? true){
                            //Text("Show players on map")
                            Text(viewModel.game.show_players_map ?? true ? "Players will see each other on map" : "Players won't see each other").font(.footnote)
                        }.toggleStyle(SwitchToggleStyle(tint: Color("FRpurple")))
                    }
                    Section(header: Text("Unlock the next stop with a question")) {
                        Toggle(isOn: $viewModel.game.unlock_with_question ?? true){
                            Text(viewModel.game.unlock_with_question ?? true ? "The next stop will be unlocked by answering a question" : "Next stop will automatically be unlocked").font(.footnote)
                        }.toggleStyle(SwitchToggleStyle(tint: Color("FRpurple")))
                    }
                    Section(header: Text("Show the next stop on the map")) {
                        Toggle(isOn: $viewModel.game.show_next_stop ?? true){
                            Text(viewModel.showNextStop ? "The next stop will be shown on the map" : "The stops will not be shown on the map").font(.footnote)
                        }.toggleStyle(SwitchToggleStyle(tint: Color("FRpurple")))
                        if viewModel.game.show_next_stop ?? true {
                            VStack {
                                Slider(value: $viewModel.game.show_next_stop_delay ?? 5, in: 0...60, step: 5).accentColor(Color("FRpurple"))
                                Text("Next stop will be shown on map with a delay of \(Int(viewModel.game.show_next_stop_delay ?? 5)) min").font(.footnote)
                            }
                        }

                    }
                    Section(header: Text("Date and time")) {
                        DatePicker("Start time", selection: $viewModel.game.start_time ?? Date(), in: Date()..., displayedComponents: [.date, .hourAndMinute]).accentColor(Color("FRpurple"))
                    }
                }.listStyle(GroupedListStyle())
            }
        //}
    .sheet(isPresented: $showSheet) {
        if activeSheet == .title {
            DetailSettingsTitleView(viewModel: viewModel, showSheet: $showSheet)
        } else {
            DetailSettingsDescriptionView(viewModel: viewModel, showSheet: $showSheet)
        }
            
        }
    }
}

struct BasicGameSettings_Previews: PreviewProvider {
    static var previews: some View {
        BasicGameSettings(viewModel: CreateGameViewModel(selectedGame: Game(name: "New game")))
    }
}

extension Binding {
    static func ??(lhs: Binding<Optional<Value>>, rhs: Value) ->
    Binding<Value> {
        return Binding(get: { lhs.wrappedValue ?? rhs}, set: { lhs.wrappedValue = $0 })
    }
}
