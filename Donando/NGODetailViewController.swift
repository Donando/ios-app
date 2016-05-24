//
//  NGODetailViewController.swift
//  Donando
//
//  Created by Halil Gursoy on 27/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit
import MapKit


class NGODetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telephoneButton: UIButton!
    @IBOutlet weak var openingHoursButton: UIButton!
    
    @IBOutlet weak var demandsLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UILabel!
    @IBOutlet weak var openWebsiteButton: UIButton!
    
    var ngo: NGO?
    var ngoAnnotation: NGOAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    func setupUI() {
        telephoneButton.tintColor = UIColor.mainTintColor()
        openingHoursButton.tintColor = UIColor.mainTintColor()
        openWebsiteButton.setTitleColor(UIColor.mainTintColor(), forState: .Normal)
    }
    
    func updateUI() {
        guard let ngo = ngo else { return }
        
        if let annotation = ngoAnnotation {
            mapView.removeAnnotation(annotation)
        }
        
        let annotation = NGOAnnotation(ngo: ngo)
        mapView.addAnnotation(annotation)
        
        ngoAnnotation = annotation
        
        nameLabel.text = ngo.name
        addressLabel.text = ngo.address
        telephoneButton.setTitle(ngo.phoneNumber, forState: .Normal)
        
        demandsLabel.text = ngo.demands?.joinWithSeparator("\n")
        
        if let openingHours = ngo.openingHours {
            openingHoursButton.setTitle(openingHours, forState: .Normal)
            openingHoursButton.hidden = false
        } else {
            openingHoursButton.hidden = true
        }
    }
    
    @IBAction func openWebsite() {
        guard let websiteURLString = ngo?.websiteURL,
            websiteURL = NSURL(string: websiteURLString)
            else { return }
        UIApplication.sharedApplication().openURL(websiteURL)
    }
}


extension NGODetailViewController: MKMapViewDelegate {
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(NGOAnnotation) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(NGOAnnotation.reuseIdentifier) as? MKPinAnnotationView
            
            if let annotationView = annotationView {
                annotationView.annotation = annotation
            } else {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: NGOAnnotation.reuseIdentifier)
                annotationView?.pinTintColor = UIColor.mainTintColor()
                annotationView?.animatesDrop = true
                annotationView?.canShowCallout = true
            }
            
            return annotationView
        }
        
        return nil
    }
}