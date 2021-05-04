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
                    Section(header: Text("Question")) {
                        List {
                            TextEditor(text: $stop.question ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    Section(header: Text("Answer")) {
                        List {
                            TextEditor(text: $stop.answer ?? "").frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    }
                    .navigationBarTitle(Text("Add new stop"), displayMode: .inline)
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                print("Saving")
                                stop.lat = centerCoordinate.latitude
                                stop.lng = centerCoordinate.longitude
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


