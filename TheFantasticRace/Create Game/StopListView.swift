//
//  StopListView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-01.
//

import SwiftUI

struct StopListView: View {
    
    @State var stop: GameStop
    @State var order: Int
    
    var body: some View {
        HStack {
            HStack {
                Text("\(stop.order)")
                .font(.largeTitle)

                .background(Circle()
                    .strokeBorder(Color.red, lineWidth: 1)
                    .background(Circle().foregroundColor(Color.red))
                    .frame(width: 40, height: 40))
            }.frame(width: 30)
            .padding(.trailing, 20)
            VStack(alignment: .leading) {
                Text(stop.title)
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
    let const = GameStop(id: UUID().uuidString, title: "Title of Stop", order: 1)
    static var previews: some View {
        StopListView(stop: GameStop(id: UUID().uuidString, title: "Title of Stop", order: 1), order: 1).previewLayout(.fixed(width: 310, height: 150))
    }
}
