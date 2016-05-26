//
//  InfoViewController.swift
//  Donando
//
//  Created by Halil Gursoy on 25/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit
import MessageUI

public class InfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum CellType {
        case Weblink
        case Contact
        case SupportPhone
        case ReportBug
    }
    
    struct TableCell {
        var cellType: CellType
        var cellTitle: String
        var cellDetailText: String?
        var cellContent: String?
    }
    
    var infoData = [[TableCell]]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Info"
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        setupTableView()
        setupDataSource()
    }
    
    private func setupTableView() {
        tableView.alwaysBounceVertical = false
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
    private func setupContentOfCell(cell: UITableViewCell, withData cellData: TableCell) {
        cell.textLabel?.text = cellData.cellTitle
        cell.detailTextLabel?.text = cellData.cellDetailText
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    private func setupDataSource() {
        infoData = [
            [
                TableCell(cellType: .Contact, cellTitle: "Feedback Geben", cellDetailText: nil, cellContent: nil)
            ]
        ]
    }
    
    private func openContact() {
        guard MFMailComposeViewController.canSendMail() else { return }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.prepopulateSupportEmail()
        
        presentViewController(mailVC, animated: true, completion: nil)
    }
}

extension InfoViewController: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return infoData.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoData[section].count
    }
    
}

extension InfoViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellData = infoData[indexPath.section][indexPath.row]
        
        let cell = InfoTableViewCell(style: cellData.cellDetailText != nil ? .Value1 : .Default, reuseIdentifier: "infoCell")
        
        setupContentOfCell(cell, withData: cellData)
        cell.setupFontsAndColorsInCell(cell)
        
        cell.accessoryView = nil
        cell.title = cellData.cellTitle
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellData = infoData[indexPath.section][indexPath.row]
        
        switch cellData.cellType {
        case .Contact:
            openContact()
        default:
            break
        }
    }
}

extension InfoViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(controller: MFMailComposeViewController,
                                      didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}


public class InfoTableViewCell: UITableViewCell {
    
    typealias InfoTableViewCellCallback = ((enabled: Bool) -> (Void))
    var title: String?
    var switchCallback: InfoTableViewCellCallback?
    lazy var accessorySwitch: UISwitch? = self.createAccessorySwitch()
    
    /**
     Updates font and colors
     
     - parameter cell: UITableViewCell - cell to update
     */
    func setupFontsAndColorsInCell(cell: UITableViewCell) {
//        cell.textLabel!.font = UIFont.regularFont(size: 15)
        guard let detailLabel = cell.detailTextLabel else { return }
//        detailLabel.font = UIFont.regularFont(size: 13)
//        detailLabel.textColor = LoungeColor.Gray
    }
    
    /**
     Adds and setsup call back for an switch as accessory type
     
     - parameter callback: LoungeTableViewCellCallback - callback closure
     */
    func setupAccessorySwitch(callback: InfoTableViewCellCallback) {
        accessoryView = accessorySwitch
        switchCallback = callback
    }
    
    /**
     Invoked when accesspry switch value is changed.
     
     - parameter sender: UISwitch - accessory switch
     */
    func switchStateChanged(sender: UISwitch) {
        switchCallback?(enabled: sender.on)
    }
    
    /**
     Creates an instance of UISwitch
     
     - returns: UISwitch - a cool looking orange switch
     */
    private func createAccessorySwitch() -> UISwitch {
        let accessorySwitch = UISwitch()
//        accessorySwitch.onTintColor = LoungeColor.Orange
        accessorySwitch.addTarget(self,
                                  action: #selector(switchStateChanged(_:)),
                                  forControlEvents: .ValueChanged)
        return accessorySwitch
    }
}

/**
 Extending MFMailComposeViewController to be able to prepopulate its fields with appropriate support email data
 */
public extension MFMailComposeViewController {
    /**
     Prepopulate MFMailComposeViewController fields with appropriate support email data
     */
    func prepopulateSupportEmail() {
        self.setToRecipients(["info@donando.org"])
        self.setSubject("iOS App Feedback")
        guard let appBundle = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) else { return }
        
        let messageBody = "\n\n\n\n\n" +
            "____\n" +
            "App version: \(appBundle)\n" +
            "iOS version: \(UIDevice.currentDevice().systemVersion)\n" +
        "‾‾‾‾‾"
        self.setMessageBody(messageBody, isHTML: false)
    }
}

