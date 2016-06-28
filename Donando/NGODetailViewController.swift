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
    
    @IBOutlet var actionButtons: [UIButton]!
    
    @IBOutlet weak var demandsLabel: UILabel!
    @IBOutlet weak var seeMoreButton: UILabel!
    @IBOutlet weak var detailContainerView: UIView!
    
    @IBOutlet weak var demandsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ngo: NGO?
    var ngoAnnotation: NGOAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.translucent = true
        
        setNavigationBarAlpha(0)
        
        for button in actionButtons {
            button.backgroundColor = UIColor.mainTintColor()
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            button.layer.cornerRadius = button.frame.width / 2
        }
        
        zoomMapIntoDefaultLocation()
        
    }
    
    private func zoomMapIntoDefaultLocation() {
        guard let ngo = ngo else { return }
        let defaultRegion = MKCoordinateRegionMakeWithDistance(ngo.coordinate, 9000, 9000)
        mapView.region = defaultRegion
    }
 
    
    private func updateUI() {
        guard let ngo = ngo else { return }
        
        if let annotation = ngoAnnotation {
            mapView.removeAnnotation(annotation)
        }
        
        let annotation = NGOAnnotation(ngo: ngo)
        mapView.addAnnotation(annotation)
        
        ngoAnnotation = annotation
        
        title = ngo.name
        
        nameLabel.text = ngo.name
        addressLabel.text = ngo.address
        
        demandsLabel.text = ngo.demands?.joinWithSeparator("\n")
        
        demandsHeightConstraint.constant = demandsLabel.text?.heightWithConstrainedWidth(demandsLabel.frame.width, font: demandsLabel.font) ?? 0
    }
    
    private func setNavigationBarAlpha(alpha: CGFloat) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(white: 0, alpha: alpha)]
        
        let color = UIColor(white: 1, alpha: alpha)
        let image = UIImage.imageFromColor(color, size: CGSizeMake(1, 1))
        
        navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
    }
    
    @IBAction func openWebsite() {
        guard let websiteURLString = ngo?.websiteURL,
            websiteURL = NSURL(string: websiteURLString)
            else { return }
        UIApplication.sharedApplication().openURL(websiteURL)
    }
}

extension NGODetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetRate = max(scrollView.contentOffset.y, 0) / (nameLabel.frame.origin.y + detailContainerView.frame.origin.y + nameLabel.frame.height)
        let navigationBarAlpha = min(1, offsetRate)
        
        if navigationBarAlpha == 0 || navigationBarAlpha == 1 {
            setNavigationBarAlpha(navigationBarAlpha)
        }
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
