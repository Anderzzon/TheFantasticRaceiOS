//
//  SelectPeople.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import SwiftUI

struct SelectPeople: View {
    @ObservedObject var viewModel: CreateGameViewModel
    var body: some View {
        List {
            ForEach(viewModel.game.stops ?? []) { stop in
                Print("Stop", stop)
                Text("Player")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .listRowInsets(EdgeInsets())
                            .background(Color.white)
        }
    }
}

struct SelectPeople_Previews: PreviewProvider {
    static var previews: some View {
        SelectPeople(viewModel: CreateGameViewModel(selectedGame: Game(name: "New Game")))
    }
}
