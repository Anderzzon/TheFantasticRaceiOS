//
//  Stops.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-04-11.
//

import SwiftUI

struct Stops: View {
    
    @ObservedObject var viewModel: CreateGameViewModel
    @State var isMovingItems = EditMode.inactive
    @State var editingItem: GameStop?
    @State var index = 0
    @State var showNewStopSheet = false
    @State var newStop = GameStop(id: UUID().uuidString,
                           title: "New Stop",
                           order: 0,
                           lat: nil,
                           lng: nil,
                           question: nil,
                           answer: nil,
                           hint: nil)
    
//    init(viewModel: CreateGameViewModel) {
//        UITableView.appearance().tableFooterView = UIView()
//        UITableView.appearance().separatorStyle = .none
//        self.viewModel = viewModel
//    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewModel.game.stops == nil || viewModel.game.stops?.count == 0 {
                Text("You haven't created your first stop yet. Go to the Map tab and choose the placement on the map").padding()
            } else {
            List {
                if !viewModel.validStops {
                    Text("Warning! Missing information in question")
                }
                ForEach(viewModel.game.stops ?? []) { stop in
                    Print("Stop", stop.name)
                    StopListView(game: viewModel.game, stop: stop, order: index+1)
                }
                .onMove(perform: move)
                .onDelete(perform: onDelete)
                .onLongPressGesture {
                    withAnimation{
                        isMovingItems = .active
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .listRowInsets(EdgeInsets())
                                .background(Color.white)
            }
                //Will add stops from the list for now due to best way of choosing stop is currently from the map
//            FabView().onTapGesture {
//                showNewStopSheet = true
//                print("Add new stop")
//            }.padding()
            }
            
            //.environment(\.editMode, isMovingItems ? .constant(.active) : .constant(.inactive)) // Determine if isMovingItems is true or false
        }
        .onAppear {
            viewModel.checkStopValidation()
        }
        .sheet(isPresented: $showNewStopSheet) {
            AddNewStopView(viewModel: viewModel, stop: $newStop, showNewStopSheet: $showNewStopSheet)
        }
        .environment(\.editMode, $isMovingItems)
    }
    
    func onDelete(offsets: IndexSet) {
        viewModel.game.stops!.remove(atOffsets: offsets)
        withAnimation {
            isMovingItems = .inactive
        }
    }
    
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        viewModel.game.stops!.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            isMovingItems = .inactive
            DispatchQueue.main.async {
                viewModel.reorderStop()
            }
        }
    }
}

struct Stops_Previews: PreviewProvider {
    static var previews: some View {
        Stops(viewModel: CreateGameViewModel(selectedGame: Game(name: "New game")))
    }
}
 
