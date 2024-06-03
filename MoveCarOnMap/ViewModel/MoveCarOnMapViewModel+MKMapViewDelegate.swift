//
//  MoveCarOnMapViewModel+MKMapViewDelegate.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 31/05/24.
//

import Foundation
import MapKit

extension MoveCarOnMapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.hexColor(0x2699FB)
            polylineRenderer.lineWidth = 3
            
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MyAnnotation) {
            return nil
        }
        
        let reuseId = "MyAnnotationIdentifier"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            anView?.canShowCallout = true
        } else {
            anView?.annotation = annotation
        }
        
        let cpa = annotation as! MyAnnotation
        anView?.image = cpa.uiimage
        
        cpa.mkAnnotationView = anView
        
        return anView
    }
}
