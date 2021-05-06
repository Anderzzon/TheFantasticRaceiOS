//
//  MapView.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-03.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
    var stops: [GameStop]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotations(stops)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if stops.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(stops)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
            print(mapView.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            guard let stopAnnotation = annotation as? GameStop else {
                print("stopAnnotation guard")
                return nil
            }
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Stop") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Stop")
            annotationView.canShowCallout = true
            annotationView.glyphText = "1️⃣"
            annotationView.titleVisibility = .visible
            return annotationView
//                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//                view.canShowCallout = false
//                return view
        }
        
    }

}



//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
