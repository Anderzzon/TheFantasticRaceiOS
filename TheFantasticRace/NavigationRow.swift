//
//  NavigationRow.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-07.
//

import SwiftUI

struct NavigationRow: View {
    
    static let gameDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM HH:mm"
        return formatter
    }()
    
    static var optionalDate: Date {
        return Date()
    }
    
    var game: Game
    @State private var viewModel = NavigationRowViewModel()
    
    var body: some View {
        VStack(alignment: .leading)  {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.headline)
            Text(game.description ?? "")
                .padding(.top, 1)
                .font(.caption2)
                .lineLimit(3)
        }.onAppear {
            viewModel.getAcceptedUsers(game: game)
            viewModel.getNameOfGameOwner(game: game)
        }
        
        Spacer()
        HStack {
            Image("players")
                .resizable()
                .scaledToFit()
                .frame(height: 10)
                .padding(.trailing, -5)

            Text("\(viewModel.numberOfPlayers) players")
            //Text("\(game.listOfPlayers?.count ?? 0) players")
                .font(.caption2)
            Spacer()
            Image("copyright")
                .resizable()
                .scaledToFit()
                .frame(height: 10)
                .padding(.trailing, -5)
            Text(viewModel.gameOwner)
                .font(.caption2)
            Spacer()
            Image("countdown")
                .resizable()
                .scaledToFit()
                .frame(height: 10)
                .padding(.trailing, -5)
            Text("\(game.start_time ?? Self.optionalDate, formatter: Self.gameDateFormat)")
                .font(.caption2)
        }
        }.padding()
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 120,
               maxHeight: 120,
               alignment: .leading)
        .background(Color("FRturquise").opacity(0.25))
        //.background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding([.top, .leading, .trailing])
    }
}

//struct NavigationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationRow(game: Game()).previewLayout(.fixed(width: 310, height: 150))
//    }
//}
