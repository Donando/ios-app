//
//  LoadingView.swift
//  Donando
//
//  Created by Halil Gursoy on 23/05/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit

/**
 A view that include activity to display user while some time consuming process is taking place. It allows
 - strt/end animation
 - show/hide itself
 */
public class LoadingView: UIView {
    
    private var activityIndicator: UIActivityIndicatorView
    public var counter = 0
    
    override public init(frame: CGRect) {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        activityIndicator.center = center
        
        addSubview(activityIndicator)
    }
    
    public func startAnimating() -> LoadingView {
        activityIndicator.startAnimating()
        return self
    }
    
    public func stopAnimating() -> LoadingView {
        activityIndicator.stopAnimating()
        layer.opacity = 0
        return self
    }
    
    public static func show(inView view: UIView) -> LoadingView {
        let loadingView = LoadingView(frame: view.bounds).startAnimating()
        loadingView.counter = 1
        view.addSubview(loadingView)
        
        return loadingView
    }
    
    public func increaseCounter() {
        counter = counter + 1
    }
    
    public func remove() {
        counter = counter - 1
        if counter == 0 {
            stopAnimating()
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { [weak self] in
                self?.alpha = 0
                }, completion: { [weak self] _ in
                    self?.removeFromSuperview()
                })
        }
    }
    
}
