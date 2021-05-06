//
//  StopListView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-01.
//

import SwiftUI

struct StopListView: View {
    
    var game: Game
    var stop: GameStop
    var order: Int
    
    var body: some View {
        HStack {
            HStack {
                if stop.order == 0 {
                    Image("start-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                        .background(Circle()
                            .strokeBorder(Color.red, lineWidth: 1)
                            .background(Circle().foregroundColor(Color.red))
                            .frame(width: 40, height: 40))
                } else if game.stops != nil && stop.order == game.stops!.count-1 {
                    Image("finished-flag")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                        .background(Circle()
                            .strokeBorder(Color.red, lineWidth: 1)
                            .background(Circle().foregroundColor(Color.red))
                            .frame(width: 40, height: 40))
                } else {
                    Text("\(stop.order)")
                    .font(.largeTitle)
                    .background(Circle()
                        .strokeBorder(Color.red, lineWidth: 1)
                        .background(Circle().foregroundColor(Color.red))
                        .frame(width: 40, height: 40))
                }

            }.frame(width: 30)
            .padding(.trailing, 20)
            VStack(alignment: .leading) {
                Text(stop.name)
                    .font(.headline)
                Text(stop.hint ?? "")
                    .font(.subheadline)
            }
                
        }
        .padding()
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 70,
               maxHeight: 70,
               alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding([.top, .leading, .trailing])
        
    }
    
}

struct StopListView_Previews: PreviewProvider {
    let const = GameStop(id: UUID().uuidString, title: "Title of Stop", order: 1, lat: nil, lng: nil, question: nil, answer: nil, hint: nil)
    static var previews: some View {
        VStack {
        StopListView(game: Game(name: "New Game"), stop: GameStop(id: UUID().uuidString, title: "Title of Stop", order: 0, lat: nil, lng: nil, question: nil, answer: nil, hint: nil), order: 1).previewLayout(.fixed(width: 310, height: 150))
            StopListView(game: Game(name: "New Game"), stop: GameStop(id: UUID().uuidString, title: "Title of Stop", order: 1, lat: nil, lng: nil, question: nil, answer: nil, hint: nil), order: 1).previewLayout(.fixed(width: 310, height: 150))
        }
    }
}
