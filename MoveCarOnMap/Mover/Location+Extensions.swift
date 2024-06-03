//
//  Location+Extensions.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 03/06/24.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func location() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func isValidLocation () -> Bool {
        if latitude != 0.0 && longitude != 0.0 {
            return true
        }
        
        return false
    }
}

extension CLLocation {
    func coordinate2D() -> CLLocationCoordinate2D {
        return self.coordinate
    }
}
