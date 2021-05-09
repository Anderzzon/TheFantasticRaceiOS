//
//  ActiveGameStopsView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import SwiftUI

struct ActiveGameStopsView: View {
    @ObservedObject var viewModel: ActiveGameViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ActiveGameStopsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameStopsView(viewModel: ActiveGameViewModel())
    }
}
