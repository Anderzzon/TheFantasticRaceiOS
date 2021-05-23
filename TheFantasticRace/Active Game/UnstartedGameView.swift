//
//  UnstartedGameView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-11.
//

import SwiftUI

struct UnstartedGameView: View {
    var startTime: Date
    var body: some View {
        VStack {
            Text("The game hasn't started yet")
            Text("It will start: \(startTime)").padding()
        }
    }
}

struct UnstartedGameView_Previews: PreviewProvider {
    static var previews: some View {
        UnstartedGameView(startTime: Date())
    }
}
