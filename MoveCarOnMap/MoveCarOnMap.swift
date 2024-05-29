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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        showLocationOnMap ()
    }
    
    @IBOutlet weak var mapMy: MKMapView!
    let semaphore1 = DispatchSemaphore(value: 1)
    var providerLocation = CLLocation(latitude: 22.713906, longitude: 75.875107)
    var annoProvider: MyAnnotation?
    let pinSize = 40
    var boolShowAnnotation = false
    var countAno = 0
    var obMoveAnnotation: MoveAnnotation!
}

extension MoveCarOnMap: MKMapViewDelegate {
    func showLocationOnMap () {
        let location: CLLocation = CLLocation(latitude: 22.713906, longitude: 75.875107)
        let location2: CLLocation = CLLocation(latitude: 22.711811, longitude: 75.882065)
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let center2 = CLLocationCoordinate2D(latitude: location2.coordinate.latitude, longitude: location2.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapMy.setRegion(region, animated: true)
        mapMy.delegate = self
        
        let image = #imageLiteral(resourceName: "mycars")
        
        self.addPin(center.latitude, center.longitude, image, true)
        self.addPin(center2.latitude, center2.longitude, image, false)
        
        obMoveAnnotation = MoveAnnotation(mapMy)
        obMoveAnnotation.start()
        
        self.obMoveAnnotation.addNewLocation(center)
        self.obMoveAnnotation.addNewLocation(center2)
        
        let ano = MyAnnotation(title: "Receiver", coordinate: center, isDriver:true, id:"")
        
        let img = image.resize(CGFloat(self.pinSize))
        
        let sz = img.size
        
        var rds = sz.height
        
        if sz.width < sz.height {
            rds = sz.width
        }
        
        ano.uiimage = img.roundedRectImageFromImage(image: img, imageSize: sz, cornerRadius: rds/2)
        
        ano.isAnimatingPins = true
        
        obMoveAnnotation.ano = ano
        
        mapMy.addAnnotation(ano)
    }
    
    func getCenterofMap ()  {
        let centerCoordinate = mapMy.centerCoordinate
        /*userLocation = centerCoordinate
         
         getAddressFromLatLon(centerCoordinate.latitude, centerCoordinate.longitude) { (address, country) in
         if address != nil {
         self.lblAddress.text = address!
         }
         }*/
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getCenterofMap ()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.hexColor(0x2699FB)
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MyAnnotation) {
            return nil
        }
        
        let reuseId = "testwithIdentifier"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
        }
        
        let cpa = annotation as! MyAnnotation
        anView!.image = cpa.uiimage
        
        return anView
    }
    
    func addPin (_ lat: Double, _ lng: Double, _ image: UIImage, _ boolProviderPin: Bool) {
        DispatchQueue.main.async {
            self.semaphore1.wait()
            
            let loc = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            var pinname = "Receiver"
            
            let artwork = MyAnnotation(title: pinname, coordinate: loc, isDriver:true, id:"")
            
            if boolProviderPin {
                pinname = "Provider"
                self.providerLocation = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                
                //print("3 self.providerLocation-\(self.providerLocation)-")
                self.annoProvider = artwork
            }
            
            artwork.title = pinname
            
            let img = image.resize(CGFloat(self.pinSize))
            
            let sz = img.size
            
            var rds = sz.height
            
            if sz.width < sz.height {
                rds = sz.width
            }
            artwork.uiimage = img.roundedRectImageFromImage(image: img, imageSize: sz, cornerRadius: rds/2)
            //artwork.uiimage = image.resize(CGFloat(self.pinSize))
            
            let anno = self.mapMy.annotations
            
            if anno.count > 2 {
                for an in anno {
                    if let ann = an as? MyAnnotation {
                        if ann.title == pinname {
                            return
                        } else if ann.title?.count == 0 {
                            //print("2 Removing anotation-\(ann)-")
                            
                            self.mapMy.removeAnnotation(ann)
                        }
                    }
                }
            }
            
            //print("Harish-2-\(artwork)-\(loc)-")
            
            self.mapMy.addAnnotation(artwork)
            
            self.showAnnotations ()
            
            self.semaphore1.signal()
        }
    }
    
    func showAnnotations () {
        let arr = self.mapMy.annotations
        
        if arr.count == 2 {
            if boolShowAnnotation == false {
                boolShowAnnotation = true
                
                DispatchQueue.main.async {
                    self.mapMy.showAnnotations(arr, animated: true)
                }
            }
            
            countAno += 1
            
            if countAno >= 15 {
                boolShowAnnotation = false
                countAno = 0
            }
        }
    }
}

public extension UIImage {
    func resize(_ wth: CGFloat) -> UIImage {
        let scale = wth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: wth,
                                           height: newHeight))
        self.draw(in: CGRect(x: 0,
                             y: 0,
                             width: wth,
                             height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    func base64 (_ quality: CGFloat) -> String {
        let imageData: NSData = self.pngData()! as NSData
        let bytes = Double(imageData.length)/8.0
        let kbb = bytes/1024.0
        let mbb = kbb/1024.0
        print("imageData size -> KB[\(kbb)],MB[\(mbb)]")
        let profilePicture = imageData.base64EncodedString(options: .lineLength64Characters)
        return profilePicture
    }
}

extension UIImage {
    func roundedRectImageFromImage(image:UIImage, imageSize:CGSize, cornerRadius:CGFloat)->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize,false,0.0)
        let bounds=CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)
        //image.drawInRect(bounds)
        let finalImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
    }
}

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
    class func hexColor(_ rgb: UInt32, alpha: Double=1.0) -> UIColor {
        let red = CGFloat((rgb & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgb & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgb & 0xFF)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
