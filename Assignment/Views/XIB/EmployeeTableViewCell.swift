//
//  AssignmentTableViewCell.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

final class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet private weak var employeeTypeLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var employeeNameLabel: UILabel!
    @IBOutlet private weak var employeeImageView: UIImageView!
    @IBOutlet private weak var bioGraphyLabel: UILabel!
    @IBOutlet private weak var teamLabel: UILabel!
    
    var model: Records? {
        didSet {
            guard let model = model else { return }
            employeeNameLabel.text = model.fullName
            phoneLabel.text = model.phoneNumber
            bioGraphyLabel.text = model.biography
            teamLabel.text = "\(StringConstants.team): \(model.team ?? "")"
            employeeTypeLabel.text = EmployeeType(rawValue: model.employeeType ?? "")?.getType()
            employeeImageView.downloadImage(model.photoURLSmall)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
