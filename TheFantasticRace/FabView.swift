//
//  FabView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-03.
//

import SwiftUI

struct FabView: View {
    var body: some View {
        
        Image(systemName: "mappin.and.ellipse")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .padding()
            .background(Color.red).shadow(color: .gray, radius: 0.9, x: 1, y: 1 )
            .clipShape(Circle()).shadow(color: .gray, radius: 0.9, x: 1, y: 1 )
    }
}

struct FabView_Previews: PreviewProvider {
    static var previews: some View {
        FabView()
    }
}
