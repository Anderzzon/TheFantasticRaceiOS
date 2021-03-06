//
//  ForgotPasswordView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-19.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var errString: String?
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter email address", text: $user.email).autocapitalization(.none).keyboardType(.emailAddress).disableAutocorrection(true)
                Button(action: {
                    FBAuth.resetPassword(email: user.email) { (result) in
                        switch result {
                        case .failure(let error):
                            errString = error.localizedDescription
                        case .success( _):
                            break
                        }
                        showAlert = true
                    }
                }) {
                    Text("Reset")
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(Color("FRpurple"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .opacity(user.isEmailValid(_email: user.email) ? 1 : 0.75)
                }
                .disabled(!user.isEmailValid(_email: user.email))
                Spacer()
            }.padding(.top, 50)
            .frame(width: 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .navigationBarTitle("Request a password reset", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("Close")
                                            .foregroundColor(Color("FRpurple"))
                                            .padding()
                                    }))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Reset"),
                      message: Text(errString ?? "Password successfully reset"),
                      dismissButton: .default(Text("OK ")) {
                        presentationMode.wrappedValue.dismiss()
                      })
            }
        }
    }
}


struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
