//
//  AddNewStopView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-03.
//

import SwiftUI

struct AddNewStopView: View {
    @ObservedObject var viewModel: CreateGameViewModel
    @Binding var stop: GameStop
    
    @Binding var showNewStopSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Name of stop")) {
                        List {
                            TextEditor(text: $stop.title).frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    Section(header: Text("Hint")) {
                        List {
                            TextEditor(text: $stop.hint ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    Section(header: Text("Question")) {
                        List {
                            TextEditor(text: $stop.question ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    Section(header: Text("Question")) {
                        List {
                            TextEditor(text: $stop.answer ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    Section(header: Text("Name of race")) {
                        List {
                            TextEditor(text: $stop.title).frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    
                    
                    .navigationBarTitle(Text("Add new stop"), displayMode: .inline)
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                print("Saving")
                                viewModel.newStop(stop: stop)
                                showNewStopSheet = false
                            }, label: {
                        Text("Save").padding()
                    }),
                        trailing:
                            Button(action: {
                                print("Cancel")
                                showNewStopSheet = false
                            }, label: {
                        Text("Cancel").padding()
                    }))
                }.listStyle(GroupedListStyle())
                //Spacer()
            }

        }
        .onAppear {
            
        }
    }
}

struct AddNewStopView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStopView(viewModel: CreateGameViewModel(), stop: .constant(GameStop(id: UUID().uuidString, title: "New stop", lat: 13.1, lng: 57.1, order: 1)), showNewStopSheet: .constant(true))
    }
}


