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
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Hint: \(viewModel.game!.stops![viewModel.currentPlayer!.finishedStops].hint!)")
                        //Text("Hint text")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: 500, minHeight: 0, maxHeight: 100)
                }.padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))

                if viewModel.locationManager.atStop {
                Group {
                    Text(viewModel.game!.stops![viewModel.currentPlayer!.finishedStops].question!)
                        //Text("Vad blir 1 + 1?")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    TextEditor(text: $answer)
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                        .padding()
                    
                    Button(action: {
                        let result = viewModel.answerQuestion(with: answer, for: viewModel.game!.stops![viewModel.currentPlayer!.finishedStops])
                        if result {
                            viewModel.locationManager.atStop = false
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Answer")
                    }.buttonStyle(GradientButtonStyle())
                }
                }
                
                Spacer()
                
            }
            .navigationBarTitle(Text(viewModel.game!.stops![viewModel.currentPlayer!.finishedStops].name), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        print("Close")
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("Close").padding()
                                    }))
        }
        //.navigationBarTitle(Text("Fråga 1"), displayMode: .inline)
        
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

struct StopDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        StopDetailView(viewModel: ActiveGameViewModel())
    }
}
