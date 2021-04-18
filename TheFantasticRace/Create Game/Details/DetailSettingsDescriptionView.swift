//
//  BasicSettingsDescriptionView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-18.
//

import SwiftUI

struct DetailSettingsDescriptionView: View {
    @ObservedObject var viewModel: CreateGameViewModel
    
    @Binding var showSheet: Bool
    @State private var oldValue = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                TextEditor(text: $viewModel.game.description ?? "")
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    .navigationBarTitle(Text("Name of Race"), displayMode: .inline)
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                print("Saving")
                                showSheet = false
                            }, label: {
                        Text("Save").padding()
                    }),
                        trailing:
                            Button(action: {
                                print("Cancel")
                                viewModel.game.description = oldValue
                                showSheet = false
                            }, label: {
                        Text("Cancel").padding()
                    }))
                }
                Spacer()
            }

        }
        .onAppear {
            oldValue = viewModel.game.description ?? ""
        }
    }
}

struct DetailSettingsDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DetailSettingsTitleView(viewModel: CreateGameViewModel(), showSheet: .constant(true))
    }
}
