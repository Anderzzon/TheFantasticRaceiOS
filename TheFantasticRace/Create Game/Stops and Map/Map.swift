//
//  Map.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import MapKit
import SwiftUI

struct Map: View {
    
    @ObservedObject var viewModel: CreateGameViewModel
    @State var showNewStopSheet = false
    @State var editingItem: GameStop?
    @State private var locations = [MKPointAnnotation]()
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .center) {
                    MapView(centerCoordinate: $centerCoordinate, annotations: locations, stops: viewModel.game.stops ?? [])
                    .edgesIgnoringSafeArea(.all)
                
                Circle()
                    .fill(Color.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                }
                FabView().onTapGesture {
                    let newStop = GameStop(id: UUID().uuidString, title: "New Stop", order: viewModel.game.stops?.count ?? 0, lat: centerCoordinate.latitude, lng: centerCoordinate.longitude, question: nil, answer: nil, hint: nil)
                    editingItem = newStop
                    let newLocation = MKPointAnnotation()
                    newLocation.coordinate = centerCoordinate
                    locations.append(newLocation)
                    showNewStopSheet = true
                    print("Add new stop")
                }.padding()
            }
            .sheet(isPresented: $showNewStopSheet) {
                let newStop = GameStop(id: UUID().uuidString, title: "New Stop", order: viewModel.game.stops?.count ?? 0, lat: centerCoordinate.latitude, lng: centerCoordinate.longitude, question: nil, answer: nil, hint: nil)
                AddNewStopView(viewModel: viewModel, stop: $editingItem ?? newStop, showNewStopSheet: $showNewStopSheet)
            }
        }.onAppear {
            
        }
        
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        Map(viewModel: CreateGameViewModel(selectedGame: Game(name: "New game")))
    }
}
