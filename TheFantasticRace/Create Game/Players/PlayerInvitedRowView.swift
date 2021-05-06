//
//  PlayerInvitedRowView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-05.
//

import SwiftUI

struct PlayerInvitedRowView: View {
    var player: Player
    
    var body: some View {
        Print(player)
        VStack {
            HStack {
                Text(player.name)
                Spacer()
                if player.accepted! == true {
                    HStack {
                        Text("Accepted")
                        Image(systemName: "checkmark")
                    }
                } else if player.accepted! == false {
                    Text("Invited")
                } else {
                    Text("Invited")
                }
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

struct PlayerInvitedRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlayerInvitedRowView(player: Player(name: "Sven Bertil", email: "", accepted: true, id: ""))
            PlayerInvitedRowView(player: Player(name: "Sven Bertil", email: "", accepted: false, id: ""))
        }
    }
}
