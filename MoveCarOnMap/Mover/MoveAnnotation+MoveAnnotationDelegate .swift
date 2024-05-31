//
//  MoveAnnotation+MoveAnnotationDelegate .swift
//  MoveCarOnMap
//
//  Created by Apple Care on 31/05/24.
//

import Foundation
import MapKit

protocol AddNewLocationToMover {
    func addNewLocation (location: CLLocationCoordinate2D)
}

protocol MoveAnnotationDelegate {
    func start ()
    func moveAnnotation ()
}

extension CLLocationCoordinate2D {
    func location() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension CLLocation {
    func coordinate2D() -> CLLocationCoordinate2D {
        return self.coordinate
    }
}

extension MoveAnnotation: AddNewLocationToMover {
    func addNewLocation (location: CLLocationCoordinate2D) {
        if lastAddedLocation == nil {
            lastAddedLocation = location
        }
        
        var ob = CalculatePath(locationSource: lastAddedLocation!, locationDestination: location)
        
        let obReturn = ob.makePath()
        
        if obReturn.points.count > 0, obReturn.distance > 0.0 {
            routePoints!.add(obReturn)
        }
        
        lastAddedLocation = location
    }
}

extension MoveAnnotation: MoveAnnotationDelegate {
    
    func start () {
        addNewLocation(location: moverAnnotation.coordinate)
        
        moveAnnotation ()
    }
    
    func moveAnnotation () {
        DispatchQueue.global().async {
            while (true) {
                var boolWait = true
                
                if let count = self.routePoints?.count, count > 0, let ob = self.routePoints?[0] as? CalculatePathReturn {
                    self.routePoints?.removeObject(at: 0)
                    
                    let count = ob.points.count
                    
                    if count > 0, ob.distance > 0 {
                        
                        //let sleepFor = Double(sleepTime) / Double(count * 8)
                        let sleepFor = Double(SleepTime.sleepTime) / Double(count * 1)
                        boolWait = false
                        
                        for i in 0..<Int(count) {
                            let loc = CLLocationCoordinate2DMake((ob.points[i][0]), (ob.points[i][1]))
                            
                            if loc.latitude != 0.0 && loc.longitude != 0.0 {
                                self.move (self.moverAnnotation, loc, sleepFor)
                            }
                            
                            usleep(useconds_t(Int(sleepFor)))
                        }
                    }
                }
                
                if boolWait {
                    usleep(SleepTime.oneSecond)
                }
            }
        }
    }
    
    private func move (_ ano: MyAnnotation, _ point: CLLocationCoordinate2D, _ sleep: Double) {
        DispatchQueue.main.async {
            if self.poliLine != nil {
                self.map.removeOverlay(self.poliLine!)
            }
            
            if self.destinationLocation != nil {
                let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: 2)
                
                let loc1 = self.destinationLocation!
                let loc2 = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                
                coords[0] = loc1
                coords[1] = loc2
                
                let self_poliLine = MKPolyline.init(coordinates: coords, count: 2)
                
                self.poliLine = self_poliLine
                
                self.map.addOverlay(self_poliLine)
            }
            
            if self.moverLastLocation != nil {                
                let location = point.location()
                
                let degree = BearingBetweenTwoPoints().getBearingBetweenTwoPoints (location, self.moverLastLocation!)
                
                // Move annotationView with route direction
                ano.mkAnnotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(BearingBetweenTwoPoints().degreesToRadians(degree)))
                
                self.moverLastLocation = location
            } else {
                self.moverLastLocation = CLLocation (latitude: point.latitude, longitude: point.longitude)
            }
            
            ano.coordinate = point
            
            self.showMoverInCenter.addCenterLocationForMap(location: point)
        }
    }
}
