//
//  PlayerSearchRowView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-05.
//

import SwiftUI

struct PlayerSearchRowView: View {
    var player: Player
    var body: some View {
        VStack {
            Text(player.name).foregroundColor(.white)
        }
        .padding()
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 60,
               maxHeight: 60,
               alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding([.leading, .trailing])
    }
}

struct PlayerSearchRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerSearchRowView(player: Player(name: "Sven Bertil", email: "", accepted: false, id: UUID().uuidString))
    }
}
