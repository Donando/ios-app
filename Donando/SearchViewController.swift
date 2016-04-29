//
//  ViewController.swift
//  Donando
//
//  Created by Halil Gursoy on 25/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit
import MapKit
import Result

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBox: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var demandSearchBox: UIView!
    
    @IBOutlet weak var zipCodeSearchField: UITextField!
    @IBOutlet weak var demandSearchField: UITextField!
    
    @IBOutlet weak var listViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    
    var ngos = [NGO]()
    var ngoAnnotations = [NGOAnnotation]()
    
    let dataStore = DataStore(dataClient: APIClient())
    
    var listViewExpanded = false
    
    var searchViewShown: Bool {
        return searchViewHeightConstraint.constant != 0
    }
    
    var zipCodeSearchText = ""
    var demandSearchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Suche"
        
        setupUI()
        loadData()
        
        searchViewTopConstraint.constant = -view.frame.height
    }
    
    private func loadData() {
        let ngoFuture = dataStore.getAllNGOs()
        ngoFuture.onSuccess(callback: handleNGOsLoaded)
    }
    
    private func handleNGOsLoaded(ngos: [NGO]) {
        self.ngos = ngos
        
        for (index, ngo) in ngos.enumerate() {
            let annotation = NGOAnnotation(ngo: ngo, index: index)
            mapView.addAnnotation(annotation)
        }
        
        tableView.reloadData()
    }

    private func setupUI() {
        navigationController?.navigationBarHidden = true
        
        searchBox.layer.cornerRadius = 5
        searchBox.layer.borderWidth = 1
        searchBox.layer.borderColor = UIColor.borderLightGrayColor().CGColor
        demandSearchBox.layer.cornerRadius = 5
        demandSearchBox.layer.borderWidth = 1
        demandSearchBox.layer.borderColor = UIColor.borderLightGrayColor().CGColor
        
        searchButton.backgroundColor = UIColor.mainTintColor()
        searchButton.layer.cornerRadius = 5
        
        listContainerView.backgroundColor = UIColor(white: 1, alpha: 0.85)
        listButton.setTitleColor(UIColor.mainTintColor(), forState: .Normal)
        listButton.tintColor = UIColor.mainTintColor()
        
        tableView.tableFooterView = UIView()
        
        registerNibs()
        
        let defaultRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 52.518076, longitude: 13.403136), 100000, 100000)
        mapView.region = defaultRegion
    }
    
    @IBAction func dismissKeyboard() {
        updateSearchBox()
        moveSearchView(up: true)
        view.endEditing(true)
    }
    
    @IBAction func toggleListView() {
        moveListView(up: !listViewExpanded)
    }
    
    func openNGODetail(index: Int) {
       performSegueWithIdentifier("showNGODetail", sender: index)
    }
    
    func annotationInfoButtonPressed(infoButton: UIButton) {
        openNGODetail(infoButton.tag)
    }
    
    func moveListView(up up: Bool) {
        let heightConstraint = up ? view.frame.height - 52 : 52
        let listButtonTitle = up ? "Karte" : "Liste"
        let listButtonImage = up ? "downArrow" : "upArrow"
        
        listViewExpanded = up
        
        listViewHeightConstraint.constant = heightConstraint
        listButton.alpha = 0
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
            }) { _ in
                self.listButton.setTitle(listButtonTitle, forState: .Normal)
                self.listButton.setImage(UIImage(named: listButtonImage), forState: .Normal)
                self.listButton.alpha = 1
        }
    }
    
    func moveSearchView(up up: Bool) {
        let heightConstraint = up ? 0 : view.frame.height
        let topConstraint = up ? -view.frame.height : 0
        
        let searchBoxTitle = up ? "Suchen" : "Wie lautet deine PLZ?"
        
        searchViewHeightConstraint.constant = heightConstraint
        searchViewTopConstraint.constant = topConstraint
        UIView.animateWithDuration(0.4, animations: { 
            self.view.layoutIfNeeded()
            self.zipCodeSearchField.placeholder = searchBoxTitle
            }, completion: { _ in
                
        })
        
        if !up  {
            zipCodeSearchField.text = zipCodeSearchText
            demandSearchField.text = demandSearchText
        }
    }
    
    func updateSearchBox() {
        var searchBoxTitle = zipCodeSearchText + ", " + demandSearchText
        
        if zipCodeSearchText.characters.isEmpty && demandSearchText.characters.isEmpty {
            searchBoxTitle = ""
        }
        
        zipCodeSearchField.text = searchBoxTitle
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let index = sender as? Int,
            destinationViewController = segue.destinationViewController as? NGODetailViewController where segue.identifier == "showNGODetail" {
            
            let ngo = ngos[index]
            destinationViewController.ngo = ngo
        }
    }
}

extension SearchViewController {
    
    func doSearch() {
        zipCodeSearchText = zipCodeSearchField.text ?? ""
        demandSearchText = demandSearchField.text ?? ""
        
        updateSearchBox()
    }
    
    @IBAction func searchButtonPressed() {
        doSearch()
        moveSearchView(up: true)
        view.endEditing(true)
    }
}

extension SearchViewController: MKMapViewDelegate {

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
                infoButton.addTarget(self, action: #selector(annotationInfoButtonPressed(_:)), forControlEvents: .TouchUpInside)
                
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

extension SearchViewController: UITableViewDataSource {
    
    func registerNibs() {
        tableView.registerNib(UINib(nibName: NGOCell.nib, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: NGOCell.reuseIdentifier)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ngos.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Liste"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(NGOCell.reuseIdentifier) as? NGOCell  else { return UITableViewCell() }
        
        let ngo = ngos[indexPath.row]
        let viewModel = NGOCell.ViewModel(name: ngo.name, telephone: ngo.phoneNumber, address: ngo.address)
        
        cell.updateWithViewModel(viewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.clearColor()
        
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        headerView.textLabel?.textAlignment = .Center
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openNGODetail(indexPath.row)
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view?.isDescendantOfView(tableView) ?? false {
            return false
        }
        return true
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == zipCodeSearchField && !searchViewShown {
            moveSearchView(up: false)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
}

 class NGOCell: UITableViewCell {
    static let reuseIdentifier = "NGOCell"
    static let nib = "NGOCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var infoButton: UIImageView!
    
    struct ViewModel {
        let name: String
        let telephone: String?
        let address: String
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        infoButton.tintColor = UIColor.mainTintColor()
        phoneButton.tintColor = UIColor.mainTintColor()
        selectionStyle = .None
    }
    
    func updateWithViewModel(viewModel: ViewModel) {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        phoneButton.setTitle(viewModel.telephone, forState: .Normal)
    }
}
