//
//  CalculatePath.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 30/05/24.
//

import Foundation
import MapKit

struct CalculatePath {
    var locationSource: CLLocationCoordinate2D? = nil
    var locationDestination: CLLocationCoordinate2D? = nil
    
    init(locationSource: CLLocationCoordinate2D, locationDestination: CLLocationCoordinate2D) {
        self.locationSource = locationSource
        self.locationDestination = locationDestination
    }
    
    var points: [[Double]]? =  nil
    
    mutating func makePath () -> CalculatePathReturn {
        var dist = 0.0
        
        if let loc1 = locationSource?.location(),
           let loc2 = locationDestination?.location() {
            
            dist = loc1.distance(from: loc2)
            
//            print("loc1-\(dist)-\(loc1)-")
//            print("loc1-\(dist)-")
//            
//            //dist /= 10.0
//            //dist /= 2.0
//            
//            print("loc2-\(dist)-\(loc2)-")
//            print("loc2-\(dist)-")
//            print("==========================================")
            
            if dist > 0.0 {
                points = [[Double]](repeating: [Double](repeating: 0.0, count: 2), count: Int(dist))
                
                if dist >= 2 {
                    points?[0][0] = loc1.coordinate.latitude
                    points?[0][1] = loc1.coordinate.longitude
                    
                    points?[Int(dist) - 1][0] = loc2.coordinate.latitude
                    points?[Int(dist) - 1][1] = loc2.coordinate.longitude
                }
                
                self.getMiddleLocation(0, Int(dist) - 1, Int(dist))
            }
        }
        
        return CalculatePathReturn(points: points ?? [], distance: dist)
    }
    
    private mutating func getMiddleLocation (_ pos1: Int,_ pos2: Int,_ size: Int) -> Void {
        if (pos1 == pos2) || ((pos1 + 1) == pos2) || (pos1 == (pos2 + 1)) {
            return
        }
        
        let l1 = CLLocationCoordinate2DMake((points?[pos1][0])!, (points?[pos1][1])!)
        let l2 = CLLocationCoordinate2DMake((points?[pos2][0])!, (points?[pos2][1])!)
        
        let middle_point = l1.middleLocationWith(location: l2)
        
        let div = Double((pos1 + pos2) / 2)
        let mod = Int(div * 10.0) % 10
        
        if Int(div) < size {
            points?[Int(div)][0] = middle_point.latitude
            points?[Int(div)][1] = middle_point.longitude
            
            getMiddleLocation (pos1, Int(div), size)
            getMiddleLocation (Int(div), pos2, size)
        }
        
        if mod != 0 {
            let index = Int(div) + 1
            
            if index < size {
                points?[index][0] = middle_point.latitude
                points?[index][1] = middle_point.longitude
                
                getMiddleLocation (pos2, index, size)
            }
        }
    }
}
