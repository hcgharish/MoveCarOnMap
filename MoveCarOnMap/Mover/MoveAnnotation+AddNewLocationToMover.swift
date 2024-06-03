//
//  MoveAnnotation+AddNewLocationToMover.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 03/06/24.
//

import Foundation
import MapKit

protocol AddNewLocationToMover {
    func addNewLocation (location: CLLocationCoordinate2D)
}

extension MoveAnnotation: AddNewLocationToMover {
    func addNewLocation (location: CLLocationCoordinate2D) {
        if lastAddedLocation == nil {
            lastAddedLocation = location
        }
        
        var calculatePath = CalculatePath(sourceLoc: lastAddedLocation!, destinationLoc: location)
        
        let path = calculatePath.makePath()
        
        if path.isValid() {
            routePoints!.add(path)
        }
        
        lastAddedLocation = location
    }
}
