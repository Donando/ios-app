//
//  AlertHandler.swift
//  Donando
//
//  Created by Halil Gursoy on 28/06/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import UIKit
import Dodo

class AlertHandler {
    let view: UIView
    
    required init(view: UIView, topLayoutGuide: UILayoutSupport? = nil, bottomLayoutGuide: UILayoutSupport? = nil) {
        self.view = view
        setupDodo(topLayoutGuide, bottomLayoutGuide: bottomLayoutGuide)
    }
    
    func setupDodo(topLayoutGuide: UILayoutSupport?, bottomLayoutGuide: UILayoutSupport?) {
        view.dodo.style.leftButton.icon = .Close
        view.dodo.style.leftButton.onTap = hide
        
        view.dodo.bottomLayoutGuide = bottomLayoutGuide
        view.dodo.topLayoutGuide = topLayoutGuide
    }
    
    func showError(message: String) {
        view.dodo.error(message)
        autoHide()
    }
    
    func showSuccess(message: String) {
        view.dodo.success(message)
        autoHide()
    }
    
    func autoHide() {
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
    
    @objc func hide() {
        view.dodo.hide()
    }
}