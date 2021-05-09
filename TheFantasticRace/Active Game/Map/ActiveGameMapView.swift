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
    //@State private var locations = [MKPointAnnotation]()
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        VStack {
            ActiveGameMapUIView(centerCoordinate: $centerCoordinate, viewModel: viewModel).edgesIgnoringSafeArea(.all)
            HStack {
                Text(viewModel.game!.stops?[viewModel.currentPlayer?.finishedStops ?? 0].hint ?? "")
                    //Text("Hint text")
                    //.foregroundColor(Color.white)
                    .font(.body)
                    .lineLimit(2)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            }.padding()
        }
    }
}

struct ActiveGameMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameMapView(viewModel: ActiveGameViewModel())
    }
}
