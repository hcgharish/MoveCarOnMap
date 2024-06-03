//
//  BearingBetweenTwoPoints.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 31/05/24.
//

import Foundation
import MapKit

struct BearingBetweenTwoPoints {
    private func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
    private func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
    
    private func getBearingBetweenTwoPoints(_ point1: CLLocation, _ point2: CLLocation) -> Double {        
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(point2.coordinate.latitude)
        let lon2 = degreesToRadians(point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radiansBearing)
    }
    
    func getCGAffineTransform(location1 point1: CLLocation, location2 point2: CLLocation) -> CGAffineTransform {
        let degree = getBearingBetweenTwoPoints (point1, point2)
        
        return CGAffineTransform(rotationAngle: CGFloat(BearingBetweenTwoPoints().degreesToRadians(degree)))
    }
}
