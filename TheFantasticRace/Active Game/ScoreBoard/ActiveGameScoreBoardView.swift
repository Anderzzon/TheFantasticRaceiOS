//
//  ActiveGameScoreBoardView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import SwiftUI

struct ActiveGameScoreBoardView: View {
    @ObservedObject var viewModel: ActiveGameViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ActiveGameScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameScoreBoardView(viewModel: ActiveGameViewModel(game: Game(name: "New game")))
    }
}
