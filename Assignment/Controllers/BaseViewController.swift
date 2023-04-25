//
//  BaseViewController.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

//--- To enable BaseviewController to be instantiable From storyboard id -----
protocol InstantiableFromStoryboard {
    static var storyBoardId: String { get }
    static var storyBoardName: String{ get }
    static func instantiateFromStoryBoard() -> Self//-----optional func
}

extension InstantiableFromStoryboard {
    static func instantiateFromStoryBoard() -> Self {
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: storyBoardId)
        return vc as! Self
    }
}

typealias BaseViewController = BaseViewControllerClass & InstantiableFromStoryboard

class BaseViewControllerClass: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
