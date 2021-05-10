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
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            ActiveGameMapUIView(centerCoordinate: $centerCoordinate, viewModel: viewModel).edgesIgnoringSafeArea(.all)
            StopInfoBottomView(viewModel: viewModel).onTapGesture {
                showSheet = true
            }
        }.sheet(isPresented: $showSheet) {
            StopDetailView(viewModel: viewModel)
        }
    }
}

struct ActiveGameMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameMapView(viewModel: ActiveGameViewModel())
    }
}
