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
    
    @IBOutlet weak var callButtonContainer: UIView!
    @IBOutlet weak var webButtonContainer: UIView!
    @IBOutlet weak var mapButtonContainer: UIView!
    @IBOutlet weak var shareButtonContainer: UIView!
    
    @IBOutlet var callButtonConstraints: [NSLayoutConstraint]!
    @IBOutlet var webButtonConstraints: [NSLayoutConstraint]!
    @IBOutlet var mapButtonConstraints: [NSLayoutConstraint]!
    @IBOutlet var shareButtonConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var demandsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ngo: NGO?
    var ngoAnnotation: NGOAnnotation?
    
    var alertHandler: AlertHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.translucent = true
        
        setNavigationBarAlpha(0)
        
        setupActionButtons()
        
        alertHandler = AlertHandler(view: view, topLayoutGuide: topLayoutGuide, bottomLayoutGuide: bottomLayoutGuide)
        
        zoomMapIntoDefaultLocation()
    }
    
    
    private func setupActionButtons() {
        for button in actionButtons {
            button.backgroundColor = UIColor.mainTintColor()
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            button.layer.cornerRadius = button.frame.width / 2
        }
    }
    
    private func hideActionButtonContainer(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            constraint.constant = 0
        }
        view.updateConstraints()
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
    
    
}


// MARK: - NGO Actions
extension NGODetailViewController {
    @IBAction func openWebsite() {
        guard let websiteURLString = ngo?.websiteURL,
            websiteURL = NSURL(string: websiteURLString)
            else { return }
        UIApplication.sharedApplication().openURL(websiteURL)
    }
    
    @IBAction func openDirections() {
        guard let ngoAnnotation = ngoAnnotation else { return }
        
        let placemark = MKPlacemark(coordinate: ngoAnnotation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = ngoAnnotation.name
        
        let routingOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(routingOptions)
    }
    
    @IBAction func callNgo() {
        guard let phoneNumber = ngo?.phoneNumber,
            phoneUrl = NSURL(string: "tel://\(phoneNumber)")
            else {
                alertHandler?.showError("Diese Organisation hat leider keine Telefonnumer")
                return
        }
        
        UIApplication.sharedApplication().openURL(phoneUrl)
    }
    
    @IBAction func shareNgo() {
        guard let websiteUrlString = ngo?.websiteURL,
            websiteUrl = NSURL(string: websiteUrlString)
            else {
                return
        }
        
        let vc = UIActivityViewController(activityItems: [websiteUrl], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
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
