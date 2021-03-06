//
//  ScoreBoardListViewItem.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-09.
//

import SwiftUI

struct ScoreBoardListViewItem: View {
    let player: PlayingPlayer
    let numberOfStops: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(player.name)
                Spacer()
                Text("\(player.finishedStops)/\(numberOfStops) stops")
            }
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

struct ScoreBoardListViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoardListViewItem(player: PlayingPlayer(name: "Sven Bertil", id: UUID().uuidString, finishedStops: 0, updatedTime: nil, latEncrypted: nil, lngEncrypted: nil), numberOfStops: 10)
    }
}
