//
//  AssignmentModel.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import Foundation

// MARK: - EmployeeModel
struct EmployeeModel: Codable {
    let employees: [Employee]?
}

// MARK: - Employee
struct Employee: Codable {
    let uuid, fullName, phoneNumber, emailAddress: String?
    let biography: String?
    let photoURLSmall, photoURLLarge: String?
    let team: String?
    let employeeType: EmployeeType?

    enum CodingKeys: String, CodingKey {
        case uuid
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case team
        case employeeType = "employee_type"
    }
}

enum EmployeeType: String, Codable {
    case contractor = "CONTRACTOR"
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    
    func getType() -> String {
        switch self {
        case .contractor:
            return StringConstants.contractor
        case .fullTime:
            return StringConstants.fullTime
        case .partTime:
            return StringConstants.partTime
        }
    }
}

