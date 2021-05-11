//
//  StopInfoBottomView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-10.
//

import SwiftUI

struct StopInfoBottomView: View {
    @ObservedObject var viewModel: ActiveGameViewModel
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var playedTimeElapsed = ""
    
    var body: some View {
        HStack {
            VStack{
                //Text("Hint:")
                Text("Hint: \((viewModel.game?.stops?[viewModel.currentPlayer?.finishedStops ?? 0].hint) ?? "")")
                    //Text("Hint text")
                    //.foregroundColor(Color.white)
                    .font(.body)
                    .lineLimit(2)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                Text(playedTimeElapsed)
            }.onReceive(timer) { _ in
                updateTime()
            }
        }
        .background(Color.white)
        .padding()
    }
    
    func updateTime() {
            let startDate = viewModel.game?.start_time
            let currentDate = Date()
            let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: startDate!, to: currentDate)
            let hours = diffComponents.hour ?? 00
            let minutes = diffComponents.minute ?? 00
            let seconds = diffComponents.second ?? 00
        
        if seconds < 10 && minutes < 10 {
            playedTimeElapsed = "\(hours):0\(minutes):0\(seconds)"
        } else if minutes < 10 {
            playedTimeElapsed = "\(hours):0\(minutes):\(seconds)"
        } else if seconds < 10 {
            playedTimeElapsed = "\(hours):\(minutes):0\(seconds)"
        } else {
            playedTimeElapsed = "\(hours):\(minutes):\(seconds)"
        }

    }
}



struct StopInfoBottomView_Previews: PreviewProvider {
    static var previews: some View {
        StopInfoBottomView(viewModel: ActiveGameViewModel())
    }
}
