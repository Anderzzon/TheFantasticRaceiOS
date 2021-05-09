//
//  TestLocationView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-09.
//

import SwiftUI

struct TestLocationView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Spacer()
            //Text(locationManager.locationString)
            Spacer()
            Button {
                locationManager.startLocationServices()
            } label: {
                Text("Start updating location")
            }
        }
    }
}

struct TestLocationView_Previews: PreviewProvider {
    static var previews: some View {
        TestLocationView()
    }
}
