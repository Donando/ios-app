//
//  NGOMapDataSource.swift
//  Donando
//
//  Created by Halil Gursoy on 16/06/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit
import BrightFutures
import MapKit

class NgoMapDataSource: NSObject {
    
    private let mapView: MKMapView
    private var loadingView: LoadingView?
    private var ngoAnnotations = [NGOAnnotation]()
    private let annotationInfoButtonPressed: ((_: UIButton) -> Void)
    
    required init(mapView: MKMapView, annotationInfoButtonPressed: ((_: UIButton) -> Void)) {
        self.mapView = mapView
        self.annotationInfoButtonPressed = annotationInfoButtonPressed
    }
    
    func handleInfoButtonPressed(button: UIButton) {
        annotationInfoButtonPressed(button)
    }
    
    func zoomMapInto(coordinate: CLLocationCoordinate2D, distance: CLLocationDistance = 80000) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        mapView.region = region
    }
}

extension NgoMapDataSource: NgoDataSourceConsumer {
    func handle(ngos: [NGO]) {
        mapView.removeAnnotations(ngoAnnotations)
        for (index, ngo) in ngos.enumerate() {
            let annotation = NGOAnnotation(ngo: ngo, index: index)
            ngoAnnotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
        
        if let coordinate = ngos.first?.coordinate {
            zoomMapInto(coordinate)
        }
    }
}

extension NgoMapDataSource: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? NGOAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(NGOAnnotation.reuseIdentifier) as? MKPinAnnotationView
            
            if let annotationView = annotationView {
                annotationView.annotation = annotation
            } else {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: NGOAnnotation.reuseIdentifier)
                annotationView?.pinTintColor = UIColor.mainTintColor()
                annotationView?.animatesDrop = true
                annotationView?.canShowCallout = true
                
                let infoButton = UIButton(type: .InfoDark)
                infoButton.tag = annotation.ngoIndex
                infoButton.addTarget(self, action: #selector(handleInfoButtonPressed(_:)), forControlEvents: .TouchUpInside)
                
                annotationView?.rightCalloutAccessoryView = infoButton
                
                let callButton = UIButton(type: .Custom)
                callButton.setImage(UIImage(named: "telephone"), forState: .Normal)
                callButton.frame = CGRect(origin: CGPointZero, size: CGSize(width: 51, height: 51))
                callButton.backgroundColor = UIColor.mainTintColor()
                callButton.tintColor = UIColor.whiteColor()
                
                annotationView?.leftCalloutAccessoryView = callButton
            }
            return annotationView
        }
        return nil
    }

}
