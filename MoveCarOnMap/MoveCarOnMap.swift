//
//  ViewController.swift
//  CoewData
//
//  Created by Apple Care on 24/05/24.
//

import UIKit
import CoreData
import MapKit

class MoveCarOnMap: UIViewController {
    @IBOutlet weak var mapMy: MKMapView!
    
    var moveCarOnMapViewModel: MoveCarOnMapViewModel!
    
    let sourceLocation = CLLocationCoordinate2D(latitude: 22.713906, longitude: 75.875107)
    let destinationLocation = CLLocationCoordinate2D(latitude: 22.711811, longitude: 75.882065)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        moveCarOnMapViewModel = MoveCarOnMapViewModel(mapMover: mapMy, sourceLocation: sourceLocation, destinationLocation: destinationLocation)
        
        let thirdLocation = CLLocationCoordinate2D(latitude: 22.723641, longitude: 75.891746)

        addNewLocation(location: thirdLocation)
    }
    
    func addNewLocation(location: CLLocationCoordinate2D) {
        moveCarOnMapViewModel.addNewLocation(location: location)
    }
}
