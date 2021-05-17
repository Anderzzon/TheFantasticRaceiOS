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
        ScrollView {
            LazyVStack {
                ForEach(viewModel.players.sorted()) { player in
                    ScoreBoardListViewItem(player: player, numberOfStops: viewModel.game?.stops?.count ?? 0)
                }
            }.padding(.top, 70)
        }
    }
}

struct ActiveGameScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameScoreBoardView(viewModel: ActiveGameViewModel())
    }
}
