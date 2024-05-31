//
//  MoveCarOnMapViewModel.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 29/05/24.
//

import Foundation
import MapKit

protocol ShowMoverInCenter {
    func addCenterLocationForMap (location: CLLocationCoordinate2D)
}

class MoveCarOnMapViewModel: NSObject {
    let mapMover: MKMapView
    
    let annotationImageSize = 40
    
    var moverAnnotation: MoveAnnotationDelegate!
    var sourceLocation: CLLocationCoordinate2D
    var destinationLocation: CLLocationCoordinate2D
    
    init(mapMover: MKMapView, sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D) {
        self.mapMover = mapMover
        
        self.sourceLocation = sourceLocation
        self.destinationLocation = destinationLocation
        
        super.init()
        
        mapMover.delegate = self

        addMapMover (location: sourceLocation)
        
        addCenterLocationForMap (location: sourceLocation)
        
        addAnnotation (location: sourceLocation, name: "Source")
        addAnnotation (location: destinationLocation, name: "Destination")
    }
    
    func showAnnotations () {
        let arr = self.mapMover.annotations
        
        if arr.count == 2 {
            mapMover.showAnnotations(arr, animated: true)
        }
    }
    
    var countShowMoverInCenter = 0
}

extension MoveCarOnMapViewModel: ShowMoverInCenter {
    func addCenterLocationForMap (location: CLLocationCoordinate2D) {
        countShowMoverInCenter = countShowMoverInCenter + 1

        if countShowMoverInCenter % 25 == 0 {
            countShowMoverInCenter = 0
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapMover.setRegion(region, animated: true)
        }
        
    }
}
