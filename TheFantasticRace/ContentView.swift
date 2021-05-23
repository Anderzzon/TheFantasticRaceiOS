//
//  ContentView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-06.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userInfo: UserInfo
    var body: some View {
        Group {
            if userInfo.isUserAuthenticated == .undefined {
                Spacer()
                ProgressView()
                Spacer()
            } else if userInfo.isUserAuthenticated == .signedOut {
                LoginView().frame(width: 450, height: nil, alignment: .center)
                    .background(Color(.systemGray3)).edgesIgnoringSafeArea(.all)
            } else {
                HomeView()
            }
        }.onAppear {
            self.userInfo.configureFirebaseStateDidChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
