//
//  AddNewStopView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-03.
//

import MapKit
import SwiftUI

struct AddNewStopView: View {
    @ObservedObject var viewModel: CreateGameViewModel
    @Binding var stop: GameStop
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var location = MKPointAnnotation()
    
    @Binding var showNewStopSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Name of stop")) {
                        List {
                            TextEditor(text: $stop.name).frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    Section(header: Text("Hint")) {
                        List {
                            TextEditor(text: $stop.hint ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    if viewModel.game.unlock_with_question! {
                        Section(header: Text("Question")) {
                            List {
                                TextEditor(text: $stop.question ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            }
                        }
                        Section(header: Text("Answer")) {
                            List {
                                TextEditor(text: $stop.answer ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                if stop.order > 0 && viewModel.game.stops!.count == stop.order {
                                    Text("Note: Question and answers will not be used for the last stop.").font(.footnote)
                                }
                            }

                        }

                    }
                }.listStyle(GroupedListStyle())
                
                .navigationBarTitle(Text("Add new stop"), displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button(action: {
                            print("Saving")
                            stop.lat = centerCoordinate.latitude
                            stop.lng = centerCoordinate.longitude
                            //stop.order = viewModel.game.stops?.count ?? 0 //Adds stop last in array
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
            }

        }
        .onAppear {
            if let center = viewModel.createCenterCoordinate(stop: stop) {
                centerCoordinate = center
            }
        }
    }
}

struct AddNewStopView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewStopView(viewModel: CreateGameViewModel(selectedGame: Game(name: "New game")), stop: .constant(GameStop(id: "1", title: "New Stop", order: 0, lat: nil, lng: nil, question: nil, answer: nil, hint: nil)), showNewStopSheet: .constant(true))
    }
}


