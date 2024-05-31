//
//  MoveCarOnMapViewModel+MoveAnnotationProtocol.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 31/05/24.
//

import Foundation
import MapKit

protocol MoveCarOnMapViewModelProtocol {
    func addMapMover (location: CLLocationCoordinate2D)
    func addAnnotation (location: CLLocationCoordinate2D, name: String)
}

extension MoveCarOnMapViewModel: MoveCarOnMapViewModelProtocol {
    func addAnnotation (location: CLLocationCoordinate2D, name: String) {
        let annotation = MyAnnotation(title: name, coordinate: location, isDriver: true, id: "")
        
        annotation.title = name
        
        let image = #imageLiteral(resourceName: "mycars")
        let img = image.resize(CGFloat(self.annotationImageSize))
        
        let sz = img.size
        
        var rds = sz.height
        
        if sz.width < sz.height {
            rds = sz.width
        }
        
        annotation.uiimage = img.roundedRectImageFromImage(image: img, imageSize: sz, cornerRadius: rds/2)
        
        mapMover.addAnnotation(annotation)
        
        showAnnotations ()
        
        moverAnnotationToAddNewLocation?.addNewLocation(location: location)
        
    }
    
    func addMapMover (location: CLLocationCoordinate2D) {
        let annotation = MyAnnotation(title: "Receiver", coordinate: location, isDriver: true, id: "")
        
        let image = #imageLiteral(resourceName: "mycars")
        let img = image.resize(CGFloat(self.annotationImageSize))
        
        let sz = img.size
        
        var rds = sz.height
        
        if sz.width < sz.height {
            rds = sz.width
        }
        
        annotation.uiimage = img.roundedRectImageFromImage(image: img, imageSize: sz, cornerRadius: rds/2)
        
        annotation.isAnimatingPins = true
        
        moverAnnotation = MoveAnnotation(map: mapMover, destinationLocation: destinationLocation, moverAnnotation: annotation, showMoverInCenter: self)
        moverAnnotation.start()
        
        mapMover.addAnnotation(annotation)
    }
}
