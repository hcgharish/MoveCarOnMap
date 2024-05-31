//
//  CalculatePathReturn.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 30/05/24.
//

import Foundation

struct CalculatePathReturn {
    var points: [[Double]]
    var distance: Double
    
    init(points: [[Double]], distance: Double) {
        self.points = points
        self.distance = distance
    }
    
}
