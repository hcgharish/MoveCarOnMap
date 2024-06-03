//
//  MoveAnnotation.swift
//  Node
//
//  Created by Avinash somani on 20/04/17.
//  Copyright © 2017 Kavyasoftech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MoveAnnotation: NSObject {
    var map: MKMapView!
    var destinationLocation: CLLocationCoordinate2D?
    var showMoverInCenter: ShowMoverInCenter
    
    let moverAnnotation: MyAnnotation
    
    var routePoints: NSMutableArray? = NSMutableArray()
    
    var lastAddedLocation: CLLocationCoordinate2D?
    
    var poliLine: MKPolyline?
    var moverLastLocation: CLLocation?
    
    init(map: MKMapView, destinationLocation: CLLocationCoordinate2D, moverAnnotation: MyAnnotation, showMoverInCenter: ShowMoverInCenter) {
        self.map = map
        self.destinationLocation = destinationLocation
        self.moverAnnotation = moverAnnotation
        self.showMoverInCenter = showMoverInCenter
    }
    
    deinit {
        map = nil
        routePoints = nil
        destinationLocation = nil
        lastAddedLocation = nil
        poliLine = nil
    }
}
