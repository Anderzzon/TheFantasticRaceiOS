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
    
    @ObservedObject var viewModel: CreateGameViewModel
    var body: some View {
        //NavigationView {
            VStack {
                Form {
                    Section(header: Text("Name of race")) {
                        List {
                            Text(viewModel.game.name ?? "")
                        }.onTapGesture {
                            activeSheet = .title
                            showSheet = true
                        }
                    }
                    Section(header: Text("Description")) {
                        List {
                            Text(viewModel.game.description ?? "")
                        }.onTapGesture {
                            activeSheet = .description
                            showSheet = true
                        }
                    }
                    Section(header: Text("Radius")) {
                        VStack {
                            Slider(value: $viewModel.game.radius ?? 20, in: 20...100, step: 1)
                            Text("Radius for stops is set to \(Int(viewModel.game.radius ?? 20)) meters")
                        }
                    }
                    Section(header: Text("Show particiments on the map")) {
//                        Toggle(isOn: $viewModel.game.show_players_map){
//                            Text("Show players on map")
//                        }
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
        BasicGameSettings(viewModel: CreateGameViewModel())
    }
}

extension Binding {
    static func ??(lhs: Binding<Optional<Value>>, rhs: Value) ->
    Binding<Value> {
        return Binding(get: { lhs.wrappedValue ?? rhs}, set: { lhs.wrappedValue = $0 })
    }
}
