//
//  NavigationRow.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-07.
//

import SwiftUI

struct NavigationRow: View {
    var game: Game
    
    var body: some View {
        VStack(alignment: .leading)  {
        VStack(alignment: .leading) {
            Text(game.name ?? "No name")
                .font(.headline)
            Text(game.description ?? "")
                .font(.caption2)
                .lineLimit(3)
        }
        
        Spacer()
        HStack {
            Image("players")
                .resizable()
                .scaledToFit()
                .frame(height: 10)
                .padding(.trailing, -5)

            Text("\(game.listOfPlayers?.count ?? 0) players")
                .font(.caption2)
            Spacer()
            Image("copyright")
                .resizable()
                .scaledToFit()
                .frame(height: 10)
                .padding(.trailing, -5)
            Text(game.owner ?? "")
                .font(.caption2)
            Spacer()
            Image("countdown")
                .resizable()
                .scaledToFit()
                .frame(height: 10)
                .padding(.trailing, -5)
            Text("In 5 days")
                .font(.caption2)
        }
        }.padding()
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 120,
               maxHeight: 120,
               alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding([.top, .leading, .trailing])
    }
}

//struct NavigationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationRow(game: Game()).previewLayout(.fixed(width: 310, height: 150))
//    }
//}
