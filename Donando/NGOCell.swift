//
//  NGOCell.swift
//  Donando
//
//  Created by Halil Gursoy on 16/06/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit

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
        
        phoneButton.hidden = viewModel.telephone?.isEmpty ?? true
    }
}
