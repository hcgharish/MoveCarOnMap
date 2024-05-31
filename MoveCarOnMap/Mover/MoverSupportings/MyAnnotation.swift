//
//  MyAnnotation+Extension.swift
//  MoveCarOnMap
//
//  Created by Apple Care on 30/05/24.
//

import Foundation
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D

    var title: String?
    var isDriver = false
    var degree: Int = 0
    var sleepTime: Double = 0.0
    var isAnimatingPins: Bool!
    var id: String? = nil
    var uiimage: UIImage!
    var mkAnnotationView: MKAnnotationView?
    
    init(title: String, coordinate: CLLocationCoordinate2D, isDriver: Bool, id: String) {
        self.title = title
        self.coordinate = coordinate
        self.isDriver = isDriver
        self.id = id
    }
    
    deinit {
        title = nil
        id = nil
        uiimage = nil
    }
}
