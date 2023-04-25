//
//  APIConstants.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

struct APIConstants {
    static let BASEURL = "https://s3.amazonaws.com"
    static let VERSION = BASEURL + "/sq-mobile-interview/"
    static let IMAGE_BASE_URL = "http://openweathermap.org/img/wn/"
}

enum API {
    case getEmployees
    case none
    
    func getURL() -> String {
        switch self {
        case .getEmployees:
            return APIConstants.VERSION + "employees.json"
        case .none:
            return ""
        }
    }
}
