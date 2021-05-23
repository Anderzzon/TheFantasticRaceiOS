//
//  StopInfoBottomView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-10.
//

import SwiftUI

struct StopInfoBottomView: View {
    @ObservedObject var viewModel: ActiveGameViewModel
    let gamePlayedTime = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var playedTimeElapsed = ""
    
    var body: some View {
        HStack {
            VStack{
                if let stopsCount = viewModel.game!.stops?.count {
                    if viewModel.currentPlayer!.finishedStops <= stopsCount - 1 {
                        if let stop = viewModel.game!.stops![viewModel.currentPlayer!.finishedStops] {
                            Text("Hint: \((stop.hint) ?? "")").foregroundColor(.white)
                                .font(.body)
                                .lineLimit(2)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    } else {
                        Text("Game Finished").foregroundColor(.white)
                            .font(.body)
                            .lineLimit(2)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            .onAppear {
                            }
                    }
                }
                if viewModel.currentPlayer?.finishedStops != viewModel.game?.stops?.count {
                    HStack{
                        Image("countdown")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .colorScheme(.dark)
                        Text(playedTimeElapsed).foregroundColor(.white)
                    }
                }
            }.padding([.horizontal], 12)
            .onReceive(gamePlayedTime) { _ in
                updateTime()
            }
        }
    }
    
    func updateTime() {
        let startDate = viewModel.game?.start_time
        let currentDate = Date()
        let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: startDate!, to: currentDate)
        let hours = diffComponents.hour ?? 00
        let minutes = diffComponents.minute ?? 00
        let seconds = diffComponents.second ?? 00
        
        if viewModel.currentPlayer?.finishedStops != viewModel.game?.stops?.count {
            if seconds < 10 && minutes < 10 {
                playedTimeElapsed = "0\(hours):0\(minutes):0\(seconds)"
            } else if minutes < 10 {
                playedTimeElapsed = "0\(hours):0\(minutes):\(seconds)"
            } else if seconds < 10 {
                playedTimeElapsed = "0\(hours):\(minutes):0\(seconds)"
            } else {
                playedTimeElapsed = "0\(hours):\(minutes):\(seconds)"
            }
        }
        
        
    }
}

struct StopInfoBottomView_Previews: PreviewProvider {
    static var previews: some View {
        StopInfoBottomView(viewModel: ActiveGameViewModel())
    }
}
