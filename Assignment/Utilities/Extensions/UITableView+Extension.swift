//
//  UITableView+Extension.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let identifier = String(describing: type)
        self.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeue<T: UITableViewCell>(with type: T.Type, indexPath: IndexPath) -> T {
        let cellId = String(describing: type)
        return dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! T
    }
}

