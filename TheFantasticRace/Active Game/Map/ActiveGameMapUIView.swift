//
//  ActiveGameMapUIView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-08.
//

import SwiftUI
import MapKit

struct ActiveGameMapUIView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
    var players: [PlayingPlayer]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotations(players)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if players.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(players)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ActiveGameMapUIView
        
        init(_ parent: ActiveGameMapUIView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
            print(mapView.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            guard let playerAnnotation = annotation as? PlayingPlayer else {
                print("playerAnnotation guard")
                return nil
            }
            guard let stopAnnotation = annotation as? GameStop else {
                print("stopAnnotation guard")
                return nil
            }
            
            if playerAnnotation == annotation as? PlayingPlayer {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Player") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Player")
                annotationView.canShowCallout = true
                annotationView.glyphText = "🏃"
                annotationView.titleVisibility = .visible
                return annotationView
            } else {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Stop") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Stop")
                annotationView.canShowCallout = true
                annotationView.glyphText = "⌖"
                annotationView.titleVisibility = .visible
                return annotationView
            }

            
        }
        
    }

}

//struct ActiveGameMapUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActiveGameMapUIView()
//    }
//}
