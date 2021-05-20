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
    @ObservedObject var viewModel: ActiveGameViewModel
    
    //var annotations: [MKPointAnnotation]
    //var players: [PlayingPlayer]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isRotateEnabled = false
        print("Players:", viewModel.players)
        mapView.delegate = context.coordinator
        mapView.addAnnotations(viewModel.players)
        mapView.addOverlay(viewModel.stopOverlays)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.removeAnnotations(view.annotations)
        view.addAnnotations(viewModel.players)
        view.removeOverlay(viewModel.stopOverlays)
        for overlay in view.overlays {
            view.removeOverlay(overlay)
        }
        if view.overlays.count < 1 {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                view.addOverlay(viewModel.stopOverlays)
            }
            //print("Overlay count", view.overlays.count)
        }
        
        view.showsUserLocation = true
        hidePlayersAnnotation(view: view)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func hidePlayersAnnotation(view: MKMapView) {
        for annotation in view.annotations {
            if let title = annotation.title, title == "Erik" {
                view.removeAnnotation(annotation)
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ActiveGameMapUIView
        
        init(_ parent: ActiveGameMapUIView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
            //print(mapView.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if let annotationView = views.first {
                if let annotation = annotationView.annotation {
                    if annotation is MKUserLocation {
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        mapView.setRegion(region, animated: true)
                    }
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            guard let playerAnnotation = annotation as? PlayingPlayer else {
                print("playerAnnotation guard")
                return nil
            }
            
            //            guard let stopAnnotation = annotation as? GameStop else {
            //                print("stopAnnotation guard")
            //                return nil
            //            }
            
            //if playerAnnotation == annotation as? PlayingPlayer {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Player") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Player")
            annotationView.canShowCallout = true
            annotationView.glyphText = "🏃"
            annotationView.titleVisibility = .visible
            
            return annotationView
            //            } else {
            //                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Stop") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Stop")
            //                annotationView.canShowCallout = true
            //                annotationView.glyphText = "⌖"
            //                annotationView.titleVisibility = .visible
            //                return annotationView
            //            }
            
            
        }
        
    }
    
}

//struct ActiveGameMapUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActiveGameMapUIView()
//    }
//}
