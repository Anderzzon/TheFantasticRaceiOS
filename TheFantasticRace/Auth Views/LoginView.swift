//
//  LoginView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-06.
//

import SwiftUI

struct LoginView: View {
    enum Action {
        case none, signUp, resetPW
    }
    @State private var showSheet = false
    @State private var action = Action.signUp
    
    var body: some View {
        VStack {
            SignInWithEmailView(showSheet: $showSheet, action: $action)
            SignInWithAppleView().frame(width: 200, height: 50)
            Spacer()
        }
        .sheet(isPresented: $showSheet) {
            if action == .resetPW {
                ForgotPasswordView()
            } else {
                SignUpView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
