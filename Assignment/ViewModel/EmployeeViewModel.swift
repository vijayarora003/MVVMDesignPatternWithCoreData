//
//  AssignmentViewModel.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

enum GroupBy {
    case name
    case team
}

protocol EmployeeViewOutputDelegate: AnyObject {
    func show(message: String)
}

protocol EmployeeViewDelegate {
    init(delegate: EmployeeViewOutputDelegate,
         coreDataManagerDelegate: CoreDataManagerDelegate,
         apiRequestDelegate: APIRequestDelegate)
    func loadEmployee()
}

class EmployeeViewModel: EmployeeViewDelegate {

    private weak var delegate: EmployeeViewOutputDelegate?
    private weak var coreDataManagerDelegate: CoreDataManagerDelegate?
    private weak var apiRequestDelegate: APIRequestDelegate?
    
    required init(delegate: EmployeeViewOutputDelegate,
                  coreDataManagerDelegate: CoreDataManagerDelegate,
                  apiRequestDelegate: APIRequestDelegate) {
        self.delegate = delegate
        self.coreDataManagerDelegate = coreDataManagerDelegate
        self.apiRequestDelegate = apiRequestDelegate
    }
    
    func loadEmployee() {
        delegate?.show(message: StringConstants.loading)
        apiRequestDelegate?.perform(path: API.getEmployees.getURL()) { [weak self] (model: EmployeeModel?, error: String?) in
            guard let self = self, let model = model else { return }
            if let list = model.employees, list.count > 0 {
                self.coreDataManagerDelegate?.saveRecord(employees: list)
            } else {
                self.delegate?.show(message: StringConstants.notDataMessage)
            }
        }
    }
}
