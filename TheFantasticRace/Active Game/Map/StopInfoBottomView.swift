//
//  StopInfoBottomView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-10.
//

import SwiftUI

struct StopInfoBottomView: View {
    @ObservedObject var viewModel: ActiveGameViewModel
    
    var body: some View {
        HStack {
            Text("Hint: \((viewModel.game?.stops?[viewModel.currentPlayer?.finishedStops ?? 0].hint) ?? "")")
                //Text("Hint text")
                //.foregroundColor(Color.white)
                .font(.body)
                .lineLimit(2)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        }
        .background(Color.white)
        .padding()
    }
}

struct StopInfoBottomView_Previews: PreviewProvider {
    static var previews: some View {
        StopInfoBottomView(viewModel: ActiveGameViewModel())
    }
}
