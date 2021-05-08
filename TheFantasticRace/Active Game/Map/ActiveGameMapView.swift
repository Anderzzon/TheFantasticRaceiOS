//
//  ActiveGameMapView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import SwiftUI
import MapKit

struct ActiveGameMapView: View {
    @ObservedObject var viewModel: ActiveGameViewModel
    @State private var locations = [MKPointAnnotation]()
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        ActiveGameMapUIView(centerCoordinate: $centerCoordinate, annotations: locations, players: viewModel.players).edgesIgnoringSafeArea(.all)
    }
}

struct ActiveGameMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameMapView(viewModel: ActiveGameViewModel(game: Game(name: "New game")))
    }
}
