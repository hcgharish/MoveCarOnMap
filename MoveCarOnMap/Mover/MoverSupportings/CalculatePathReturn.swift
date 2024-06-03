//
//  CalculatePathReturn.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 30/05/24.
//

import Foundation
import MapKit

struct CalculatePathReturn {
    var points: [[Double]]
    var distance: Double
    
    init(points: [[Double]], distance: Double) {
        self.points = points
        self.distance = distance
    }
    
    func isValid() -> Bool {
        if points.count > 0, distance > 0 {
            return true
        }
        
        return false
    }
    
    func getLocationFor(index: Int) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(points[index][0], points[index][1])
    }
}
