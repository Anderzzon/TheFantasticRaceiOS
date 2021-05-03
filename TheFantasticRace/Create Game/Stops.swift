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
                           order: 0)
    
//    init(viewModel: CreateGameViewModel) {
//        UITableView.appearance().tableFooterView = UIView()
//        UITableView.appearance().separatorStyle = .none
//        self.viewModel = viewModel
//    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(viewModel.game.stops ?? []) { stop in
                    StopListView(stop: stop, order: index+1)
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
            FabView().onTapGesture {
                showNewStopSheet = true
                print("Add new stop")
            }.padding()
            
            //.environment(\.editMode, isMovingItems ? .constant(.active) : .constant(.inactive)) // Determine if isMovingItems is true or false
        }
        .sheet(isPresented: $showNewStopSheet) {
            AddNewStopView(viewModel: viewModel, stop: $newStop, showNewStopSheet: $showNewStopSheet)
        }
        .environment(\.editMode, $isMovingItems)
    }
    
    func onDelete(offsets: IndexSet) {
        viewModel.testStops.remove(atOffsets: offsets)
        withAnimation {
            isMovingItems = .inactive
        }
    }
    
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        viewModel.testStops.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            print(viewModel.testStops[0].title)
            isMovingItems = .inactive
            DispatchQueue.main.async {
                viewModel.reorderStop()
            }
        }
    }
}

struct Stops_Previews: PreviewProvider {
    static var previews: some View {
        Stops(viewModel: CreateGameViewModel())
    }
}
 
