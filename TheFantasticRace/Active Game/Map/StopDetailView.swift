//
//  StopDetailView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-09.
//

import SwiftUI

struct StopDetailView: View {
    @ObservedObject var viewModel: ActiveGameViewModel
    @State private var answer = ""
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: ActiveGameViewModel) {
        self.viewModel = viewModel
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if let lastStop = viewModel.game!.stops?.count {
                        if viewModel.currentPlayer!.finishedStops < lastStop {
                            if let stop = viewModel.game!.stops![viewModel.currentPlayer!.finishedStops] {
                                Text("Hint: \(stop.hint!)")
                                    .foregroundColor(Color.white)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(minWidth: 0, maxWidth: 500, minHeight: 0, maxHeight: 100)
                                    .padding(.top)
                            }
                        }
                    }
                    
                }.padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color("FRturquise"), Color("FRpurple")]), startPoint: .leading, endPoint: .trailing)).edgesIgnoringSafeArea(.all)
                
                if viewModel.locationManager.atStop {
                    if viewModel.game!.unlock_with_question == true {
                        Group {
                            
                            Text(viewModel.game!.stops![viewModel.currentPlayer!.finishedStops].question!)
                                //Text("Vad blir 1 + 1?")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 50)
                                .padding([.leading, .trailing])
                            
                            TextEditor(text: $answer)
                                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("FRpurple"), lineWidth: 2)
                                )
                                .padding()
                            
                            Button(action: {
                                let result = viewModel.answerQuestion(with: answer, for: viewModel.game!.stops![viewModel.currentPlayer!.finishedStops])
                                if result {
//                                    DispatchQueue.main.async {
//                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                                    }
                                    viewModel.locationManager.atStop = false
                                    if let region = viewModel.locationManager.geofenceRegion {
                                        viewModel.locationManager.removeGeofence(for: region)
                                    }
//                                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                                        presentationMode.wrappedValue.dismiss()
//                                    }
                                    
                                    
                                }
                            }) {
                                Text("Answer")
                            }.buttonStyle(GradientButtonStyle())
                        }
                    }
                    
                }
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if let lastStop = viewModel.game!.stops?.count {
                        if viewModel.currentPlayer!.finishedStops < lastStop {
                            if let stop = viewModel.game!.stops![viewModel.currentPlayer!.finishedStops] {
                                Text(stop.name.capitalized)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("Close")
                                            .foregroundColor(.white)
                                            .padding()
                                    }))
        }
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(Color("FRturquise"))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

struct StopDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        StopDetailView(viewModel: ActiveGameViewModel())
    }
}
