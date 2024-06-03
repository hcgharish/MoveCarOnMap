//
//  MoveAnnotation+MoveAnnotationDelegate .swift
//  MoveCarOnMap
//
//  Created by Apple Care on 31/05/24.
//

import Foundation
import MapKit

protocol MoveAnnotationDelegate {
    func start ()
    func moveAnnotation ()
}

extension MoveAnnotation: MoveAnnotationDelegate {
    
    func start () {
        addNewLocation(location: moverAnnotation.coordinate)
        
        moveAnnotation ()
    }
    
    func moveAnnotation () {
        DispatchQueue.global().async {
            while (true) {
                let boolWait = self.moveDecision()
                
                if boolWait {
                    usleep(SleepTime.oneSecond)
                }
            }
        }
    }
    
    private func getTopCalculatePathReturn() -> (obj: CalculatePathReturn?, count: Int) {
        if let points = routePoints?.count, points > 0, let calculatePathReturn = routePoints?[0] as? CalculatePathReturn {
            routePoints?.removeObject(at: 0)
            
            return (calculatePathReturn, points)
        }
        
        return (nil, 0)
    }
    
    private func moveDecision() -> Bool {
        var boolWait = true
        
        let touple = getTopCalculatePathReturn()

        if let calculatePathReturn = touple.obj {
            let totalPoints = calculatePathReturn.points.count
            
            if calculatePathReturn.isValid() {
                let sleepFor = Double(SleepTime.sleepTime) / Double(totalPoints * 1)
                boolWait = false
                
                for i in 0..<Int(totalPoints) {
                    let loc = calculatePathReturn.getLocationFor(index: i)
                    
                    if loc.isValidLocation() {
                        move (moverAnnotation, loc, sleepFor)
                    }
                    
                    usleep(useconds_t(Int(sleepFor)))
                }
            }
        }
        
        return boolWait
    }
    
    private func getMKPolyline(location: CLLocationCoordinate2D) -> MKPolyline? {
        if let destinationLocation = self.destinationLocation {
            let coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: 2)
            
            coords[0] = destinationLocation
            coords[1] = location
            
            return MKPolyline.init(coordinates: coords, count: 2)
        }
        
        return nil
    }
    
    private func move (_ annotation: MyAnnotation, _ point: CLLocationCoordinate2D, _ sleep: Double) {
        DispatchQueue.main.async {
            if self.poliLine != nil {
                self.map.removeOverlay(self.poliLine!)
            }
            
            if let poliLine = self.getMKPolyline(location: point) {
                self.poliLine = poliLine
                
                self.map.addOverlay(poliLine)
            }
            
            let location = point.location()

            if let moverLastLocation = self.moverLastLocation {
                annotation.mkAnnotationView?.transform = BearingBetweenTwoPoints().getCGAffineTransform(location1: location, location2: moverLastLocation)
            }
            
            self.moverLastLocation = location

            annotation.coordinate = point
            
            self.showMoverInCenter.addCenterLocationForMap(location: point)
        }
    }
}
