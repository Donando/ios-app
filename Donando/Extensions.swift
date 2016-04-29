//
//  Extensions.swift
//  Donando
//
//  Created by Halil Gursoy on 25/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit


/**
 Extending Int to enhance it to use it with user readble time
 */
public extension Int {
    
    public var second: NSTimeInterval {
        return NSTimeInterval(self)
    }
    
    public var seconds: NSTimeInterval {
        return NSTimeInterval(self)
    }
    
    public var minute: NSTimeInterval {
        return NSTimeInterval(self * 60)
    }
    
    public var minutes: NSTimeInterval {
        return self.minute
    }
    
    public var hour: NSTimeInterval {
        return NSTimeInterval(self * 3600)
    }
    
    public var hours: NSTimeInterval {
        return self.hour
    }
    
    public var day: NSTimeInterval {
        return NSTimeInterval(self * 86400)
    }
    
    public var days: NSTimeInterval {
        return self.day
    }
    
    public var week: NSTimeInterval {
        return NSTimeInterval(self * 86400 * 7)
    }
    
    public var weeks: NSTimeInterval {
        return self.week
    }
    
    public func isBitSet(position: Int) -> Bool {
        return (self & (1 << position)) != 0
    }
    
}


/**
 Extending Double add more functionality to it such as
 1. Get Max
 */
public extension Double {
    
    public func max() -> Double {
        return DBL_MAX
    }
}




extension UIColor {
    static func mainTintColor() -> UIColor {
        return UIColor(red: 245/255.0, green: 170/255.0, blue: 47/255.0, alpha: 1.0)
    }
    
    static func secondaryTintColor() -> UIColor {
        return UIColor(red: 252/255.0, green: 88/255.0, blue: 48/255.0, alpha: 1.0)
    }
    
    static func lightTintColor() -> UIColor {
        return UIColor(colorLiteralRed: 91, green: 208, blue: 97, alpha: 1.0)
    }
    
    static func borderLightGrayColor() -> UIColor {
        return UIColor(red: 214/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1.0)
    }
}

extension UIViewController {
    func configureNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain,
            target: nil,
            action: nil)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func addCloseButton() {
        let buttonItem = UIBarButtonItem(title: "×", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(dismiss))
        let font = UIFont.systemFontOfSize(40)
        buttonItem.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
        buttonItem.setTitlePositionAdjustment(UIOffsetMake(0, 10), forBarMetrics: .Default)
        navigationItem.leftBarButtonItem = buttonItem
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func back() {
        navigationController?.popViewControllerAnimated(true)
    }
}
